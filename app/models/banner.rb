class Banner < ActiveRecord::Base
  
  validates_presence_of :banner_type,:name
  validates_presence_of :banner_link,:if => :side_banner?,:on => :create
  validates_presence_of :banner_page,:message => "must be selected",:if => :side_banner?,:on => :create
  validates_presence_of :banner_code,:unless => :side_banner?,:on => :create
  
  has_many :pictures, :as => :gallerie  
  
  attr_accessor :page
  
  def self.find_all
    find(:all,:order => "created_at DESC")
  end
  
  
  def self.top_banner
    banner =  find(:all,:conditions => "status = 1 and banner_type = 'Main'",:order => "created_at DESC",:limit => 1)
    return banner[0]
  end
  
  def self.right_banner
    find(:all,:conditions => "status = 1 and banner_type = 'Page'",:order => "created_at DESC")
    
  end
  
  def side_banner?
    page == "true"
  end
  
end
