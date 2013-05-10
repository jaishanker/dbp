class HallOfFame < ActiveRecord::Base
  
  validates_presence_of :name,:message => "Name can't be blank"
  validates_presence_of :email,:message => "Email can't be blank"
  validates_presence_of :certification,:message => "Please select certification"
  validates_presence_of :simulation_no,:message => "Certification Number can't be blank"
  validates_date :certification_date,:before => Proc.new {Date.today.next},:message => "Certification Date is Invalid"
  validates_format_of       :email,    :with => Authentication.email_regex,:message =>"Please specify valid email address"
  
  
  has_many :pictures, :as => "gallerie"
  
  cattr_reader :per_page
  @@per_page =PER_PAGE  
  
  def self.find_active(page=1)
   paginate :page => page, :conditions => "status = 1",:order => "created_at DESC",:include => :pictures    
 #   find(:all,:conditions => "status = 1",:order => "created_at DESC",:include => :pictures)
  end
  
  def self.find_all
    find(:all,:conditions => "status = 1 or status = 0")    
  end
  
  def self.find_by_cetification(certification , page=1)
   paginate :page => page, :conditions => ["status = 1 and certification in (?) ",certification],:order => "created_at DESC",:include => :pictures    
 #   find(:all,:conditions => "status = 1",:order => "created_at DESC",:include => :pictures)
  end  
end
