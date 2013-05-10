class Event < ActiveRecord::Base
  
  validates_presence_of :topic,:eventtype,:product,:description,:organizer,:date,:city,:state,:location,:sponsor,:directions
  validates_length_of :topic,:eventtype,:product,:organizer,:city,:state,:location,:sponsor,:within => 3..100,:allow_blank => true
  validates_numericality_of :pin,:phone_no
  
  validates_time :start_time
  validates_time :end_time,:after => :start_time
  
  belongs_to :user  
  has_many :participants ,:class_name => "EventParticipant",:conditions => "status = 1"
  has_many :activity_streams, :as => :actor, :dependent => :destroy  
  has_many :activity_streams, :as => :object, :dependent => :destroy  
  after_create :create_permalink
#  after_update :create_permalink   
 #   before_save :create_permalink   
  
  def self.all_count
    self.count("status = 1")
  end
  
  def self.find_all(conditions = "")
    self.find(:all,:conditions => conditions, :order => "date DESC",:include => :participants)
  end
  
  def self.views_count
    sum = self.find_by_sql("select sum(view_count) as sum from events")
    return sum[0].sum || 0
  end
  
  def self.find_auto_complete_results(type,query)
    find(:all,:select => type + " as result",:conditions => type + " like '%#{query}%'" )
  end
  
  def self.find_active()
    current_date = Date.today().to_s(:db)    
    self.find(:all,:conditions => "status = 1 and date>='#{current_date}'", :order => "date DESC")
  end
  
  def self.find_by_organizer(organizer_id)
    current_date = Date.today().to_s(:db)    
    self.find(:all,:conditions => "status = 1 and date>='#{current_date}' and user_id = #{organizer_id}", :order => "date DESC")
  end  
  
  def self.search_filter(type,topic,product,organizer,city,state,pincode)
    current_date = Date.today().to_s(:db)        
    condition = "date >= '#{current_date}' and"
    condition += " eventtype = '#{type}' and" unless type.blank?
    condition += " topic = '#{topic}' and" unless topic.blank?
    condition += " product = '#{product}' and" unless product.blank?
    condition += " organizer = '#{organizer}' and" unless organizer.blank?
    condition += " city = '#{city}' and" unless city.blank?
    condition += " state = '#{state}' and" unless state.blank?
    condition += " pin = '#{pincode}' and" unless pincode.blank?    
    
    self.find(:all,:conditions =>"#{condition} status=1", :order => "date DESC")
    
  end

  def create_permalink
    design_name = self.topic.downcase.gsub(" ", "-").gsub(".", "-").gsub("/","-")
    self.permalink = "#{self.id}-#{design_name}"
    self.save
    UserMailer.deliver_event_creation_notification(self,self.user)
  end   

  def update_count
    self.view_count = view_count.nil? ? 1 : view_count + 1
    self.save
    View.add_view(self.class,self.id)
  end
end
