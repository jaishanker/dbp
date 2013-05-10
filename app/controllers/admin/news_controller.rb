class Admin::NewsController < ApplicationController
  
  before_filter :admin_login_required
  before_filter :top_count,:only => [:index,:category,:report]
  layout 'admin_layout'
  
  def index
    @news = News.find_all
    session[:news] = @news
  end
  
  
  def new
    @news = News.new
  end
  
  
  def create
    @news = News.new(params[:news])
    @news.user_id = current_user.id
    @news.status = 1
    @news.save
    if @news.errors.empty?
      
      if params[:photo] 
        if @news.pictures[0].blank?  
          picture = Picture.new 
        else
          picture = @news.pictures[0]
        end
        if request.headers['HTTP_USER_AGENT'].to_s.include?('IE')
          picture.version = "IE"
        else
          picture.version = "Other"
        end
        picture.photo  = params[:photo]
        @news.pictures <<  picture
        
      end 
      flash[:notice] = "News added successfully"
      redirect_to :action => :index
    else
      flash[:error] = "Errors occured while adding News"
      render :action => :new
    end
    
  end

  def edit
    @news = News.find_by_permalink(params[:permalink])
  end

  def update
    @news = News.find_by_permalink(params[:permalink])
    @news.update_attributes(params[:news])
    @news.pictures.build(:photo => params[:photo]) if params[:photo]
    @news.save
    if @news.errors.empty?
      flash[:notice] = "News successfully updated"
      redirect_to :action => :index
    else
      flash[:error] = "Errors occured while updating News"
      render :action => :edit
    end
  end
  
  def update_status
    
    @news = News.find(params[:id])
    unless @news.nil?
      @news.status = params[:status]
      @news.save
      @news.comments.collect{|c| c.status =  params[:status] 
        c.save}
      @news.requests.collect{|r| r.active =  params[:status] 
        r.save}
      if params[:status] == "0"
        params[:status] = "1"
      else
        params[:status] = "0"
      end
      @news.activity_streams.collect{|a| a.status =  params[:status] 
        a.save}
      @news.comments.collect{|c| c.activity_streams.collect{|a| a.update_attribute(:status,params[:status])}}
      message = "show_notice('Status updated successfully','success')"
    else
      message = "show_notice('Item not found','error')"
    end
    
    render :update do |page|
      page << message
    end
    
  end
  
  
  def category
    @news_category = NewsCategory.new
    @categories = NewsCategory.find_all
  end
  
  
  def category_create
    @news_category = NewsCategory.new(params[:news_category])
    @news_category.status = 1
    @news_category.save
    
    render :update do |page|
      if @news_category.errors.empty?
        flash[:notice] = "Category created successfully"
        page.redirect_to "/admin/news/category" 
        
      else
        page.visual_effect  :appear,"error"
        page.replace_html :error,
          :partial => '/layouts/errors'
        page << "show_notice('Errors occured while creating category','error')"
        page << "addError('news_category_name')"
        
        page.delay(10) do
          page.visual_effect  :fade,"error"
        end
        
      end
    end
  end
  
  
  def update_cat_status
    
    @news_category = NewsCategory.find(params[:id])
    unless @news_category.nil?
      @news_category.status = params[:status]
      @news_category.save
      
      
      # updating the news status according to category status
      # when category is deleted the status is updated to 3
      if params[:status] == "1"
        @news_category.news.update_all("status = 1","status = 3")
        @news_category.news.collect{|d| d.comments.update_all("status = 1","status = 3") }   
        @news_category.news.collect{|d| d.requests.update_all("status = 1","status = 3") }                 
      else
        @news_category.news.update_all("status = 3", "status = 1")
        @news_category.news.collect{|d| d.comments.update_all("status = 3","status = 1") }   
        @news_category.news.collect{|d| d.requests.update_all("status = 3","status = 1") }                
      end
      
      # end 
      
      
      
      message = "show_notice('Category status updated successfully','success')"
    else
      message = "show_notice('Category not found','error')"
    end
    
    render :update do |page|
      page << message
    end
    
  end
  
  
  def delete_category
    
    @news_category = NewsCategory.find(params[:id])
    @news_category.destroy unless @news_category.nil?
    flash[:notice] = "Category deleted successfully"
    redirect_to :back
    
  end


  def download

    @news = session[:news] ||  News.find_all

    filepath="News_Report_#{Time.now.utc.strftime('%Y-%d-%m')}.xls"
    workbook=Spreadsheet::Excel.new("#{RAILS_ROOT}/public/report/#{filepath}")
    worksheet=workbook.add_worksheet("News Details")

    worksheet.write(0, 0,"Total " + @news.length.to_s + " news")

    worksheet.write(2, 0, "Index")
    worksheet.write(2, 1, "Name")
    worksheet.write(2, 2, "Start Date")
    worksheet.write(2, 3, "End Date")
    worksheet.write(2, 4, "Views")
    worksheet.write(2, 5, "Comments")


    row = 4
    @news.each_with_index do |n,i|
      worksheet.write(row, 0, i + 1)
      worksheet.write(row, 1, n.title)
      worksheet.write(row, 2, n.start_date.strftime("%d %b %Y"))
      worksheet.write(row, 3, n.end_date.strftime("%d %b %Y"))
      worksheet.write(row, 4, !n.view_count.nil? ? n.view_count.to_s : "0" )
      worksheet.write(row, 5, n.comments.length.to_s)
      row += 1
    end
    workbook.close

    send_file RAILS_ROOT + "/public/report/" + filepath


  end


  def report

    if params[:id]
      @news = News.find_by_id(params[:id])
      @news_name = @news.title
      @news_id = @news.id
      session[:title] = "News  - " + @news_name + " Report"
      @views_count = @news.view_count
      @comments_count = NewsComment.get_count_for_news(@news_id)
    else
      session[:title] = "News  - General Report"
    end
    


    case params[:duration]
    when "2 Weeks"

      session[:duration] = "Last Two Weeks"
      start_date = Date.today.at_beginning_of_week.advance(:weeks => -1)
      split = 'next'
      format = "%d %a"
      query_format = "%Y-%m-%d"
      group = 'date'

    when "Month"

      session[:duration] = "This Month"
      start_date = Date.today.at_beginning_of_month
      split = 'next_week'
      format = "%d %a"
      query_format = "%W"
      group = 'week'

    when "2 Months"

      session[:duration] = "Last Two Months"
      start_date = Date.today.at_beginning_of_month.advance(:months => -1)
      split = 'next_week'
      format = "%d %a"
      query_format = "%W"
      group = 'week'

    when "3 Months"

      session[:duration] = "Last 3 Months"
      start_date = Date.today.at_beginning_of_month.advance(:months => -2)
      split = 'next_month'
      format = "%B"
      query_format = "%m"
      group = 'month'

    when "6 Months"

      session[:duration] = "Last 6 Months"
      start_date = Date.today.at_beginning_of_month.advance(:months => -5)
      split = 'next_month'
      format = "%B"
      query_format = "%m"
      group = 'month'

    when "Year"

      session[:duration] = "This Year"
      start_date = Date.today.at_beginning_of_year
      split = 'next_month'
      format = "%B"
      query_format = "%m"
      group = 'month'

    else
      params[:duration] = "Week"
      session[:duration] = "This Week"
      start_date = Date.today.at_beginning_of_week
      split = 'next'
      format = "%d %a"
      query_format = "%Y-%m-%d"
      group = 'date'

    end
    @start_date = start_date
    logger.info "--------------------------"


    session[:type] = params[:type] || 'View'
    params[:type] = params[:type] || 'View'

    if params[:id]
      case params[:type]
      when "View"
        values = View.get_single_reporting_values(@start_date,'News',group,@news_id)
      when "Comment"
        values = Comment.get_single_reporting_values(@start_date,'News',group,@news_id)
      else
      end
    else
      case params[:type]
      when "View"
        values = View.get_reporting_values(@start_date,'News',group)
      when "Comment"
        values = Comment.get_reporting_values(@start_date,'News',group)
      else
      end
    end
   

    @values = {}
    unless values.nil?
      values.each do |val|
        if query_format == "%m"
          @values[val.splitter.length == 2 ? val.splitter.to_s : '0' + val.splitter.to_s] = val.count
        else
          @values[val.splitter] = val.count
        end

      end
    end
    logger.info "----------------------"
    logger.info @values.inspect

    @output = {}

    i = 0
    while start_date <= Date.today
      logger.info "==========" + start_date.strftime(query_format)
      if query_format == "%W"
        @output[start_date.strftime(format) + "-" + start_date.advance(:days => 6).strftime(format) ] = [ i, @values[start_date.strftime(query_format)].nil? ? 0 : @values[start_date.strftime(query_format)]]
      else
        @output[start_date.strftime(format)] = [ i, @values[start_date.strftime(query_format)].nil? ? 0 : @values[start_date.strftime(query_format)]]
      end

      start_date = eval("start_date." + split)
      i = i + 1
    end

    logger.info @output.sort{|a,b| a[1][0]<=>b[1][0]}.inspect

    session[:output] = @output.sort{|a,b| a[1][0]<=>b[1][0]}
    # render :text => @output.inspect

  end


  def get_xml

    respond_to do |format|
      format.xml
    end

  end


  private
  
  def check_login
    unless logged_in?
      flash[:error] = "Please login first"
      redirect_to "/" and return
    end
  end
  
  def top_count
    @news_count = News.count
    @views_count = News.views_count
    @comments_count = GameComment.get_count
  end
  
end
