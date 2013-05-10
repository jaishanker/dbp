class Admin::MembersController < ApplicationController
  
  before_filter :admin_login_required
  before_filter :top_count,:only => [:index,:report]
  layout 'admin_layout'
  require 'spreadsheet/excel'
  
  
  
  def index
    params[:alpha] ||= "All"
    
    redeem_points = User.all_redeem_points
    
    @redeem_points = {}
    
    redeem_points.each do |rp|
      @redeem_points[rp.user_id.to_i] = rp.sum
    end
    
    
    @user = User.find_all_users(params[:page],params[:alpha],100)
  end
  
  def report
    @user = User.find(params[:id])
  end
  
  
  def download
    
    filepath="Members_Report_#{Time.now.utc.strftime('%Y-%d-%m')}.xls"
    workbook=Spreadsheet::Excel.new("#{RAILS_ROOT}/public/report/#{filepath}")
    
    count = User.count
    pages = count / 500
    pages += 1 if count % 500 != 0
    
    
    i = 1
    
    
    page = 1 
    
    while page <= pages
      
      users = User.find_all_users(page,"All",500)
      
      worksheet=workbook.add_worksheet("Members Page #{i}")
      worksheet.write(0, 0,"Total " + count.to_s + " members")
      
      
      
      worksheet.write(2, 0, "Index")
      worksheet.write(2, 1, "Name")
      worksheet.write(2, 2, "Email")
      worksheet.write(2, 3, "Date")
      worksheet.write(2, 4, "Status")
      worksheet.write(2, 5, "Designs Uploaded")
      worksheet.write(2, 6, "Materials Requested")
      worksheet.write(2, 7, "Points")
      worksheet.write(2, 8, "Followings")
      worksheet.write(2, 9, "Followers")
      worksheet.write(2, 10, "Member of Groups")
      worksheet.write(2, 11, "Posts")
      
      
      
      row = 4
      users.each_with_index do |user,i|
        
        worksheet.write(row, 0,i + 1  )
        worksheet.write(row, 1, user.login)
        worksheet.write(row, 2, user.email)
        worksheet.write(row, 3, user.created_at.strftime("%d %b %Y"))
        worksheet.write(row, 4, get_user_status(user.status))
        worksheet.write(row, 5, user.designs.length)
        worksheet.write(row, 6, user.learning_requests.length)
        worksheet.write(row, 7, user.points.to_s)
        worksheet.write(row, 8, user.followings.length)
        worksheet.write(row, 9, user.followers.length)
        worksheet.write(row, 10, user.group_memberships.length)
        worksheet.write(row, 11, user.posts.length)
        
        
        row += 1
      end
      page += 1    
    end
    
    workbook.close
    
    send_file RAILS_ROOT + "/public/report/" + filepath
    
    
  end
  
  
  def member_report
    
    session[:type] = nil
    session[:type2] = nil
    calculation = true
    
    session[:title] = "Members - General Report"
    
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
    
    
    session[:type] = params[:type] || 'Registration'
    params[:type] ||= 'Registration'
    
    
    case params[:type]
      
      when "Registration"
      
      
      session[:type2] = 'Active Registrations'
      
      values = User.find_by_sql("select #{group}(created_at) as splitter, count(*) as count from users where \
     date(created_at) >= '#{start_date.to_s(:db)}' group by #{group}(created_at)")
      
      values2 = User.find_by_sql("select #{group}(created_at) as splitter, count(*) as count from users where \
     date(created_at) >= '#{start_date.to_s(:db)}' and activation_code is null group by #{group}(created_at)")
      
      when "Activation"
      
      
      values = User.find_by_sql("select #{group}(activated_at) as splitter, count(*) as count from users where \
     date(activated_at) >= '#{start_date.to_s(:db)}' and activation_code is null group by #{group}(activated_at)")
      
      
      when "Login"
      
      values = User.find_by_sql("select #{group}(created_at) as splitter, count(*) as count from user_login_details where \
     date(created_at) >= '#{start_date.to_s(:db)}' group by #{group}(created_at)")
      
      
      
      when "Gender Grouping"
      
      @values = User.find_by_sql("select gender as splitter, count(*) as count from users group by gender")
      
      session[:output] = @values
      
      calculation = false 
      
      when "Profile Picture Present"
      
      @values = User.find_by_sql("select 'Picture Present' as splitter, count(*) as count from users, pictures where users.id = pictures.gallerie_id and pictures.gallerie_type = 'User'")
      @values << Picture.find_by_sql("select 'Picture Not Present' as splitter, ( (select count(*) from users)  - count(*) ) as count from users, pictures where users.id = pictures.gallerie_id and pictures.gallerie_type = 'User'")[0]
      session[:output] = @values
      
      calculation = false 
      
      when "Favorite"
      values = Favorite.get_reporting_values(@start_date,'Design',group)
      when "Comment"
      values = Comment.get_reporting_values(@start_date,'Design',group)
      when "Upload"
      values = Design.get_reporting_values(@start_date,group)
    else
      values = Rating.get_reporting_values(@start_date,'Design',group)
    end
    
    if calculation
      
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
      
      
      # second values
      if session[:type2] 
        @values2 = {}
        unless values2.nil?
          values2.each do |val|
            if query_format == "%m"
              @values2[val.splitter.length == 2 ? val.splitter.to_s : '0' + val.splitter.to_s] = val.count
            else
              @values2[val.splitter] = val.count
            end
            
          end
        end
      end
      #       logger.info "-----------1-----------"
      #    logger.info @values.inspect
      
      
      logger.info "------------2----------"
      logger.info @values2.inspect
      
      
      @output = {}
      @output2 = {} if session[:type2] 
      
      
      i = 0
      while start_date <= Date.today
        #  logger.info "==========" + start_date.strftime(query_format)
        if query_format == "%W"
          @output[start_date.strftime(format) + "-" + start_date.advance(:days => 6).strftime(format) ] = [ i, @values[start_date.strftime(query_format)].nil? ? 0 : @values[start_date.strftime(query_format)]]
          @output2[start_date.strftime(format) + "-" + start_date.advance(:days => 6).strftime(format) ] = [ i, @values2[start_date.strftime(query_format)].nil? ? 0 : @values2[start_date.strftime(query_format)]] if session[:type2] 
        else  
          @output[start_date.strftime(format)] = [ i, @values[start_date.strftime(query_format)].nil? ? 0 : @values[start_date.strftime(query_format)]]  
          @output2[start_date.strftime(format)] = [ i, @values2[start_date.strftime(query_format)].nil? ? 0 : @values2[start_date.strftime(query_format)]] if session[:type2] 
        end
        
        start_date = eval("start_date." + split)
        i = i + 1
      end
      
      #    logger.info @output.sort{|a,b| a[1][0]<=>b[1][0]}.inspect
      #    
      session[:output] = @output.sort{|a,b| a[1][0]<=>b[1][0]}
      #    
      #    
      #    logger.info @output2.sort{|a,b| a[1][0]<=>b[1][0]}.inspect
      #    
      session[:output2] = @output2.sort{|a,b| a[1][0]<=>b[1][0]} if session[:type2] 
      
    end
    
  end
  
  
  def get_xml
    respond_to do |format|
      format.xml
    end
  end
  
  def get_user_xml
    
    @user = User.find(params[:id])
    
    
    respond_to do |format|
      format.xml
    end
  end
  
  
  
  
  
  private
  
  def top_count
    
  end
  
  def get_user_status(status)
    case status.to_i
      when 0,1,2
        "Active"
      when 10
      "Deactive"
    end
    
  end
  
end
