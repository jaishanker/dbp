class SubCategory < ActiveRecord::Base
  
  validates_presence_of :name,:discussion_category_id,:status
  validates_uniqueness_of :name,:case_sensitive => false
  validates_format_of :name, :with => /^[0-9A-Za-z. ]*\z/, :message => "can't contain special characters",:allow_nil => true
  validates_length_of     :name,    :within => 3..25
  validates_length_of     :description,    :within => 3..100,:allow_nil => true
  
  belongs_to :category,:class_name => "DiscussionCategory",:foreign_key => "discussion_category_id"
  has_many :topics, :conditions => "status = 1",:order => "created_at DESC"
  has_many :all_topics, :class_name => "Topic"
  has_many :topics_count,:select => "count(*) as count", :conditions => "status = 1"
  has_many :all_topics, :class_name => "Topic", :dependent => :destroy  
  
  named_scope :all_active,:conditions => "status = 1",:order => "created_at DESC"
  
  def self.find_all
    find(:all,:order => "created_at DESC",:include => :category)
  end
  
  
  def self.find_details(id)
    find(id,:include => [:category,{:topics => {:posts => :user}}])
  end

  def self.count_active()
    self.count(:conditions => ["status = ?",1])
  end

end
