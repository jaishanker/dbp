# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
#  include AuthenticatedSystem
  layout false
  
  def new
    
    if params[:event] == "true"
      @event_id = params[:event_id]
    end
    
  end
  
  def create
    logout_keeping_session!
    user = User.authenticate(params[:username].rstrip, params[:password].rstrip)
    unless user.nil?
      if !user.activated_at.nil?
        self.current_user = user
          if params[:remember_me] == "1"
          self.current_user.remember_me
          cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
        end      
        current_user.last_login_at = Time.now.to_s(:db)
        current_user.login_count = current_user.login_count.nil? ? 1 : current_user.login_count + 1
        current_user.save

        user_login_details = UserLoginDetail.new()
        user_login_details.user_id = current_user.id
        user_login_details.user_ip = request.remote_ip
        user_login_details.save
        p "user ip---------------->"
        p "Users IP: #{request.remote_addr}"
        p "Users IP: #{request.remote_ip}"

        new_cookie_flag = (params[:remember_me] == "1")
        handle_remember_cookie! new_cookie_flag
        render :update do |page|
          if params[:admin_login]
            page.redirect_to "/admin"
          else

            if params[:event_id]

              @event = Event.find(params[:event_id])
              @event.update_count
#              if EventParticipant.find_by_event_id_and_user_id(@event.id,current_user.id).nil?
#                participant = EventParticipant.new
#                participant.event_id = @event.id
#                participant.user_id = current_user.id
#                participant.status = 1
#                participant.save
#              end
                page.redirect_to "/events/details/" + @event.id.to_s


            else

              @activities = ActivityStream.paginate_recent_activities(@offset, 3)
               if current_user.details_filled?
                  page.redirect_to(recent_activity_path)
              else
                  page.redirect_to(ask_details_users_path)    
              end 
              #            if user.preferred_page.nil?
              #               page.redirect_to(:back)
              #            else
              #              page.redirect_to user.preferred_page
              #            end
            end
          end
        end
      elsif
        render :update do|page|
         page.visual_effect :appear, :browser_notice1
         page.replace_html :browser_notice1, "<p class='error-notice'>Hi '#{user.login}' Please check your mail to activate your account or <a style='color:#FFFFFF' ' href='sessions/send_activation_code/#{user.id}'>(Click to send activation code again)</a></p>"
      end
      else
        #      note_failed_signin
        @login       = params[:login]
        @remember_me = params[:remember_me]
        render :update do|page|
        message = "show_notice('Please check your username and password and try again','error')"
        page << message
      end
    end
 else
        render :update do|page|
          message = "show_notice('Please check your username and password and try again','error')"
          page << message   
        end
 end
end

  def send_activation_code
    
   user = User.find_by_id(params[:id])
   if !user.nil?
     UserMailer.deliver_activation(user)
     flash[:notice] = "We are sending you an email with your activation code, Please check your mail."
      redirect_to '/' and return
   end

  end

def destroy
  logout_killing_session!
  #     flash[:notice] = "You have been logged out."
  if params[:id]
    redirect_to "/admin"
  else
    redirect_back_or_default('/')
  end
  
  
end

def forgot_password
  @user = User.new
end

def forgot
  if request.post?
    p "forgot-------------------->"
    p params[:user][:email]
    
    if !params[:user][:email].blank?
      user = User.find_by_email(params[:user][:email]) unless params[:user][:email].nil?
      p "inside------------------>"
      if user
        #this line sends the mail
        #        pass = Digest::SHA1.hexdigest(rand.to_s).first(10)
        #        user.password = pass
        #        user.password_confirmation = pass
        #        user.save!
        
        UserMailer.deliver_forgot_password(user)
        message = "show_notice('Reset code sent to <b><u>#{user.email}</u></b>','success')"
        
        render :update do |page|
          
          page << message
          page << "$('.cancel_popup').trigger('click')"
        end
      else
        message = "show_notice('<b><u> #{params[:user][:email]}</u> does not exist in system </b>','error')"
        render :update do |page|
          page << message
        end
      end
    else
      message = "show_notice('Email-Id Cant be blank.','error')"
      render :update do |page|
        page << message
      end
    end
  end
  
end

def reset
  @user = User.find_by_forgot_token(params[:forgot_token]) unless params[:forgot_token].nil?
  if !(@user)
    flash[:error] = "Wrong reset code entered. Please enter correct URL."
    redirect_to "/"
  else
    flash[:error] = ""
    redirect_to "/"
  end
  
end 

protected
# Track failed login attempts
def note_failed_signin
  flash[:error] = "Couldn't log you in as '#{params[:login]}'"
  logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.now.utc}"
end
end
