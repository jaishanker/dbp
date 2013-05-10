class Activity < ActiveRecord::Base
  belongs_to :user
  
  def self.points_spent_today(user)      
     self.sum('points_spend', :conditions => ["user_id = ? and created_at between ? and ?", user.id, Date.today, Date.today+1])
  end
end
