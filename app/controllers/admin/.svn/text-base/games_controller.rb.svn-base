class Admin::GamesController < ApplicationController
  
  
  before_filter :admin_login_required
  before_filter :top_count,:only => [:index,:category,:report]
  layout 'admin_layout'
  
  def index
    @game = Game.find_all
    session[:game] = @game
  end
  
  
  def new
    @game = Game.new
  end
  
  
  def create
    params[:game][:tags] = getTags(params[:game][:tags])
    @game = Game.new(params[:game])
    @game.user_id = current_user.id
    @game.status = 1
    @game.save
    if @game.errors.empty?
#       @game.add_rating Rating.new(:user_id => current_user.id)             
      if params[:photo] 
        if @game.pictures[0].blank?  
          picture = Picture.new 
        else
          picture = @game.pictures[0]
        end
        if request.headers['HTTP_USER_AGENT'].to_s.include?('IE')
          picture.version = "IE"
        else
          picture.version = "Other"
        end
        picture.photo  = params[:photo]
        @game.pictures <<  picture
        
      end 
      flash[:notice] = "Game added successfully"
      redirect_to :action => :index
    else
      flash[:error] = "Errors occured while adding Game"
      render :action => :new
    end
    
  end

  def edit
    @game = Game.find_by_permalink(params[:permalink])
  end

  def update
    params[:game][:tags] = getTags(params[:game][:tags])
    @game = Game.find_by_permalink(params[:permalink])
    @game.update_attributes(params[:game])
    @game.pictures.build(:photo => params[:photo]) if params[:photo] 
    @game.save
    
    if @game.errors.empty?
      flash[:notice] = "Game successfully updated"
      redirect_to :action => :index
    else
      flash[:error] = "Errors occured while updating Game"
      render :action => :edit
    end
  end
   

  def update_status
    
    @game = Game.find(params[:id])
    unless @game.nil?
      @game.status = params[:status]
      @game.save
      @game.comments.collect{|c| c.status =  params[:status] 
        c.save}    
      @game.requests.collect{|r| r.active =  params[:status] 
        r.save}     
      @game.favorites.collect{|f| f.status =  params[:status] 
        f.save}    
      @game.game_tags.collect{|t| t.status =  params[:status] 
        t.save}                                          
      if params[:status] == "0"
        params[:status] = "1"
      else
        params[:status] = "0"
      end
      @game.activity_streams.collect{|a| a.status =  params[:status] 
        a.save}              
      @game.comments.collect{|c| c.activity_streams.collect{|a| a.update_attribute(:status,params[:status])}}                                                       
      message = "show_notice('Status updated successfully','success')"
    else
      message = "show_notice('Item not found','error')"
    end
    
    render :update do |page|
      page << message
    end
    
  end
  
  def download
    
    @game = session[:game] ||  Game.find_all
    
    
    filepath="Game_Report_#{Time.now.utc.strftime('%Y-%d-%m')}.xls"
    workbook=Spreadsheet::Excel.new("#{RAILS_ROOT}/public/report/#{filepath}")
    worksheet=workbook.add_worksheet("Game Details")
    
    worksheet.write(0, 0,"Total " + @game.length.to_s + " games")
    
    worksheet.write(2, 0, "Index")
    worksheet.write(2, 1, "Name")
    worksheet.write(2, 2, "Views")
    worksheet.write(2, 3, "Comments")
    worksheet.write(2, 4, "Favorites")
    #    worksheet.write(2, 4, "Rating")
    #    worksheet.write(2, 5, "Views")
    #    worksheet.write(2, 6, "Comments")
    #    worksheet.write(2, 7, "Favorites")
    #    worksheet.write(2, 8, "Shares")
    
    
    row = 4
    @game.each_with_index do |g,i|
      worksheet.write(row, 0, i + 1)
      worksheet.write(row, 1, g.title)
      #      worksheet.write(row, 2, d.user.login + " (" + d.user.designs.length.to_s + ")")
      #      worksheet.write(row, 3, d.created_at.strftime("%d %b %Y"))
      #      worksheet.write(row, 4, d.ratings_count.length)
      worksheet.write(row, 2, !g.view_count.nil? ? g.view_count.to_s : "0")
      worksheet.write(row, 3, g.comments.length.to_s)
      worksheet.write(row, 4, g.favorites.length.to_s)
      #      worksheet.write(row, 7, d.favorites.length.to_s)
      #      worksheet.write(row, 8, d.shares.length.to_s)
      row += 1
    end
    workbook.close
    
    send_file RAILS_ROOT + "/public/report/" + filepath
    
    
  end
  
  
  def report
    
    if params[:id]
      @game = Game.find_by_id(params[:id])
      @game_name = @game.title
      @game_id = @game.id
      session[:title] = "Games - " + @game_name + " Report"
      @views_count = @game.view_count
      @favorites_count_for_game = Favorite.favorites_count_for_obj('Game',@game_id)
      @ratings_count = Rating.ratings_count_for_obj(@game_id,'Game')
      @comments_count = GameComment.get_count_for_game(@game_id)
    else
      session[:title] = "Games - General Report"
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
        values = View.get_single_reporting_values(@start_date,'Game',group,@game_id)
      when "Favorite"
        values = Favorite.get_single_reporting_values(@start_date,'Game',group,@game_id)
      when "Comment"
        values = Comment.get_single_reporting_values(@start_date,'Game',group,@game_id)
      else
        values = Rating.get_single_reporting_values(@start_date,'Game',group,@game_id)
      end
    else
      case params[:type]
      when "View"
        values = View.get_reporting_values(@start_date,'Game',group)
      when "Favorite"
        values = Favorite.get_reporting_values(@start_date,'Game',group)
      when "Comment"
        values = Comment.get_reporting_values(@start_date,'Game',group)
      else
        values = Rating.get_reporting_values(@start_date,'Game',group)
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
    @game_count = Game.count
    @views_count = Game.views_count
    @favorites_count = Favorite.favorites_count('Game')
    @ratings_count = Rating.ratings_count('Game')
    @comments_count = GameComment.get_count
  end
  
end
