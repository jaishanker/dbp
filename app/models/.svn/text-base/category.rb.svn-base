class Category < ActiveRecord::Base
  
  
  validates_presence_of :name,:status
  validates_uniqueness_of :name,:scope => :type,:case_sensitive => false
  validates_format_of :name, :with => /^[0-9A-Za-z. ]*\z/, :message => "can't contain special characters",:allow_nil => true
  validates_length_of     :name,    :within => 3..25
  
end
