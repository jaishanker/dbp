class Topic < ActiveRecord::Base
  
  validates_presence_of :discussion_category_id,:sub_category_id,:user_id,:title
  validates_uniqueness_of :title,:scope => :sub_category_id
  validates_length_of :title, :within => 3..40
#  validates_format_of :title , :with => /^[0-9A-Za-z._()-+ ]*\z/, :message => "can't contain special characters"
  
  acts_as_shareable  
  
  has_many :posts,:conditions => "status = 1",:order => "created_at ASC"
  has_many :all_posts, :class_name => "Post",:dependent => :destroy    
  belongs_to :sub_category
  belongs_to :discussion_category
  belongs_to :user
  has_many :activity_streams, :as => :actor, :dependent => :destroy  
  has_many :activity_streams, :as => :object, :dependent => :destroy    
  has_many :requests, :as => :requestable, :dependent => :destroy  
  
  cattr_reader :per_page
  @@per_page =PER_PAGE
  
  after_create :create_permalink
  attr_accessor :body
  #  after_update :create_permalink    
  #    before_save :create_permalink      
  
  def self.all_count
    self.count("status = 1")
  end
  
  def self.find_all
    find(:all,:conditions => "",:order => "created_at DESC",:include => [:posts])
  end
  
  def update_count
    self.view_count = view_count.nil? ? 1 : view_count + 1
    self.save
    View.add_view(self.class,self.id)
  end
  
  def self.find_three(top)
    find(:all,:conditions => "status = 1",:order => "created_at DESC",:limit=>top,:include => :posts)
  end
  
  def self.recent_post(top)
    find(:all,:conditions => "status = 1",:order => "created_at DESC",:limit=>top,:include => [:user,{:posts => :user}])
  end
  
  def self.count_all
    count(:all,:conditions => "status = 1")
  end
  
  def self.views
    c = find(:all,:select => "sum(view_count) as sum",:conditions => "status = 1")
    return c[0].sum
  end
  
  def self.find_details(id)
    find_by_permalink(id,:include => [:discussion_category,:sub_category,{:posts => {:user => :posts}}])
  end
  
  
  def new_post_attributes=(post_attributes)
    post_attributes.each do |attributes|
      posts.build(attributes)
    end
  end
  
  def save_posts
    posts.each do |post|
      post.save(false)
    end
  end
  
  def self.search_discussions(search_text,page) 
    condtion_str = Learning.construct_condition_string(search_text)        
    paginate_by_sql("select * from topics where status = 1 and #{condtion_str} order by title",:include => [:user, :posts],:page => page)
    #    paginate :page => page,
    #             :conditions => ['status = ? and title like ?', 1, "%#{search_text}%"],
    #             :include => [:user, :posts],            
    #             :order => 'title'
    #    result = Design.find(:all, :conditions => ["status = ? and name like ? ",1,"%#{search_text}%"],:include => [:user,:pictures,:ratings,:comments,:favoriting_users])
    #    return result
  end  
  
  def create_permalink
    design_name = self.title.downcase.gsub(" ", "-").gsub(".", "-").gsub("/","-")
    self.permalink = "#{self.id}-#{design_name}"
    self.save
  end
  
  def self.get_reporting_values(start_date,group)
    find_by_sql("select #{group}(created_at) as splitter, count(*) as count from topics where status = 1 \
     and date(created_at) >= '#{start_date.to_s(:db)}' group by #{group}(created_at)")
  end
  
  
  def self.add_view_count
    self.all.each do |t|
      count = find_by_sql(["select topic_views from phpbb_topics where topic_title = ?",t.title])
      t.view_count = count[0].topic_views.to_i
      t.save
    end
  end
  
  def self.find_hot_topics
    topic =   find_by_sql "SELECT topics.id as topic_id,count(posts.id) as post_count FROM topics join posts on topics.id = posts.topic_id where topics.status=1 and date(topics.created_at) > '2010-05-01' group by posts.topic_id order by post_count desc limit 10"
    
    list = topic.collect(&:topic_id)
    
    order = ""
    list.each do |l|
      order << l.to_s << ","
    end
    
    find(list,:order => "field(id,#{order.chop})",:include => {:posts => :user})
    
  end 
  
end
