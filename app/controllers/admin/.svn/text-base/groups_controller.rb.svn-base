class Admin::GroupsController < ApplicationController
  
  before_filter :admin_login_required
  before_filter :top_count,:only => [:index,:report]
  layout 'admin_layout'
  require 'spreadsheet/excel'
  
  def index
    @group = Group.find_all
    session[:groups] = @group
    
    abuse = Group.find_all_with_abuses
    
    @abuse = {}
    abuse.each do |a|
      @abuse[a.id] ||= []
      @abuse[a.id] <<  a.id
    end
    
    
  end
  
  def category
    @group_category = GroupCategory.new
    @categories = GroupCategory.find_all
  end
  
  
  def category_create
    @group_category = GroupCategory.new(params[:group_category])
    @group_category.status = 1
    @group_category.save
    
    render :update do |page|
      if @group_category.errors.empty?
        flash[:notice] = "Category created successfully"
        page.redirect_to "/admin/groups/category" 
        
      else
        page.visual_effect  :appear,"error"
        page.replace_html :error,
          :partial => '/layouts/errors'
        page << "show_notice('Errors occured while creating category','error')"
        page << "addError('group_category_name')"
        
        page.delay(10) do
          page.visual_effect  :fade,"error"
        end
        
      end
    end
  end
  
  
  def update_cat_status
    
    @group_category = GroupCategory.find(params[:id])
    unless @group_category.nil?
      @group_category.status = params[:status]
      @group_category.save
      if params[:status] == "1"
        @group_category.groups.update_all("status = 1","status = 3")
        @group_category.groups.collect{|g| subcat = SubCategory.find_by_name(g.name)
                                                                  subcat.update_attribute(:status , 1)
                                                                  subcat.all_topics.update_all("status = 1","status = 3")
                                                                  subcat.all_topics.each{ |t| t.all_posts.update_all("status = 1","status = 3") }}   
                                                        
      else
        @group_category.groups.update_all("status = 3","status = 1" )
        @group_category.groups.collect{|g| subcat = SubCategory.find_by_name(g.name)
                                                                  subcat.update_attribute(:status , 3)
                                                                  subcat.all_topics.update_all("status = 3","status = 1")
                                                                  subcat.all_topics.each{ |t| t.all_posts.update_all("status = 3","status = 1") }}          
      end
      if params[:status] == "0"
       params[:status] = "1"
      else
        params[:status] = "0"
      end      
     @group_category.groups.collect{|g| g.activity_streams.collect{|a| a.status =  params[:status] 
                                                         a.save}}
      message = "show_notice('Category status updated successfully','success')"
    else
      message = "show_notice('Category not found','error')"
    end
    
    render :update do |page|
      page << message
    end
    
  end
  
  
  def delete_category
    
    @group_category = GroupCategory.find(params[:id])
    @group_category.destroy unless @group_category.nil?
    flash[:notice] = "Category deleted successfully"
    redirect_to :back
    
  end
  
  
  
  def update_status
    @group = Group.find(params[:id])
    unless @group.nil?
      @group.update_attribute(:status,params[:status])
      subcat = SubCategory.find_by_name(@group.name)
      unless subcat.nil?
          subcat.update_attribute(:status , params[:status])
          if params[:status] == "1"
              subcat.all_topics.update_all("status = 1","status = 3")
              subcat.all_topics.each{ |t| t.all_posts.update_all("status = 1","status = 3") }     
              # Added on 14/05/10 by anil for sending mail
              UserMailer.deliver_group_activation(@group)              
          else
              subcat.all_topics.update_all("status = 3","status = 1")
              subcat.all_topics.each{ |t| t.all_posts.update_all("status = 3","status = 1") }           
              # Added on 14/05/10 by anil for sending mail
              UserMailer.deliver_group_deactivation(@group)                            
          end
      end
      if params[:status] == "0"
       params[:status] = "1"
      else
        params[:status] = "0"
      end
      @group.activity_streams.collect{|a| a.status =  params[:status] 
                                                         a.save}                               
      message = "show_notice('Status updated successfully','success')"
    else
      message = "show_notice('Item not found','error')"
    end
    
    render :update do |page|
      page << message
    end
    
  end
  
  
  def download
    
    @group = session[:groups] ||  Group.find_all
    
    filepath="Group_Report_#{Time.now.utc.strftime('%Y-%d-%m')}.xls"
    workbook=Spreadsheet::Excel.new("#{RAILS_ROOT}/public/report/#{filepath}")
    worksheet=workbook.add_worksheet("Group Details")
    
    worksheet.write(0, 0,"Total " + @group.length.to_s + " groups")
    
    worksheet.write(2, 0, "Index")
    worksheet.write(2, 1, "Name")
    worksheet.write(2, 2, "Owner")
    worksheet.write(2, 3, "Date")
    worksheet.write(2, 4, "Type")
    worksheet.write(2, 5, "Members")
    
    #    worksheet.write(2, 6, "Comments")
    #    worksheet.write(2, 7, "Favorites")
    #    worksheet.write(2, 8, "Shares")
    
    
    row = 4
    @group.each_with_index do |g,i|
      worksheet.write(row, 0, i + 1)
      worksheet.write(row, 1, g.name)
      worksheet.write(row, 2, g.owner.login + " (" + g.owner.groups.length.to_s + ")")
      worksheet.write(row, 3, g.created_at.strftime("%d %b %Y"))
      worksheet.write(row, 4, g.type.to_s)
      worksheet.write(row, 5, g.group_memberships.length.to_s)
      
      #      worksheet.write(row, 6, g.comments.length.to_s)
      #      worksheet.write(row, 7, g.favorites.length.to_s)
      #      worksheet.write(row, 8, g.shares.length.to_s)
      row += 1
    end
    workbook.close
    
    send_file RAILS_ROOT + "/public/report/" + filepath
    
    
  end
  

  def report

    if params[:id]
      @group = Group.find_by_id(params[:id])
      @group_name = @group.name
      @group_id = @group.id
      session[:title] = "Group - " + @group_name + " Report"
      @views_count_for_group = @group.view_count
    else
      session[:title] = "Group - General Report"
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
    
    if params[:id]
      case params[:type]
      when "View"
        values = View.get_single_reporting_values(@start_date,'Group',group,@group_id)
      when "Comment"
        values = Comment.get_single_reporting_values(@start_date,'Group',group,@group_id)
      when "Member"
        values = GroupMembership.get_single_reporting_values(@start_date,group,@group_id)
      else
        values = View.get_single_reporting_values(@start_date,'Group',group,@group_id)
      end
    else
      case params[:type]
      when "View"
        values = View.get_reporting_values(@start_date,'Group',group)
      when "Comment"
        values = Comment.get_reporting_values(@start_date,'Group',group)
      when "Member"
        values = GroupMembership.get_reporting_values(@start_date,group)
      else
        values = View.get_reporting_values(@start_date,'Group',group)
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
  
  def delete
    @group = Group.find(params[:id])    
    subcat = SubCategory.find_by_name(@group.name)
    unless subcat.nil?
        subcat.all_topics.each{ |t| t.all_posts.each{|p| p.destroy} }     
        subcat.all_topics.each{ |t| t.destroy}      
        subcat.destroy
    end
    @group.destroy
    respond_to do |format|
        format.html {
           flash[:notice] = "You have successfully deleted group."
           redirect_to :controller => "admin/groups"
        }    
     end
  end  
  
  def details
    @group = Group.find(params[:id])
    render :layout => false
  end
  private
  
  def check_login
    unless logged_in?
      flash[:error] = "Please login first"
      redirect_to "/" and return
    end
  end

  def top_count
    @group_count = Group.count
    @views_count = Group.views_count
  end
  
  
end
