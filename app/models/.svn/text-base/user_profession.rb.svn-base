class UserProfession < ActiveRecord::Base
  belongs_to :user
  attr_accessor :duration_months
  
  validates_presence_of  :employer, :message => "Employer can't be blank"
  validates_presence_of  :position, :message => "Position can't be blank"
  validates_presence_of  :industry, :message => "Industry can't be blank"
  validates_presence_of  :duration, :message => "Duration can't be blank"  
end
