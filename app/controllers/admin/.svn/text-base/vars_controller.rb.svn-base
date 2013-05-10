class Admin::VarsController < ApplicationController
  
  before_filter :admin_login_required
  before_filter :top_count,:only => [:index,:category,:abuse_report,:report]
  before_filter :clear_cache, :only => [:download,:download_all]
  layout 'admin_layout'
  require "spreadsheet/excel"
  
  def index
    @event = Event.find_all("user_id = #{current_user.id}")
    session[:event] = @event
  end
  
  def new
    @event = Event.new
  end
  
  def create
    @event = Event.new(params[:event])
    @event.status = 1
    @event.user_id = current_user.id
    @event.save
    if @event.errors.empty?
      flash[:notice] = "Event added successfully"
      redirect_to :action => :index
    else
      flash[:error] = "Errors occured while adding Event"
      render :action => :new
    end
    
  end
  
  def edit
    @event = Event.find(params[:id])
  end
  
  def update
    @event = Event.find(params[:id])
    @event.update_attributes(params[:event])
    @event.user_id = current_user.id
    @event.save
    if @event.errors.empty?
      
      
      flash[:notice] = "Event updated successfully"
      redirect_to :action => :index
    else
      flash[:error] = "Errors occured while updating Event"
      render :action => :edit
    end
    
  end
  
  
  def download
    @event = Event.find(params[:id],:conditions => "user_id = #{current_user.id}" ,:include => {:participants => :user})
    
    
    
    
    filepath="Event_#{@event.topic}_#{Time.now.utc.strftime('%Y-%d-%m')}.xls"
    workbook=Spreadsheet::Excel.new("#{RAILS_ROOT}/public/#{filepath}")
    worksheet=workbook.add_worksheet("Event Participants")
    
    worksheet.write(0, 0,@event.topic)
    worksheet.write(0, 2,@event.participants.length.to_s + " participants")
    
    worksheet.write(2, 0,"Index")
    worksheet.write(2, 1,"Name") 
    worksheet.write(2, 2, "Email Id")
    worksheet.write(2, 3, "Mobile No")
    worksheet.write(2, 4, "Organization") 
    worksheet.write(2, 5, "Designation")  
    worksheet.write(2, 6, "Role")  
    worksheet.write(2, 7, "Fax No")  
    
    
    row = 4
    @event.participants.each_with_index do |p,i|
      worksheet.write(row, 0, i + 1)
      worksheet.write(row, 1, p.salutation.to_s+" "+p.name.to_s)
      worksheet.write(row, 2, p.user.email)
      worksheet.write(row, 3, p.mobile_no)
      worksheet.write(row, 4, p.organization)
      worksheet.write(row, 5, p.position)
      worksheet.write(row, 6, p.role)
      worksheet.write(row, 7, p.fax_no)      
      row += 1
    end
    workbook.close
    
    send_file RAILS_ROOT + "/public/" + filepath
    
    
  end
  
  def download_all    
    @event = Event.find_all("user_id = #{current_user.id}")  
#    @event = session[:event] ||  Event.find_all
    
    filepath="Event_Report_#{Time.now.utc.strftime('%Y-%d-%m')}.xls"
    workbook=Spreadsheet::Excel.new("#{RAILS_ROOT}/public/report/#{filepath}")
    worksheet=workbook.add_worksheet("Event Details")
    
    worksheet.write(0, 0,"Total " + @event.length.to_s + " events")
    
    worksheet.write(2, 0, "Index")
    worksheet.write(2, 1, "Name")
    worksheet.write(2, 2, "Type")
    worksheet.write(2, 3, "Product")
    worksheet.write(2, 4, "Organizer")
    worksheet.write(2, 5, "City(State)")
    worksheet.write(2, 6, "Date")
    worksheet.write(2, 7, "Time")
    worksheet.write(2, 8, "Participants")
    
    
    row = 4
    @event.each_with_index do |e,i|
      worksheet.write(row, 0, i + 1)
      worksheet.write(row, 1, e.topic)
      worksheet.write(row, 2, e.eventtype)
      worksheet.write(row, 3, e.product)
      worksheet.write(row, 4, e.organizer)
      worksheet.write(row, 5, e.city + " ("  + e.state + ")")
      worksheet.write(row, 6, e.date.strftime("%d %b %Y"))
      worksheet.write(row, 7, e.start_time.strftime("%I:%M %p")  + " - " + e.end_time.strftime("%I:%M %p"))
      worksheet.write(row, 8, e.participants.length.to_s )
      row += 1
    end
    workbook.close
    
    send_file RAILS_ROOT + "/public/report/" + filepath
    
    
  end
  
  
  def auto_complete
    
    result = Event.find_auto_complete_results(params[:type],params[:q])
    
    op = ""
    
    result.each do |r|
      op << r.result << "|"
    end
    
    render :text => op.chop
    
  end
  
  def update_status
    
    @event = Event.find(params[:id])
    unless @event.nil?
      @event.status = params[:status]
      @event.save
      if params[:status] == "0"
        params[:status] = "1"
      else
        params[:status] = "0"
      end
      @event.activity_streams.collect{|a| a.status =  params[:status] 
        a.save}        
      message = "show_notice('Status updated successfully','success')"
    else
      message = "show_notice('Item not found','error')"
    end
    
    render :update do |page|
      page << message
    end
    
  end
  
  
  def report
    
    if params[:id]
      @event = Event.find_by_id(params[:id])
      @event_name = @event.topic
      @event_id = @event.id
      session[:title] = "Event - " + @event_name + "Report"
      @views_count_for_event = @event.view_count
      @participant_count_for_event = @event.participants.length
    else
      session[:title] = "Event - General Report"
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
        values = View.get_single_reporting_values(@start_date,'Event',group,@event_id)
        when "Participant"
        values = EventParticipant.get_reporting_values_for_event(@start_date,group,@event_id)
      else
        values = View.get_single_reporting_values(@start_date,'Event',group,@event_id)
      end
    else
      case params[:type]
        when "View"
        values = View.get_reporting_values(@start_date,'Event',group)
        when "Participant"
        values = EventParticipant.get_reporting_values(@start_date,group)
      else
        values = View.get_reporting_values(@start_date,'Event',group)
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
    @event_count = Event.count
    @views_count = Event.views_count
    @participant_count = EventParticipant.count
    
  end
  
  def clear_cache
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "#{1.year.ago}"
  end
  
  
end
