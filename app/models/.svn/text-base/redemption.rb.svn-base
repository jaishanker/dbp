class Redemption < ActiveRecord::Base
  belongs_to :product
  belongs_to :user
  has_one :redeem_user_info
  
  def self.get_redemptions(user_id,offset)
        find(:all, :conditions => ["user_id = ? and status = 1", user_id],:order => "created_at desc",  :offset => offset, :limit => PER_PAGE,:include => [:product])  
  end
end

