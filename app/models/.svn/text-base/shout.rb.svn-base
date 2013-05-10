class Shout < ActiveRecord::Base

 belongs_to :user
 after_create :notify_shout_posting

  def self.user_shouts(id,top,offset=0)
    result = Shout.find(:all,:conditions =>"to_user_id=#{id} and status = 1",
                                :order => "created_at ASC",:include =>[],:offset => offset, :limit => top)
    return result
  end

  def notify_shout_posting
     shouted_user = self.user
     user = User.find_by_id(self.to_user_id)
     unless user.nil?
        UserMailer.deliver_shout_posting_notification(user,shouted_user)
     end
  end 

end
