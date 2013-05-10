class UsersController < ApplicationController
  #  after_filter send(:add_points,100), :only => [:activate]
  # Be sure to include AuthenticationSystem in Application Controller instead
  # layout false, :action => "new"
  
  #layout false
  # render new.rhtml
  
  def new  
    
    if params[:event] == "true"
      @event_page = "/events/details/" + params[:event_id].to_s
    end
    
    @user = User.new 
    render :layout => false
  end
  
  def experts
    @search_text = params[:search] unless params[:search].nil?     
    @user = current_user if logged_in?
    if @search_text
      @members = User.search_active_members(@search_text , params[:page] || 1)      
    else
      @members = User.active_members(params[:page] || 1)      
    end
    @no_of_pages = (@members.total_entries.to_f / (USERS_PER_PAGE) ).ceil    
    #    @top_users = User.top_rated(9)
    @activities = ActivityStream.paginate_recent_activities(@offset, 3)
    @top_belts = User.top_belts(6)
  end
  
  def shout
    if logged_in?
      unless params[:shout_text].blank?
          @shout = Shout.new()
          @shout.user_id = current_user.id
          @shout.to_user_id = params[:id]
          @shout.shout = params[:shout_text]
          @shout.status = 1
          @shout.save
          flash[:notice] = "Post has been added successfully"
          redirect_to(:back)
      else
          flash[:notice] = "Post message can not be blank"
          redirect_to(:back)
      end
    else
      flash[:error] = "Please login first"
      redirect_to "/"
    end
  end

  def delete_shout
    shout = Shout.find_by_id(params[:id])
    user = User.find_by_id(params[:user_id])
    shout.status = 0
    shout.save
    shout_length = user.shouts_got.length
    render :update do |page|
      msg = "show_notice('Post has been successfully deleted','success')"
      page.remove "shout_#{shout.id}"
      page.replace_html "total_shouts", "Total Post : #{shout_length}"
      if shout_length == 0
         page.replace_html "more_shouts_link", "No Post yet. Be the first to post!"
      end
      page << msg
    end
  end

  def create
    #    unless params[:agree].nil?  
    logout_keeping_session!
    if !params[:user][:std_code].blank? and !params[:user][:phone_no].blank?
       params[:user][:contact_no] = params[:user][:std_code]+"-"+params[:user][:phone_no]
    elsif !params[:user][:phone_no].blank?
      params[:user][:contact_no] = params[:user][:phone_no]
    end
    @user = User.new(params[:user])
    @user.user_type = 1
    @user.points = 0
    success = @user && @user.save    
    if success && @user.errors.empty?
      #         admin = User.find_by_login('admin')
      #         @user.follow(admin)        
      @user.update_attribute(:status,'1')
      @user.set_profile_complete
      CACHE.delete("total_users")
      @total_user_count = User.count
      CACHE.add("total_users",@total_user_count,2628000,false) # 1 month        
      flash[:notice] = "Thanks for signing up!  We are sending you an email with your activation code, Please check your mail."
      render :update do |page|
        page.redirect_to root_path
      end
      #        flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      render :update do |page|
        #          page << " $('#agree_error'  ).html('');"
        @user.attribute_names.each do |n|
          error_msg = error_message_on( 'user', n )
          error_msg = error_msg.to_s.gsub("<div class=\"formError\">","")
          error_msg = error_msg.to_s.gsub("</div>","")
          page << "displayError(\"user\",\"#{n}\",\"#{error_msg}\");"  if @user.errors.on(n)       
        end
        
        if @user.errors.on('password')
          error_msg = error_message_on( 'user', 'password' )
          error_msg = error_msg.to_s.gsub("<div class=\"formError\">","")
          error_msg = error_msg.to_s.gsub("</div>","")
          
          page <<  "displayError(\"user\",\"password\",\"Password #{error_msg}\");"
          
        end
        
        if @user.errors.on('password_confirmation')
          error_msg = error_message_on( 'user', 'password_confirmation' )
          error_msg = error_msg.to_s.gsub("<div class=\"formError\">","")
          error_msg = error_msg.to_s.gsub("</div>","")
          
          page <<  "displayError(\"user\",\"password_confirmation\",\"Password confirmation doesn't match password\");"
          
        end
        
        if @user.errors.on('terms_of_service')
          error_msg = error_message_on( 'user', 'terms_of_service' )
          error_msg = error_msg.to_s.gsub("<div class=\"formError\">","")
          error_msg = error_msg.to_s.gsub("</div>","")
          
          page <<  "displayError(\"user\",\"terms_of_service\",\"Please accept the terms of service\");"
          
        end
        
        if @user.errors.on('captcha_solution')
          error_msg = error_message_on( 'user', 'captcha_solution' )
          error_msg = error_msg.to_s.gsub("<div class=\"formError\">","")
          error_msg = error_msg.to_s.gsub("</div>","")
          
          page <<  "displayError(\"user\",\"captcha_solution\",\"Captcha solution #{error_msg}\");"
          
        end
      end
    end
    #    else
    #      render :update do |page|
    #        page << "displayError(\"user\",\"agree\",\"Please accept the terms of service\");"
    #      end
    #    end
  end
  
  
  #  this action was added for dumping user data from existing dbp 
  #  
  #  def create_user
  #    
  #    puts params[:user][:created] = params[:user][:created].to_time.to_s(:db) 
  #    puts params[:user][:updated] = params[:user][:updated].to_time.to_s(:db) 
  #    puts "user type : " + params[:user][:user_type]
  #    logger.debug "## email_id : " + params[:user][:email] + " password : " + params[:user][:password]
  #    params[:user][:contact_no] = params[:user][:std_code]+""+params[:user][:phone_no]
  #    @user = User.new(params[:user])
  #    @user.user_type = params[:user][:user_type] == "1" ? 1 : 0
  #    @user.c = params[:user][:created]
  #    @user.u = params[:user][:updated]
  #    @user.id = params[:user][:id]
  #    success = @user && @user.save!    
  #    if success && @user.errors.empty?
  #      render :text => "success"
  #    else
  #      render :text => "error"
  #    end
  #    
  #  end
  #  
  #  
  
  
  
  
  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
      when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      user.add_points(EMAIL_VERIFICATION,"verified_email",user)
      #      user.update_attribute(:points,EMAIL_VERIFICATION)
      flash[:notice] = "Signup complete!"
      self.current_user = user
      
      unless current_user.preferred_page.nil?
        if current_user.preferred_page.include?('event')
          
          event_id = current_user.preferred_page.split('/').last
          event = Event.find(event_id)
          event.update_count
#          if EventParticipant.find_by_event_id_and_user_id(event.id,current_user.id).nil?
#            participant = EventParticipant.new
#            participant.event_id = event.id
#            participant.user_id = current_user.id
#            participant.status = 1
#            participant.save
#          end
          current_user.preferred_page = nil
          current_user.save
          
          redirect_to "/events/details/" + event.id.to_s
        else
          redirect_to '/'  
        end
      else
        redirect_to '/'  
      end
      
      #    redirect_to '/login'
      when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end
  
  
  def home
    
  end
  
  def my_groups
    @user = User.find(params[:id])
    @profile = @user.profile    
    @groups = @user.active_groups
  end
  
  def my_favorites
    @user = User.find(params[:id])
    @profile = @user.profile
    @favorite_groups = @user.favorite_groups
    @favorite_designs = @user.favorite_designs
    @favorite_learnings = @user.favorite_learnings
    @favorite_games = @user.favorite_games
    @total_sharing_count = User.total_sharing_count(@user.id)
    #      User.count_by_sql("select count(*) from shares where shared_to_type = 'User' and shared_to_id = "+@user.id.to_s)
  end
  
  
  def pointing_system    
  end
  
  def unsubscribe
    u = User.find_by_id_and_salt(params[:uid],params[:eid])
    if u
      u.subscribe = 0
      u.save
    end
    flash[:notice] = "Sucessfully unsubscribed."
    redirect_back_or_default('/')
    
  end

  def news_unsubscribe
    u = User.find_by_id_and_salt(params[:uid],params[:eid])
    if u
      u.news_subscribe = 0
      u.save
    end
    flash[:notice] = "Sucessfully unsubscribed."
    redirect_back_or_default('/')

  end

  def news_subscribe
    u = User.find_by_id_and_salt(params[:uid],params[:eid])
    if u
      u.news_subscribe = 1
      u.save
    end
    flash[:notice] = "Sucessfully subscribed."
    redirect_back_or_default('/')

  end
  
  
  def reset_password
    @user = ForgotPassword.find_by_key_and_expires(params[:exe],0)
    if @user
    else
      flash[:notice] = "Reset password link has expired! Click on forgot password to reset your password again."
      redirect_to('/')
    end
  end
  
  def change_password
    if !params[:password].blank?
      if !(params[:password].size.to_i < 6) and !(params[:password].size.to_i > 30)
        if ((params[:password] == params[:password_confirmation]) && !params[:password_confirmation].blank?)
          @user = User.find_by_id(params[:user][:id])
          forgot_pass = ForgotPassword.find_by_user_id_and_key(params[:user][:id],params[:user][:key])
          forgot_pass.expires = 1
          
          @user.password_confirmation = params[:password_confirmation]
          @user.password = params[:password]
          forgot_pass.save
          self.current_user = @user
          @user.save
          
          flash[:notice] = 'Password has been changed successfully.'
          url = '/'
        else
          flash[:error] = 'New password and confirm password do not match.'
          url = :back
        end
      else
        flash[:error] = 'Password should be between 6 to 30 characters long.'
        url = :back
      end
    else
      flash[:error] = 'Password cannot be blank.'
      url = :back
    end
    render :update do |page|
      page.redirect_to(url)
    end
  end
  
  def notify_user
    @message = params[:notify][:message] unless params[:notify][:message].nil?
    @subject =  params[:notify][:subject] unless params[:notify][:subject].nil?
    if params[:notify][:all].to_i == 1
      i=1
      if !params[:notify][:message].empty? and !params[:notify][:subject].empty?
        begin
          users_collection = User.paginate( :conditions => ["activation_code is null and id=1"],:page=>i,:per_page=>2, :order => "updated_at desc")
          if users_collection.size > 0
            users_collection.each do |u|
              begin
                begin
                  UserMailer.deliver_notification(u,@message,@subject)
                rescue
                end
              rescue
              end
            end
          end
          i = i + 1
          #              sleep(20)
        end while not users_collection.empty?
        redirect_to :controller =>"admin_base" ,:action=>"notify_users"
      else
        message = "show_notice('Please give subject and message.','error')"
        render :update do |page|
          page << message
        end
      end
    elsif !params[:notify][:message] == "" and !params[:notify][:subject] == ""
      begin
        users_collection = User.paginate( :conditions => ["activation_code is null"],:page=>i,:per_page=>2, :order => "updated_at desc")
        if users_collection.size > 0
          users_collection.each do |u|
            begin
              begin
                UserMailer.deliver_notification(u,@message,@subject)
              rescue
              end
            rescue
            end
          end
        end
        i = i + 1
        #        sleep(20)
      end while not users_collection.empty?
    else
      message = "show_notice('Please fill all fields.','error')"
      render :update do |page|
        page << message
      end
    end
    
    
  end
  
  def redemptions
    @user = User.find(params[:id])
    @offset = 0
    @redemptions = Redemption.get_redemptions(@user.id,@offset)
  end
  
  def get_more_redemptions 
    @offset =  params[:offset].to_i+PER_PAGE
    @user  = User.find(params[:user_id])
    @redemptions = Redemption.get_redemptions(@user.id,@offset)
    respond_to do |format|
      format.html
      format.js {
        render :update do |page| 
          unless @redemptions.size == 0
            page.insert_html :bottom, 'redemptions', :partial => 'more_redemptions'
          else
            page.insert_html :bottom, 'redemptions', 'No more redemptions are there'
          end
        end
      }
    end 
  end  
  
  def link_user_accounts
    if self.current_user.nil?
      #register with fb
      User.create_from_fb_connect(facebook_session.user)
    else
      #connect accounts
      self.current_user.link_fb_connect(facebook_session.user.id) unless self.current_user.fb_user_id == facebook_session.user.id
    end
    if current_user.details_filled?
       redirect_to recent_activity_path
    else
        redirect_to ask_details_users_path      
    end
#    redirect_to recent_activity_path
  end
  
  def ask_details
    @user = current_user
  end
  
  def update
    @user = current_user
    if !params[:user][:std_code].blank? and !params[:user][:phone_no].blank?
       params[:user][:contact_no] = params[:user][:std_code]+"-"+params[:user][:phone_no]
    elsif !params[:user][:phone_no].blank?
      params[:user][:contact_no] = params[:user][:phone_no]
    end    
    @user.update_attributes(params[:user])
      success = @user && @user.save    
    if success && @user.errors.empty?    
      UserMailer.deliver_login_details(current_user, params[:user][:password])      
      redirect_to recent_activity_path
    else
      render :action => "ask_details"
    end
  end 

  
end
