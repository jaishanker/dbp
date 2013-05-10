class Contest < ActiveRecord::Base
  
  validates_presence_of :name,:description, :contest_tag
  validates_uniqueness_of :name, :contest_tag
  
  validates_date :start_date
  validates_date :end_date,:after => :start_date
  validates_date :result_date,:after => :end_date

  
  after_create :create_permalink
  
  has_many :pictures, :as => :gallerie
  has_many :participants,:class_name => "ContestParticipant",:foreign_key => "contest_id", :dependent => :destroy
  has_many :active_participants,:class_name => "ContestParticipant",:foreign_key => "contest_id", :conditions => "status = 1", :dependent => :destroy  
  
  cattr_reader :per_page
  @@per_page =PER_PAGE  
  
  def self.find_all
    find(:all,:order => "created_at DESC",:include => {:participants => [:user,:design]})
  end
  
  def self.find_active
    current_date = Date.today().to_s(:db)
    find(:all,:conditions => ["start_date <= '#{current_date}' and end_date >= '#{current_date}' and status = 1"],
         :order => "start_date DESC")    
  end
  
   def self.find_active_with_tag(tag)
    current_date = Date.today().to_s(:db)
    find(:all,:conditions => ["start_date <= '#{current_date}' and end_date >= '#{current_date}' and status = 1 and tags like '#{tag}'"],
         :order => "start_date DESC")    
  end
  
  def contest_status
    
    current_date = Date.today
    
    if self.start_date > current_date
      "To Be started"
    elsif self.start_date < current_date and self.end_date > current_date
    "Running"
    else
    "Over"
    end
    
  end
  
  def participant_ids
    self.participants.collect(&:user_id)
  end
  
  def self.hot_contests(limit = 10)
     find :all,
             :include => [:participants, :pictures],
             :conditions => ["total_participants > 0 and status = 1"],
             :order => "total_participants DESC",
             :limit => limit
  end
  
  def self.find_activated
    find(:all,:conditions => "status = 1",:order => "created_at DESC",:include => {:participants => [:user,:design]})
  end  
  
  private
  
  def create_permalink
    
    design_name = self.name.downcase.gsub(" ", "-").gsub(".", "-").gsub("/","-")
    self.permalink = "#{self.id}-#{design_name}"
    self.save
  end
  
end
