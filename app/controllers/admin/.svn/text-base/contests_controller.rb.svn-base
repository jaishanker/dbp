class Admin::ContestsController < ApplicationController
  
  before_filter :admin_login_required
  before_filter :top_count,:only => [:index]
  layout 'admin_layout'
  require 'spreadsheet/excel'  
  
  def index
    @contest =  Contest.find_all
  end
  
  def new
    @contest = Contest.new
  end
  
  def create
    params[:contest][:tags] = getTags(params[:contest][:tags])
    @contest = Contest.new(params[:contest])
    @contest.total_participants = 0
    @contest.status = 1
    @contest.save
    if @contest.errors.empty?
      
      flash[:notice] = "Contest added successfully"
      redirect_to :action => :index
    else
      flash[:error] = "Errors occured while adding Contest"
      render :action => :new
    end
    
  end
  
  def edit
    @contest = Contest.find_by_permalink(params[:permalink])
  end
  
  def update
    params[:contest][:tags] = getTags(params[:contest][:tags])
    @contest = Contest.find_by_permalink(params[:permalink])
    @contest.update_attributes(params[:contest])
    @contest.save
    
    if @contest.errors.empty?
      flash[:notice] = "Contest successfully updated"
      redirect_to :action => :index
    else
      flash[:error] = "Errors occured while updating Contest"
      render :action => :edit
    end
  end
  
  
  def update_status
    
    @contest = Contest.find(params[:id])
    unless @contest.nil?
      @contest.status = params[:status]
      @contest.save
     if params[:status] == "1"      
        @contest.participants.update_all("status = 1","status = 2")        
     else
        @contest.participants.update_all("status = 2","status = 1")               
     end
      
      # Activity streams currently commented      
      
      #      if params[:status] == "0"
      #        params[:status] = "1"
      #      else
      #        params[:status] = "0"
      #      end
      #      @contest.activity_streams.collect{|a| a.status =  params[:status] 
      #        a.save}              
      
      message = "show_notice('Status updated successfully','success')"
    else
      message = "show_notice('Item not found','error')"
    end
    
    render :update do |page|
      page << message
    end
    
  end
  
  
  
  def participants
    @contest = Contest.find(params[:id])
    @contest_participants = @contest.participants
  end
  
  def update_participant_status    
    @participant = ContestParticipant.find(params[:id])
    unless @participant.nil?
      @participant.status = params[:status]
      @participant.save
      message = "show_notice('Status updated successfully','success')"
    else
      message = "show_notice('Item not found','error')"
    end
    
    render :update do |page|
      page << message
    end
    
  end  
  
  def download
    @contests = Contest.all
    filepath="Contests_Report_#{Time.now.utc.strftime('%Y-%d-%m')}.xls"
    workbook=Spreadsheet::Excel.new("#{RAILS_ROOT}/public/report/#{filepath}")
    worksheet=workbook.add_worksheet("Contests Details")
    
    worksheet.write(0, 0,"Total " + @contests.length.to_s + " contests")
    
    worksheet.write(2, 0, "Index")
    worksheet.write(2, 1, "Name")
    worksheet.write(2, 2, "Participants")
    worksheet.write(2, 3, "Start Date")
    worksheet.write(2, 4, "End Date")
    worksheet.write(2, 5, "Result Date")
    worksheet.write(2, 6, "Contest Status")
    worksheet.write(2, 7, "Status")
    
    row = 4
    @contests.each_with_index do |c,i|
      worksheet.write(row, 0, i + 1)
      worksheet.write(row, 1, c.name)
      worksheet.write(row, 2, c.participants.length)
      worksheet.write(row, 3, c.start_date.strftime("%d %b %Y"))
      worksheet.write(row, 4, c.end_date.strftime("%d %b %Y"))
      worksheet.write(row, 5, c.result_date.strftime("%d %b %Y"))
      worksheet.write(row, 6, c.contest_status)
      if c.status == 1
          worksheet.write(row, 7, 'Active')
      else
          worksheet.write(row, 7, 'Deactivated')        
      end
      row += 1
    end
    workbook.close
    
    send_file RAILS_ROOT + "/public/report/" + filepath
    
    
  end    
  
  def download_participants
    @contest = Contest.find(params[:id])
    @participants = @contest.participants
    filepath="Participants_Report_#{Time.now.utc.strftime('%Y-%d-%m')}.xls"
    workbook=Spreadsheet::Excel.new("#{RAILS_ROOT}/public/report/#{filepath}")
    worksheet=workbook.add_worksheet("#{@contest.name.to_s} participants")
    
    worksheet.write(0, 0,"Total " + @participants.length.to_s + " paticipants")
    
    worksheet.write(2, 0, "Index")
    worksheet.write(2, 1, "Participant")
    worksheet.write(2, 2, "Design")
    worksheet.write(2, 3, "Status")
    
    row = 4
    @participants.each_with_index do |c,i|
      worksheet.write(row, 0, i + 1)
      worksheet.write(row, 1, c.user.first_name.to_s+" "+c.user.last_name.to_s)
      worksheet.write(row, 2, c.design.name)      
      if c.status == 1
          worksheet.write(row, 3, 'Active')
      else
          worksheet.write(row, 3, 'Deactivated')        
      end
      row += 1
    end
    workbook.close
    
    send_file RAILS_ROOT + "/public/report/" + filepath
    
    
  end      
  
  def declare_winner
  @participant = ContestParticipant.find(params[:id])
  @contest = @participant.contest
  if params[:checked] == "true"
    if @contest.winner1.nil?
      @contest.winner1 = params[:id]
      @contest.save
      message = "show_notice('You have successfully declared winner','success')"          
    elsif @contest.winner2.nil?
      @contest.winner2 = params[:id]
      @contest.save
       message = "show_notice('You have successfully declared winner','success')"          
    else
       message = "show_notice('You have already declared 2 winners for this contest','error')"   
    end
  else
    if params[:id] == @contest.winner1.to_s
      @contest.winner1 = nil
      @contest.save
      message = "show_notice('You have successfully removed this winner','success')"         
    elsif params[:id] == @contest.winner2.to_s
      @contest.winner2 = nil
      @contest.save
      message = "show_notice('You have successfully removed this winner','success')"              
    end
  end

   render :update do |page|
      page << message
    end    
  end
 
  protected
  
  def top_count
    @active_contest_count = Contest.find_active.length
    @participant_count = ContestParticipant.all.length
  end
  
end
