class News < ActiveRecord::Base
  
  has_many :pictures, :as => :gallerie  
  has_many :comments, :as => :commentable, :dependent => :destroy  
  belongs_to :user
  has_many :activity_streams, :as => :actor, :dependent => :destroy  
  has_many :activity_streams, :as => :object , :dependent => :destroy    
  has_many :requests, :as => :requestable, :dependent => :destroy  
  
  validates_presence_of :title,:description,:category_id,:user_id
  validates_uniqueness_of :title,:case_sensitive => true 
  validates_date :start_date
  validates_date :end_date,:after => :start_date
  acts_as_commentable

  acts_as_shareable

  after_create :create_permalink  
#  after_update :create_permalink    
#    before_save :create_permalink      
  
  cattr_reader :per_page
  @@per_page =PER_PAGE
  
  def self.find_all(top = 1000)
    find(:all,:order => "created_at DESC",:limit => top,:include => :comments)
  end
  
  def self.views_count
    sum = self.find_by_sql("select sum(view_count) as sum from news")
    return sum[0].sum || 0
  end
  
  def self.find_all_filtered(page, sort_by = 'created_at DESC')
    current_date = Date.today().to_s(:db)
    paginate(:conditions => ["start_date <= '#{current_date}' and end_date >= '#{current_date}' and status = 1"],
         :order => sort_by,:page => page,:include => [:pictures,:comments])    
#    find(:all,:conditions => ["start_date <= '#{current_date}' and end_date >= '#{current_date}' and status = 1"],
#         :order => sort_by,:limit => top,:include => [:pictures,:comments])
  end
  
  def self.total_count(status)
    News.count(:conditions => ['status = ?', status ])
  end
  
  def update_count
    self.view_count = view_count.nil? ? 1 : view_count + 1
    self.save
    View.add_view(self.class,self.id)
  end
  
  def self.search_news(search_text,page)
    current_date = Date.today().to_s(:db)    
    condtion_str = Learning.construct_condition_string(search_text)        
    paginate_by_sql("select * from news where status = 1 and start_date <= '#{current_date}' and end_date >= '#{current_date}' and #{condtion_str} order by title", :page => page)        
#    result = News.find(:all, :conditions => ["status = ? and title like ? and start_date <= ? and end_date >= ?",1,"%#{search_text}%",current_date,current_date],:include => [:pictures,:comments])
#    return result
  end
  
  def self.all_active
    current_date = Date.today().to_s(:db)
    count( :conditions => ["start_date <= '#{current_date}' and end_date >= '#{current_date}' and status = 1"])    
#    find(:all,:conditions => ["start_date <= '#{current_date}' and end_date >= '#{current_date}' and status = 1"],
#         :order => sort_by,:limit => top,:include => [:pictures,:comments])
  end  

  def create_permalink
    design_name = self.title.downcase.gsub(" ", "-").gsub(".", "-").gsub("/","-").gsub("/","-")
    self.permalink = "#{self.id}-#{design_name}"
    self.save
  end   
  
end
