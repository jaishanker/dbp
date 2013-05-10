class UserObserver < ActiveRecord::Observer
  def after_create(user)
    p"&&&&&&&&&&&& called &&&&&&&&&&&&&7"
    UserMailer.deliver_signup_notification(user)
    profile = Profile.new(:user_id => user.id)    
    profile.save
    privacy_setting = PrivacySetting.new(:user_id => user.id, :requests_member =>1, :followings_member => 1, :followers_member => 1, :favourites_member => 1, :contests_member => 1)    
    privacy_setting.save    
  end

  def after_save(user)
    UserMailer.deliver_activation(user) if user.recently_activated?  
  end
end
