class ContestParticipant < ActiveRecord::Base
  
  validates_presence_of :contest_id,:user_id,:design_id
#  validates_uniqueness_of :contest_id,:scope => :user_id
  
  belongs_to :contest
  belongs_to :user
  belongs_to :design
  
  
end
