class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your account'
  
    @body[:url]  = "http://#{SITE_URL}/activate/#{user.activation_code}"
  
  end

  def weekly_report(start_date,end_date,users_count,total_active_users_count,total_users_count,posts_count,new_designs_count,new_comment_count)
    setup_weekly_email()
    @start_date = start_date
    @end_date = end_date
    @users_count = users_count
    @total_active_users_count = total_active_users_count
    @total_users_count = total_users_count
    @posts_count = posts_count
    @new_designs_count = new_designs_count
    @new_comment_count = new_comment_count
  end

  def forgot_password(user)
    setup_email(user)
    #     @key = rand(999999999).to_i
    @key = Digest::SHA1.hexdigest(rand.to_s).first(25)
    forgot_pass = ForgotPassword.new()
    forgot_pass.user_id = user.id
    forgot_pass.key = @key
    forgot_pass.expires = 0
    forgot_pass.save
    @subject    += 'Reset Your Password'
    @body[:reset_passowrd]  = "http://#{SITE_URL}/reset_password?exe=#{@key}"
  end

  def notification(user,message,subject,reply_to,news=nil)
    @news = news
    setup_email(user)
    @subject    += subject
    @reply_to = reply_to unless reply_to.blank? or reply_to.nil?
    @message = message
    @user_name = user.first_name + " " +user.last_name
    @body[:unsubscribe_url]  = "http://#{SITE_URL}/news_unsubscribe?uid=#{user.id}&eid=#{user.salt}"
    @body[:subscribe_url]  = "http://#{SITE_URL}/news_subscribe?uid=#{user.id}&eid=#{user.salt}"
  end

  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://#{SITE_URL}/"
  end
  
  def comment_posting_notification(user , comment)
    commentable_object = comment.commentable
    commentor = comment.user
    setup_email(user)
    if user == commentable_object.user and commentable_object.class.name == "Design"
      @subject  = "#{commentor.login.capitalize} commented on your #{comment.commentable_type.downcase}"
    elsif  commentable_object.class.name == "Design"
      if commentor == commentable_object.user
        if commentor.gender == "Male"
          @subject  = "#{commentor.login.capitalize} commented on his own #{comment.commentable_type.downcase}"
        else
          @subject  = "#{commentor.login.capitalize} commented on her own #{comment.commentable_type.downcase}"
        end
      else
        @subject  = "#{commentor.login.capitalize} commented on #{commentable_object.user.login.capitalize}'s #{comment.commentable_type.downcase}"
      end
    else
      @subject  = "#{commentor.login.capitalize} commented on #{comment.commentable_type.downcase}"
    end
    @subject = @subject + " tutorial" if comment.commentable_type == "Learning"
    if commentable_object.class.name == "Design"
      @subject = @subject +" : "  +commentable_object.name.to_s
    else
      @subject = @subject +" : "  +commentable_object.title.to_s      
    end
    @body[:commentable_object]  = commentable_object 
    @body[:comment]  = comment     
    @body[:commentor] = commentor
    @body[:object_url] = "http://#{SITE_URL}/#{commentable_object.class.name.downcase.pluralize}/#{commentable_object.class.name.downcase}/#{commentable_object.permalink}"
    @body[:unsubscribe_url]  = "http://#{SITE_URL}/unsubscribe?uid=#{user.id}&eid=#{user.salt}"
  end

  def shout_posting_notification(user,shouted_user)
    @shouted_user = shouted_user
    setup_email(user)
    @subject  = "#{@shouted_user.login.capitalize} has written on your wall."
    @body[:url]  = "http://#{SITE_URL}/"
    @body[:unsubscribe_url]  = "http://#{SITE_URL}/unsubscribe?uid=#{user.id}&eid=#{user.salt}"
  end  
  
  def favorite_received_notification(user ,favorited_by, design)
    setup_email(user)
    @subject  = "#{favorited_by.login.capitalize} favorited your design"
    @body[:design]  = design 
    @body[:favorited_by]  = favorited_by     
    @body[:design_url] = "http://#{SITE_URL}/designs/design/#{design.permalink}"
    @body[:unsubscribe_url]  = "http://#{SITE_URL}/unsubscribe?uid=#{user.id}&eid=#{user.salt}"    
  end    
  
  def rating_received_notification(user ,rated_by, design)
    setup_email(user)
    @subject  = "#{rated_by.login.capitalize} has given rating to your design"
    @body[:design]  = design 
    @body[:rated_by]  = rated_by     
    @body[:design_url] = "http://#{SITE_URL}/designs/design/#{design.permalink}"
    @body[:unsubscribe_url]  = "http://#{SITE_URL}/unsubscribe?uid=#{user.id}&eid=#{user.salt}"    
  end    
  
  def follower_addition_notification(user ,follower)
    setup_email(user)
    @subject  = "#{follower.login.capitalize} is now following you"
    @body[:follower]  = follower     
    @body[:follower_url] = "http://#{SITE_URL}/profiles/mypage?user_id=#{follower.id}"
    @body[:unsubscribe_url]  = "http://#{SITE_URL}/unsubscribe?uid=#{user.id}&eid=#{user.salt}"    
  end      
  
  def group_create_notification(group)
    admin = User.find_by_login('admin')
    setup_email(admin)
    @subject  = "#{group.owner.login.capitalize} has created new group"
    @cc = "lubna.markar@3ds.com"
    @body[:group]  = group     
    #    @body[:group_url] = "http://#{SITE_URL}/group/#{group.permalink}"
    #    @body[:unsubscribe_url]  = "http://#{SITE_URL}/unsubscribe?uid=#{user.id}&eid=#{user.salt}"
  end 
  
  def group_activation(group)
    user = group.owner
    setup_email(user)
    @subject  = "Admin has activated your group"
    @body[:group]  = group     
    @body[:group_url] = "http://#{SITE_URL}/group/#{group.permalink}"
    @body[:unsubscribe_url]  = "http://#{SITE_URL}/unsubscribe?uid=#{user.id}&eid=#{user.salt}"    
  end   
  
  def group_deactivation(group)
    user = group.owner
    setup_email(user)
    @subject  = "Admin has deactivated your group"
    @body[:group]  = group     
    #    @body[:group_url] = "http://#{SITE_URL}/group/#{group.permalink}"
    @body[:unsubscribe_url]  = "http://#{SITE_URL}/unsubscribe?uid=#{user.id}&eid=#{user.salt}"    
  end    
  
  def redemption_notification(user,product)
    setup_email(user)
    @subject  = "Your request for redemption has been sent to admin"
    @body[:product]  = product         
    #    @body[:group_url] = "http://#{SITE_URL}/group/#{group.permalink}"
    @body[:unsubscribe_url]  = "http://#{SITE_URL}/unsubscribe?uid=#{user.id}&eid=#{user.salt}"    
  end     
  
  def redemption_notification_admin(requester,product)
    user = User.find_by_login('admin')
    setup_email(user)    
    @subject  = "#{requester}.login.capitalize has requested for redemption"
    @body[:product]  = product     
    @body[:requester]  = requester     
    #    @body[:group_url] = "http://#{SITE_URL}/group/#{group.permalink}"
    @body[:unsubscribe_url]  = "http://#{SITE_URL}/unsubscribe?uid=#{user.id}&eid=#{user.salt}"    
  end     
  
  def redemption_approval_notification(redemption)
    user = redemption.user
    redemption_user_info = RedeemUserInfo.find_by_redemption_id(redemption.id)    
    setup_email(user)    
    @subject  = "Your request for redemption approved"
    @body[:product]  = redemption.product     
    @body[:shipment_type] = redemption_user_info.shipment_type
    #    @body[:group_url] = "http://#{SITE_URL}/group/#{group.permalink}"
    @body[:unsubscribe_url]  = "http://#{SITE_URL}/unsubscribe?uid=#{user.id}&eid=#{user.salt}"    
  end    
  
  def shipment_notification(redemption)
    user = redemption.user
    product = redemption.product
    setup_email(user)    
    @subject  = "#{product.title.capitalize} has been shifted"
    @body[:product]  = product
    #    @body[:group_url] = "http://#{SITE_URL}/group/#{group.permalink}"
    @body[:unsubscribe_url]  = "http://#{SITE_URL}/unsubscribe?uid=#{user.id}&eid=#{user.salt}"    
  end    
   
  def login_details(user,password)
    setup_email(user)   
    @subject  = "Your login details"    
    @body[:password]  = password
    @body[:unsubscribe_url]  = "http://#{SITE_URL}/unsubscribe?uid=#{user.id}&eid=#{user.salt}"        
  end
  
  def event_creation_notification(event,user)
    setup_email(user)
    @subject  = "Event creation notification"
    @body[:event]  = event 
    @body[:event_url] = "http://#{SITE_URL}/events/list/#{event.user_id}"
    @body[:unsubscribe_url]  = "http://#{SITE_URL}/unsubscribe?uid=#{user.id}&eid=#{user.salt}"    
  end      
  
  protected
  
  def setup_email(user)
    @recipients  = "#{user.email}"
    @content_type = "text/html"
    @from        = "SolidWorks Team <no-reply@solidworks.com>"
    @bcc         = "007solidworks007@gmail.com"
    @subject     = "SolidWorks - "
    @sent_on     = Time.now
    @body[:user] = user
  end

  def setup_weekly_email()
    @recipients  = "sharon.ang@3ds.com,prashant.malik@3ds.com"
    @cc = "solidworkshosting@gmail.com"
    @content_type = "text/html"
    @from        = "SolidWorks Team <no-reply@solidworks.com>"
    @subject     = "SolidWorks - Weekly fans.solidworks.in report "
    @sent_on     = Time.now
    #      @body[:user] = user
  end

end
