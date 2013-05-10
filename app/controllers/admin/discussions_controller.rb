class Admin::DiscussionsController < ApplicationController
  
  before_filter :admin_login_required,:except => :update_sub_category
  before_filter :top_count,:only => [:index,:category,:sub_category,:abuse_report,:report,:edit_sub_category1]
  layout 'admin_layout'
  require 'spreadsheet/excel'
  
  def index
    @topic = Topic.find_all
    abuse = Post.find_all_with_abuses
    
    @abuse = {}
    abuse.each do |a|
      @abuse[a.topic_id] ||= []
      @abuse[a.topic_id] <<  a.id
    end
    
  end
  
  def update_status
    
    @topic = Topic.find(params[:id])
    unless @topic.nil?
      @topic.status = params[:status]
      @topic.save
      if params[:status] == "1"
        @topic.all_posts.update_all("status = 1","status = 3")
      else
        @topic.all_posts.update_all("status = 3","status = 1")
      end      
      @topic.requests.collect{|r| r.active =  params[:status] 
                                                         r.save}                
     if params[:status] == "0"
       params[:status] = "1"
      else
        params[:status] = "0"
      end
      @topic.activity_streams.collect{|a| a.status =  params[:status] 
                                                         a.save}          
                                                           
      message = "show_notice('Status updated successfully','success')"
    else
      message = "show_notice('Item not found','error')"
    end
    
    render :update do |page|
      page << message
    end
    
  end
  
  def update_status_of_post
    
    @post = Post.find(params[:id])
    unless @post.nil?
      @post.status = params[:status]
      @post.save
      message = "show_notice('Status updated successfully','success')"
    else
      message = "show_notice('Item not found','error')"
    end
    
    render :update do |page|
      page << message
    end
    
  end
  
  #----------------------------   category  -----------------------------------#
  
  def category
    @discussion_category = DiscussionCategory.new
    @categories = DiscussionCategory.find_all
  end
  
  
  def category_create
    @discussion_category = DiscussionCategory.new(params[:discussion_category])
    @discussion_category.status = 1
    @discussion_category.save
    
    render :update do |page|
      if @discussion_category.errors.empty?
        flash[:notice] = "Category created successfully"
        page.redirect_to "/admin/discussions/category" 
        
      else
        page.visual_effect  :appear,"error"
        page.replace_html :error,
        :partial => '/layouts/errors'
        page << "show_notice('Errors occured while creating category','error')"
        page << "addError('discussion_category_name')"
        
        page.delay(10) do
          page.visual_effect  :fade,"error"
        end
        
      end
    end
  end
  
  
  def update_cat_status
    
    @discussion_category = DiscussionCategory.find(params[:id])
    unless @discussion_category.nil?
      @discussion_category.status = params[:status]
      @discussion_category.save
      if params[:status] == "1"
        @discussion_category.all_subcategories.update_all("status = 1","status = 3")
        @discussion_category.all_subcategories.each{ |s| ( s.all_topics.update_all("status = 1","status = 3")   
            s.all_topics.each{ |t| t.all_posts.update_all("status = 1","status = 3") })
            group = Group.find_by_name(s.name)
            unless group.nil?
               group.update_attribute(:status, 1)
               group.activity_streams.collect{|a| a.status =  0
                                                                       a.save}               
            end
            }
        @discussion_category.all_subcategories.each{ |s| ( s.all_topics.update_all("status = 1","status = 3")   
            s.all_topics.each{ |t| t.requests.update_all("active = 1","active = 3") })}        
      else
        @discussion_category.all_subcategories.update_all("status = 3","status = 1" )
        @discussion_category.all_subcategories.each{ |s| ( s.all_topics.update_all("status = 3","status = 1")   
            s.all_topics.each{ |t| t.all_posts.update_all("status = 3","status = 1") })
            group = Group.find_by_name(s.name)
            unless group.nil?
              group.update_attribute(:status, 0)      
              group.activity_streams.collect{|a| a.status =  1
                                                                       a.save}                    
            end
            }   
        @discussion_category.all_subcategories.each{ |s| ( s.all_topics.update_all("status = 1","status = 3")   
            s.all_topics.each{ |t| t.requests.update_all("active = 3","active = 1") })}                
      end      
      message = "show_notice('Category status updated successfully','success')"
    else
      message = "show_notice('Category not found','error')"
    end
    
    render :update do |page|
      page << message
    end
    
  end
  
  
  def delete_category
    
    @discussion_category = DiscussionCategory.find(params[:id])
    @discussion_category.destroy unless @discussion_category.nil?
    flash[:notice] = "Category deleted successfully"
    redirect_to :back
    
  end
  
  
  #---------------------------------   category end  --------------------------------------#
  
  #---------------------------------  sub category start  --------------------------------------#
  
  def sub_category
    @sub_category = SubCategory.new
    @sub_categories = SubCategory.find_all
  end
  
  
  def sub_category_create
    @sub_category = SubCategory.new(params[:sub_category])
    @sub_category.status = 1
    @sub_category.user_id = current_user.id
    @sub_category.save
    
    render :update do |page|
      if @sub_category.errors.empty?
        flash[:notice] = "Sub Category created successfully"
        page.redirect_to "/admin/discussions/sub_category" 
        
      else
        page.visual_effect  :appear,"error"
        page.replace_html :error,
          :partial => '/layouts/errors'
        page << "show_notice('Errors occured while creating sub category','error')"
        
        @sub_category.attribute_names.each do |n|
          page <<  "addError('sub_category_" + n + "')" if @sub_category.errors.on(n)
        end 
        page.delay(10) do
          page.visual_effect  :fade,"error"
        end
        
      end
    end
  end
  
  def edit_sub_category
    @sub_categories = SubCategory.find_all
    @sub_category = SubCategory.find(params[:id])
  end

  def update_sub_category1
    @sub_categories = SubCategory.find_all
    @sub_category = SubCategory.find_by_id(params[:id])
    @sub_category.update_attributes(params[:sub_category])
    @sub_category.save

      if @sub_category.errors.empty?
        flash[:notice] = "Sub Category successfully updated"
        redirect_to :controller=>"/admin/discussions" , :action => :sub_category
      else
        flash[:error] = "Errors occured while updating Sub Category"
        render :action => :edit_sub_category
      end
  end

  def update_sub_cat_status
    
    @sub_category = SubCategory.find(params[:id])
    unless @sub_category.nil?
      @sub_category.status = params[:status]
      @sub_category.save
       if params[:status] == "1"
          @sub_category.all_topics.update_all("status = 1","status = 3")
          @sub_category.all_topics.each{ |t| t.all_posts.update_all("status = 1","status = 3") }
          @sub_category.all_topics.each{ |t| t.requests.update_all("status = 1","status = 3") }          
          group = Group.find_by_name(@sub_category.name)
          unless group.nil?
                group.update_attribute(:status, 1)
                group.activity_streams.collect{|a| a.status =  0
                                                                       a.save}               
          end          
        else
          @sub_category.all_topics.update_all("status = 3","status = 1" )
          @sub_category.all_topics.each{ |t| t.all_posts.update_all("status = 3","status = 1") }
          @sub_category.all_topics.each{ |t| t.requests.update_all("status = 3","status = 1") }                 
          group = Group.find_by_name(@sub_category.name)
          unless group.nil?
                group.update_attribute(:status, 0)
                group.activity_streams.collect{|a| a.status =  1
                                                                       a.save}               
          end                
        end      

      message = "show_notice('Sub Category status updated successfully','success')"
    else
      message = "show_notice('Sub Category not found','error')"
    end
    
    render :update do |page|
      page << message
    end
    
  end
  
  
  def delete_sub_category
    
    @sub_category = SubCategory.find(params[:id])
    @sub_category.destroy unless @sub_category.nil?
    flash[:notice] = "Sub Category deleted successfully"
    redirect_to :back
    
  end
  
  def update_sub_category
    render :update do |page|
      
      @cat = DiscussionCategory.find(params[:topic][:discussion_category_id])
      
      @sub_categories = []
      @sub_categories = @cat.sub_categories unless @cat.nil?
      
      page.replace_html :sub_category_dropdown,
        select(:topic,:sub_category_id,@sub_categories.map{|s| [s.name,s.id]})
      page << "$('select').addClass('inputtxt01')"
      
    end
  end
  
  
  #-----------------------------  sub category end  -------------------------------------#
  
  #-----------------------------  Topic  -------------------------------------#
  
  def topic
    @topic = Topic.new
    @a = @topic.posts.build
    @discussion_categories = DiscussionCategory.all_active
  end
  
  
  def create
    
    @topic = Topic.new(params[:topic])
    @topic.user_id = current_user.id
    @topic.status = 1
    @topic.save
    
    if @topic.errors.empty?
      flash[:notice] = "Topic added successfully"
      redirect_to :action => :index
    else
      flash[:error] = "Errors occured while adding Topic"
      @discussion_categories = DiscussionCategory.all_active
      render :action => :topic
    end
    
  end
  
  #-----------------------------  Topic end  -------------------------------------#
  
  
  def abuse_report
    @post = Post.find_all_with_abuses
  end
  
  
  
  def download
    
    @topic = Topic.find_all
    
    filepath="Discussion_Lounge_Report_#{Time.now.utc.strftime('%Y-%d-%m')}.xls"
    workbook=Spreadsheet::Excel.new("#{RAILS_ROOT}/public/report/#{filepath}")
    worksheet=workbook.add_worksheet("Discussion Lounge")
    
    worksheet.write(0, 0,"Total " + @topic.length.to_s + " designs")
    
    worksheet.write(2, 0, "Index")
    worksheet.write(2, 1, "Name")
    worksheet.write(2, 2, "Date")
    worksheet.write(2, 3, "Posts")
    worksheet.write(2, 4, "Members")
    worksheet.write(2, 5, "Views")
    
    row = 4
    @topic.each_with_index do |t,i|
      worksheet.write(row, 0, i + 1)
      worksheet.write(row, 1, t.title)
      worksheet.write(row, 2, t.created_at.strftime("%d %b %Y"))
      worksheet.write(row, 3, t.posts.length)
      worksheet.write(row, 4, get_post_user_count(t.posts))
      worksheet.write(row, 5, t.view_count.nil? ? 0 : t.view_count )
      
      row += 1
    end
    workbook.close
    
    send_file RAILS_ROOT + "/public/report/" + filepath
    
    
  end
  
  
  
  def report
    if params[:id]
      @topic = Topic.find_by_id(params[:id])
      @topic_name = @topic.title
      @topic_id = @topic.id
      session[:title] = "Discussion - " + @topic_name + " Report"
      @posts_count = get_post_user_count(@topic.posts)
    else
      session[:title] = "Discussion - General Report"
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


    session[:type] = params[:type] || 'View on topic'
      params[:type] = params[:type]  || 'View on topic'

    if params[:id]
      case params[:type]
      when "View on topic"
        values = View.get_single_reporting_values(@start_date,'Topic',group,@topic_id)
      when "Post"
        values = Post.get_single_reporting_values(@start_date,group,@topic_id)
      else
        values = View.get_single_reporting_values(@start_date,'Topic',group,@topic_id)
      end
    else
      case params[:type]
      when "View on topic"
        values = View.get_reporting_values(@start_date,'Topic',group)
      when "Topic"
        values = Topic.get_reporting_values(@start_date,group)
      when "Post"
        values = Post.get_reporting_values(@start_date,group)
      else
        values = View.get_reporting_values(@start_date,'Topic',group)
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
    @category_count = DiscussionCategory.count#_active('DiscussionCategory')
    @sub_category_count = SubCategory.count#_active()
    @topics_count = Topic.count#_active()
    @posts_count = Post.count#_active()
  end
  
  def get_post_user_count(posts)
    u = []
    
    posts.each do |p|
      u << p.user_id
    end
    return u.uniq.length
    
  end
  
  
end
