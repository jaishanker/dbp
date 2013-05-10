class Admin::DesignsController < ApplicationController
  
  before_filter :admin_login_required
  before_filter :top_count,:only => [:index,:category,:abuse_report,:report]
  layout 'admin_layout'
  require 'spreadsheet/excel'
  
  def index
    @design = Design.find_all
    session[:design] = @design
  end
  
  def category
    
    @design_category = DesignCategory.new
    @categories = DesignCategory.find_all
  end
  
  
  def category_create
    @design_category = DesignCategory.new(params[:design_category])
    @design_category.status = 1
    @design_category.save
    
    render :update do |page|
      if @design_category.errors.empty?
        flash[:notice] = "Category created successfully"
        page.redirect_to "/admin/designs/category" 
        
      else
        page.visual_effect  :appear,"error"
        page.replace_html :error,
        :partial => '/layouts/errors'
        page << "show_notice('Errors occured while creating category','error')"
        page << "addError('design_category_name')"
        
        page.delay(10) do
          page.visual_effect  :fade,"error"
        end
        
      end
    end
  end
  
  
  def update_cat_status
    
    @design_category = DesignCategory.find(params[:id])
    unless @design_category.nil?
      @design_category.status = params[:status]
      @design_category.save
      
      # updating the design status according to category status
      # when category is deleted the status is updated to 3
      if params[:status] == "1"
        @design_category.designs.update_all("status = 1","status = 3")
        @design_category.designs.collect{|d| d.comments.update_all("status = 1","status = 3") }   
        @design_category.designs.collect{|d| d.requests.update_all("active = 1","active = 3") }               
        @design_category.designs.collect{|d| d.favorites.update_all("status = 1","status = 3") }      
        @design_category.designs.collect{|d| d.design_tags.update_all("status = 1","status = 3") }        
        @design_category.designs.collect{|d| d.contest_participants.update_all("status = 1","status = 3") }                       
      else
        @design_category.designs.update_all("status = 3","status = 1" )
        @design_category.designs.collect{|d| d.comments.update_all("status = 3","status = 1") }   
        @design_category.designs.collect{|d| d.requests.update_all("active = 3","active = 1") }    
        @design_category.designs.collect{|d| d.favorites.update_all("status = 3","status = 1") }         
        @design_category.designs.collect{|d| d.design_tags.update_all("status = 3","status = 1") }       
        @design_category.designs.collect{|d| d.contest_participants.update_all("status = 3","status = 1") }                               
      end
      if params[:status] == "0"
       params[:status] = "1"
      else
        params[:status] = "0"
      end      
     @design_category.designs.collect{|d| d.activity_streams.collect{|a| a.status =  params[:status] 
                                                         a.save}}
     @design_category.designs.collect{|d| d.comments.collect{|c| c.activity_streams.collect{|a| a.update_attribute(:status,params[:status])}}}     
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
    
    @design_category = DesignCategory.find(params[:id])
    @design_category.destroy unless @design_category.nil?
    flash[:notice] = "Category deleted successfully"
    redirect_to :back
    
  end
  
  
  
  def update_status
    
    @design = Design.find(params[:id])
    unless @design.nil?
      @design.status = params[:status]
      @design.save
      @design.comments.collect{|c| c.status =  params[:status] 
                                                         c.save}    
      @design.requests.collect{|r| r.active =  params[:status] 
                                                         r.save}      
      @design.favorites.collect{|f| f.status =  params[:status] 
                                                         f.save}          
      @design.design_tags.collect{|t| t.status =  params[:status] 
                                                         t.save}      
      if params[:status] == "0"
       @design.participants.update_all("status = 4","status = 1")               
       params[:status] = "1"
      else
        @design.participants.update_all("status = 1","status = 4")                 
        params[:status] = "0"
      end
      @design.activity_streams.collect{|a| a.status =  params[:status] 
                                                         a.save}
     @design.comments.collect{|c| c.activity_streams.collect{|a| a.update_attribute(:status,params[:status])}}
      message = "show_notice('Status updated successfully','success')"
    else
      message = "show_notice('Item not found','error')"
    end
    
    render :update do |page|
      page << message
    end
    
  end
  
  def abuse_report
    @design = Design.find_all_with_abuses
  end
  
  
  def download
    @design = session[:design] ||  Design.find_all
    filepath="Design_Report_#{Time.now.utc.strftime('%Y-%d-%m')}.xls"
    workbook=Spreadsheet::Excel.new("#{RAILS_ROOT}/public/report/#{filepath}")
    worksheet=workbook.add_worksheet("Design Details")
    
    worksheet.write(0, 0,"Total " + @design.length.to_s + " designs")
    
    worksheet.write(2, 0, "Index")
    worksheet.write(2, 1, "Name")
    worksheet.write(2, 2, "Posted By")
    worksheet.write(2, 3, "Date")
    worksheet.write(2, 4, "Rating")
    worksheet.write(2, 5, "Views")
    worksheet.write(2, 6, "Comments")
    worksheet.write(2, 7, "Favorites")
    worksheet.write(2, 8, "Shares")
    
    
    row = 4
    @design.each_with_index do |d,i|
      worksheet.write(row, 0, i + 1)
      worksheet.write(row, 1, d.name)
      worksheet.write(row, 2, d.user.login + " (" + d.user.designs.length.to_s + ")")
      worksheet.write(row, 3, d.created_at.strftime("%d %b %Y"))
      worksheet.write(row, 4, d.ratings_count.length)
      worksheet.write(row, 5, !d.view_count.nil? ? d.view_count.to_s : "0")
      worksheet.write(row, 6, d.comments.length.to_s)
      worksheet.write(row, 7, d.favorites.length.to_s)
      worksheet.write(row, 8, d.shares.length.to_s)
      row += 1
    end
    workbook.close
    
    send_file RAILS_ROOT + "/public/report/" + filepath
    
    
  end
  
  
  def report


    if params[:id]
      @design = Design.find_by_id(params[:id])
      @design_name = @design.name
      @design_id = @design.id
      session[:title] = "Design Central - " + @design_name + " Report"
      @views_count_for_design = @design.view_count
      @favorites_count_for_design = Favorite.favorites_count_for_obj('Design',@design_id)
      @ratings_count_for_design = Rating.ratings_count_for_obj(@design_id,'Design')
      @comments_count_for_design = DesignComment.get_count_for_design(@design_id)
    else
       session[:title] = "Design Central - General Report"
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
    params[:type] ||= 'View'
    
    if params[:id]
      case params[:type]
      when "View"
      values = View.get_single_reporting_values(@start_date,'Design',group,@design_id)
      when "Favorite"
      values = Favorite.get_single_reporting_values(@start_date,'Design',group,@design_id)
      when "Comment"
      values = Comment.get_single_reporting_values(@start_date,'Design',group,@design_id)
    else
      values = Rating.get_single_reporting_values(@start_date,'Design',group,@design_id)
    end
    else
      case params[:type]
      when "View"
      values = View.get_reporting_values(@start_date,'Design',group)
      when "Favorite"
      values = Favorite.get_reporting_values(@start_date,'Design',group)
      when "Comment"
      values = Comment.get_reporting_values(@start_date,'Design',group)
      when "Upload"
      values = Design.get_reporting_values(@start_date,group)
    else
      values = Rating.get_reporting_values(@start_date,'Design',group)
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
    @design_count = Design.count
    @views_count = Design.views_count
    @favorites_count = Favorite.favorites_count('Design')
    @ratings_count = Rating.ratings_count('Design')
    @comments_count = DesignComment.get_count
  end
  
  
end
