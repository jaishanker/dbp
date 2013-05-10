class Admin::LearningsController < ApplicationController
  
  before_filter :admin_login_required
  before_filter :top_count,:only => [:index,:category,:report]
  layout 'admin_layout'
  require 'spreadsheet/excel'
  
  def index
    @learning = Learning.find_all
    session[:learning] = @learning
  end
  
  
  def new
    @learning = Learning.new
  end
  
  
  def create
    params[:learning][:tags] = getTags(params[:learning][:tags])
    @learning = Learning.new(params[:learning])
    @learning.user_id = current_user.id
    @learning.status = 1
    process_file_uploads(@learning)
    @learning.save
    if @learning.errors.empty?
      #       @learning.add_rating Rating.new(:user_id => current_user.id)
      if params[:photo] 
        if @learning.pictures[0].blank?  
          picture = Picture.new 
        else
          picture = @learning.pictures[0]
        end
        if request.headers['HTTP_USER_AGENT'].to_s.include?('IE')
          picture.version = "IE"
        else
          picture.version = "Other"
        end
        picture.photo  = params[:photo]
        @learning.pictures <<  picture
        
      end 
      flash[:notice] = "Learning Material created successfully"
      redirect_to :action => :index
    else
      flash[:error] = "Errors occured while creating Learning Material"
      render :action => :new
    end
    
  end

  def edit
    @learning = Learning.find_by_permalink(params[:permalink])
  end

  def update
    params[:learning][:tags] = getTags(params[:learning][:tags])
    @learning = Learning.find_by_permalink(params[:permalink])
    @learning.update_attributes(params[:learning])
     
    process_file_uploads(@learning)
    @learning.pictures.build(:photo => params[:photo])  if params[:photo]
    @learning.save
     
    if @learning.errors.empty?
      flash[:notice] = "Learning Material successfully updated"
      redirect_to :action => :index
    else
      #      if @learning.errors.on('pictures')
      #        session[:photo_error] = "Please upload valid image file"
      #      else
      #        session[:photo_error] = nil
      #      end
      #      render :action => :edit
      flash[:error] = "Errors occured while updating Learning Material"
      render :action => :edit
    end
  end
  
  def update_status
    
    @learning = Learning.find(params[:id])
    unless @learning.nil?
      @learning.status = params[:status]
      @learning.save
      @learning.comments.collect{|c| c.status =  params[:status] 
        c.save}
      @learning.requests.collect{|r| r.active =  params[:status] 
        r.save}             
      @learning.favorites.collect{|f| f.status =  params[:status] 
        f.save}   
      @learning.learning_tags.collect{|t| t.status =  params[:status] 
        t.save}                                                              
      if params[:status] == "0"
        params[:status] = "1"
      else
        params[:status] = "0"
      end
      @learning.activity_streams.collect{|a| a.status =  params[:status] 
        a.save}                    
      @learning.comments.collect{|c| c.activity_streams.collect{|a| a.update_attribute(:status,params[:status])}}                                                           
      message = "show_notice('Status updated successfully','success')"
    else
      message = "show_notice('Item not found','error')"
    end
    
    render :update do |page|
      page << message
    end
    
  end
  
  
  def category
    @learning_category = LearningCategory.new
    @categories = LearningCategory.find_all
  end
  
  
  def category_create
    @learning_category = LearningCategory.new(params[:learning_category])
    @learning_category.status = 1
    @learning_category.save
    
    render :update do |page|
      if @learning_category.errors.empty?
        flash[:notice] = "Category created successfully"
        page.redirect_to "/admin/learnings/category" 
        
      else
        page.visual_effect  :appear,"error"
        page.replace_html :error,
          :partial => '/layouts/errors'
        page << "show_notice('Errors occured while creating category','error')"
        page << "addError('learning_category_name')"
        
        page.delay(10) do
          page.visual_effect  :fade,"error"
        end
        
      end
    end
  end
  
  
  def update_cat_status
    
    @learning_category = LearningCategory.find(params[:id])
    unless @learning_category.nil?
      @learning_category.status = params[:status]
      @learning_category.save
      
      # updating the learning status according to category status
      # when category is deleted the status is updated to 3
      if params[:status] == "1"
        @learning_category.learnings.update_all("status = 1","status = 3")
        @learning_category.learnings.collect{|d| d.comments.update_all("status = 1","status = 3") }   
        @learning_category.learnings.collect{|d| d.requests.update_all("active = 1","active = 3") }         
        @learning_category.learnings.collect{|d| d.favorites.update_all("status = 1","status = 3") }       
        @learning_category.learnings.collect{|d| d.learning_tags.update_all("status = 1","status = 3") }              
      else
        @learning_category.learnings.update_all("status = 3", "status = 1")
        @learning_category.learnings.collect{|d| d.comments.update_all("status = 3","status = 1") }   
        @learning_category.learnings.collect{|d| d.requests.update_all("active = 3","active = 1") }    
        @learning_category.learnings.collect{|d| d.favorites.update_all("status = 3","status = 1") }        
        @learning_category.learnings.collect{|d| d.learning_tags.update_all("status = 3","status = 1") }                
      end
      if params[:status] == "0"
        params[:status] = "1"
      else
        params[:status] = "0"
      end      
      @learning_category.learnings.collect{|d| d.activity_streams.collect{|a| a.status =  params[:status] 
          a.save}}
      @learning_category.learnings.collect{|d| d.comments.collect{|c| c.activity_streams.collect{|a| a.update_attribute(:status,params[:status])}}}           
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
    
    @learning_category = LearningCategory.find(params[:id])
    @learning_category.destroy unless @learning_category.nil?
    flash[:notice] = "Category deleted successfully"
    redirect_to :back
    
  end
  
  #  def send_file
  #    asset = Asset.find(params[:id])
  #    # do security check here
  #    send_file(asset.data.path, :type => asset.data_content_type)
  #  end
  
  
  
  def abuse_report
    @learning = Learning.find_all_with_abuses
  end
  
  def download
    @learning = session[:learning] ||  Learning.find_all
    
    filepath="Learning_Report_#{Time.now.utc.strftime('%Y-%d-%m')}.xls"
    workbook=Spreadsheet::Excel.new("#{RAILS_ROOT}/public/report/#{filepath}")
    worksheet=workbook.add_worksheet("Learning Details")
    
    worksheet.write(0, 0,"Total " + @learning.length.to_s + " learnings")
    
    worksheet.write(2, 0, "Index")
    worksheet.write(2, 1, "Title")
    #    worksheet.write(2, 2, "Posted By")
    worksheet.write(2, 2, "Date")
    #    worksheet.write(2, 4, "Rating")
    worksheet.write(2, 3, "Views")
    worksheet.write(2, 4, "Favorites")
    worksheet.write(2, 5, "Format")
    worksheet.write(2, 6, "Size")
    #    worksheet.write(2, 7, "Shares")
    
    
    row = 4
    @learning.each_with_index do |l,i|
      worksheet.write(row, 0, i + 1)
      worksheet.write(row, 1, l.title)
      #      worksheet.write(row, 2, l.user.login + " (" + l.user.learnings.length.to_s + ")")
      worksheet.write(row, 2, l.created_at.strftime("%d %b %Y"))
      worksheet.write(row, 3, !l.view_count.nil? ? l.view_count.to_s : "0" )
      worksheet.write(row, 4, l.favorites.length.to_s)
      worksheet.write(row, 5, get_format(l.assets))
      worksheet.write(row, 6, get_size(l.assets) + "MB")
      #      worksheet.write(row, 8, l.shares.length.to_s)
      row += 1
    end
    workbook.close
    
    send_file RAILS_ROOT + "/public/report/" + filepath
    
    
  end
  
  def report
    if params[:id]
      @learning = Learning.find_by_id(params[:id])
      @learning_name = @learning.title
      @learning_id = @learning.id
      session[:title] = "Learning Central - " + @learning_name + " Report"
      @views_count_for_learning = @learning.view_count
      @favorites_count_for_learning = Favorite.favorites_count_for_obj('Learning',@learning_id)
      @ratings_count_for_learning = Rating.ratings_count_for_obj(@learning_id,'Learning')
      @comments_count_for_learning = LearningComment.get_count_for_learning(@learning_id)
    else
      session[:title] = "Learning Central - General Report"
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
    params[:type] = params[:type]  || 'View'
    
    if params[:id]
      case params[:type]
      when "View"
        values = View.get_single_reporting_values(@start_date,'Learning',group,@learning_id)
      when "Favorite"
        values = Favorite.get_single_reporting_values(@start_date,'Learning',group,@learning_id)
      when "Comment"
        values = Comment.get_single_reporting_values(@start_date,'Learning',group,@learning_id)
      else
        values = Rating.get_single_reporting_values(@start_date,'Learning',group,@learning_id)
      end
    else
      case params[:type]
      when "View"
        values = View.get_reporting_values(@start_date,'Learning',group)
      when "Favorite"
        values = Favorite.get_reporting_values(@start_date,'Learning',group)
      when "Comment"
        values = Comment.get_reporting_values(@start_date,'Learning',group)
      when "Upload"
        values = Learning.get_reporting_values(@start_date,group)
      else
        values = Rating.get_reporting_values(@start_date,'Learning',group)
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
  
  
  
  def process_file_uploads(learning)
    unless params[:attachment].nil?
      params[:attachment].each do |attachment|
        learning.assets.build(:data => attachment)
      end
    end
  end
  
  def check_login
    unless logged_in?
      flash[:error] = "Please login first"
      redirect_to "/" and return
    end
  end
  
  def top_count
    @learning_count = Learning.count
    @views_count = Learning.views_count
    @favorites_count = Favorite.favorites_count('Learning')
    @ratings_count = Rating.ratings_count('Learning')
    @comments_count = LearningComment.get_count
  end
  
end
