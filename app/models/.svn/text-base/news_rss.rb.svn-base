class NewsRss < ActiveRecord::Base
  
  validates_presence_of :title,:link
  validates_uniqueness_of :title
  
  def self.find_active 
    find(:all,:conditions => "status = 1",:order => "updated_at DESC" )
  end
  
  def self.find_all
    find(:all,:order => "created_at DESC" )
  end
  
end
