class Design < ActiveRecord::Base
  
  # validations
  
  validates_presence_of     :name, :message => "Name can't be blank"
  validates_presence_of     :category_id, :message => "Category can't be blank"
  validates_presence_of     :description, :message => "Description can't be blank"
  validates_length_of       :name,    :within => 1..100, :message => "Name should be between 3 to 20 characters long"
  validates_uniqueness_of   :name, :message => "Name has already been taken"
  validates_format_of       :name,     :with => /^[A-Za-z]+[0-9A-Za-z. -,']*\z/,  :message => "Should not contain special characters"
  #  validates_acceptance_of   :terms_of_service , :message => "Please accept the terms of service"
  validates_associated      :pictures
  acts_as_rateable
  
  acts_as_commentable
  
  acts_as_shareable
  
  acts_as_favorite  
  has_many :ratings_count,:class_name => "Rating",:conditions => "rateable_type = 'Design'",:foreign_key => "rateable_id" 
  has_many :pictures, :as => :gallerie  
  
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :activity_streams, :as => :actor, :dependent => :destroy  
  has_many :activity_streams, :as => :object, :dependent => :destroy   
  has_many :requests, :as => :requestable, :dependent => :destroy  
  belongs_to :user
  has_many :favorites, :as => :favorable, :dependent => :destroy  
#  has_many :design_tags, :class_name => 'Tag',:conditions => "tagable_type = 'Design'", :foreign_key => "tagable_id"   
  has_many :design_tags, :class_name => 'Tag', :as => :tagable, :dependent => :destroy       
  has_many :participants,:class_name => "ContestParticipant",:foreign_key => "design_id", :dependent => :destroy
  
  
  attr_accessor  :terms_of_service,:certify
  
  #  has_many :comments, :as => :commentable, :dependent => :destroy
  #  has_many :design_comments, :as => :commentable, :dependent => :destroy
  
  def validate
    if certify == "1"
      unless terms_of_service == "1" 
        self.errors.add('terms_of_service',"Please certify your design")
      end
    end
  end
  
  named_scope :recent_designs, :conditions => "status = 1",:order => "created_at DESC",:limit => 10,:include => [:pictures,{:user => :pictures}]
  named_scope :top_rated_design,:conditions => "status = 1",:select => "d.*, AVG(r.rating) as avg",
              :from => "designs d JOIN ratings r ON d.id = r.rateable_id and r.rateable_type = 'Design'",
              :group => "d.id", :order => "avg DESC",:limit=>5
  named_scope :top_rated_design_home,:conditions => "d.status = 1",:select => "d.*, AVG(r.rating) as avg",
              :from => "designs d JOIN ratings r ON d.id = r.rateable_id and r.rateable_type = 'Design'",
              :group => "d.id", :order => "avg DESC",:limit=>2
  
  cattr_reader :per_page
  @@per_page =PER_PAGE
  
  
  after_create :create_permalink
#  after_update :create_permalink  
  #  before_save :create_permalink  #  
  #   has_permalink [:id,:name], :update => true
  

  def self.find_weekly_report(start_date,end_date)
      Design.find_by_sql("select COUNT(*) as c from designs where date(created_at) BETWEEN '#{start_date}' and '#{end_date}'")
  end

  def self.top_rated_designs(status,page)    
     paginate :page => page,
             :include => [:user,:pictures,:ratings,:comments,:favoriting_users],
             :joins => "left outer join ratings on (designs.id = ratings.rateable_id and ratings.rateable_type = 'Design')",
             :conditions => ["designs.status = ?",status],
             :group => "designs.id",
             :order => "AVG(ratings.rating) DESC"
    
  end
  
  def self.all_top_rated_designs
     find :all,
             :include => [:user,:pictures,:ratings,:comments,:favoriting_users],
             :joins => "left outer join ratings on (designs.id = ratings.rateable_id and ratings.rateable_type = 'Design')",
             :conditions => ["designs.status = ?",1],
             :group => "designs.id",
             :order => "AVG(ratings.rating) DESC"
    
  end  
  
  def self.all_count
    self.count(:conditions => "status = 1")
  end
  
  def self.find_all(top = 1000)
    find(:all,:conditions => "",:order => "created_at DESC",:limit => top,:include => [:comments,:ratings_count,:favorites,{:user => :designs},:shares])
  end
  
  def self.views_count
    sum = self.find_by_sql("select sum(view_count) as sum from designs")
    return sum[0].sum || 0
  end
  
  
  def self.my_designs(user_id)
    find(:all,:conditions => ["status = 1 and user_id = ?",user_id],:order => "created_at DESC")
  end
  
  def self.user_designs(user_id)
    find(:all,:conditions => ["status = 1 and user_id = ?",user_id])
  end  
  
  def update_count
    self.view_count = view_count.nil? ? 1 : view_count + 1
    self.save
    View.add_view(self.class,self.id)
    
  end
  
  def self.group_member_design(members)
    members= members.join ","
    result = find_by_sql("SELECT * FROM designs where designs.status=1 and designs.user_id in (#{members}) order by designs.created_at DESC limit 5")
    return result
  end
  
  def self.paginate_group_member_design(members,page)
    members= members.join ","
    paginate_by_sql("SELECT * FROM designs where designs.status=1 and designs.user_id in (#{members}) order by designs.created_at DESC", :page => page)
  end  
  
  def self.recent_design(top)
    result = Design.find(:all, :conditions => "status = 1",:order=>"created_at DESC", :limit => top,:include => [:pictures,{:user => :pictures},:ratings,:comments,:favoriting_users])
    return result
  end
  
  def self.random_design(top)
    result = Design.find(:all, :conditions => "status = 1",:order=>"rand()", :limit => top,:include => {:user => :pictures})
    return result
  end
  
  def self.total_count(status)
    Design.count(:conditions => ['status = ?', status ])
  end
  
  def self.search_designs(search_text,page) 
    condtion_str = self.construct_condition_string(search_text)    
    paginate_by_sql("select * from designs where status=1 and #{condtion_str} order by name",:include => [:user,:pictures,:ratings,:comments,:favoriting_users],:page => page)
    #    paginate :page => page,
    #             :conditions => ['status = ? and name like ?', 1, "%#{search_text}%"],
    #             :include => [:user,:pictures,:ratings,:comments,:favoriting_users],            
    #             :order => 'name'
    #    result = Design.find(:all, :conditions => ["status = ? and name like ? ",1,"%#{search_text}%"],:include => [:user,:pictures,:ratings,:comments,:favoriting_users])
    #    return result
  end
  
  def self.search_all_designs(search_text) 
    condtion_str = self.construct_condition_string(search_text)    
    find_by_sql("select * from designs where status=1 and #{condtion_str} order by name")
   end  
  
  def self.find_all_with_abuses
    
    find_by_sql("select designs.id as id, designs.permalink as permalink,  designs.name as title, designs.created_at as date, \
    users.login as posted_by, designs.status as status, count(designs.id ) as abuse_count  
    from designs, report_abuses,users where designs.id = report_abuses.entity_id and 
    report_abuses.type = 'DesignReportAbuse' and designs.user_id = users.id group by designs.id  \
    order by report_abuses.updated_at DESC")
    
  end
  
  def self.find_active(top)
    find(:all, :conditions => "status = 1", :order => "created_at DESC",:limit => top,
      :include => [:user,:pictures,:ratings,:comments,:favoriting_users])
  end
  
  def self.search_by_tag(tag,page) 
    paginate :page => page,
             :conditions => ['status = ? and tags like ?', 1, "%#{tag}%"],
             :include => [:user,:pictures,:ratings,:comments,:favoriting_users],            
             :order => 'created_at'
  end
  
  def self.search_by_category(cat_id,status,page)
    paginate :page => page,
             :conditions => ['category_id = ? and status = ?',cat_id,status],
             :include => [:user,:pictures,:ratings,:comments,:favoriting_users],
             :order => 'created_at DESC'
  end
  
  def self.category_designs(cat_id)
   find(:all, :conditions => ["category_id = ? and status = 1",cat_id], :order => "created_at DESC")
  end  
  
  def self.find_by_user_id(user_id,status,page)
    paginate :page => page,
             :conditions => ['user_id = ? and status = ?',user_id,status],
             :include => [:user,:pictures,:ratings,:comments,:favoriting_users],
             :order => 'created_at DESC'
  end  
  
  def self.search_by_status(status,page)
    paginate :page => page,
             :conditions => ['status = ?',status],
             :include => [:user,:pictures,:ratings,:comments,:favoriting_users],
             :order => 'created_at DESC'
  end
  
  #  def to_param
  #    "#{id}-#{permalink}"
  ##   permalink
  #  end      
  
  def create_permalink
    design_name = self.name.downcase.gsub(" ", "-").gsub(".", "-").gsub("/","-")
    self.permalink = "#{self.id}-#{design_name}"
    self.save
  end
  
  def update_permalink
    design_name = self.name.downcase.gsub(" ", "-").gsub(".", "-").gsub("/","-")
    self.permalink = "#{self.id}-#{design_name}"
    self.save
  end  
  
  def self.get_reporting_values(start_date,group)
    find_by_sql("select #{group}(created_at) as splitter, count(*) as count from designs where \
     date(created_at) >= '#{start_date.to_s(:db)}' group by #{group}(created_at)")
  end
  
  def self.all_recent_designs(page)
    paginate :page => page,
             :conditions => ['status = ?',1],
             :include => [:user,:pictures,:ratings,:comments,:favoriting_users],
             :order => 'created_at DESC'    
    #    result = Design.find(:all, :conditions => "status = 1",:order=>"created_at DESC", :limit => top,:include => {:user => :pictures})
  end
  
  def self.search_designs_for_categoy(search_text,category_id,page) 
    condtion_str = self.construct_condition_string(search_text)    
    paginate_by_sql("select * from designs where status=1 and category_id = #{category_id} and #{condtion_str} order by name",:include => [:user,:pictures,:ratings,:comments,:favoriting_users],:page => page)
  end
  
  def self.search_all_designs_for_categoy(search_text,category_id) 
    condtion_str = self.construct_condition_string(search_text)    
    find_by_sql("select * from designs where status=1 and category_id = #{category_id} and #{condtion_str} order by name")
  end  
  
  def self.construct_condition_string(search_text)
    arr = []
    condition_string = "("
    arr =  search_text.split(" ")
    for i in 0..arr.length-1
      if i == 0
        condition_string = condition_string+"(name like '%%"+arr[i].to_s+"%%')"
      else
        condition_string = condition_string+" AND (name like '%%"+arr[i].to_s+"%%')"
      end
    end
    condition_string += ")"
    condition_string
  end  
  
  def self.update_permalinks
    designs = Design.all
    for design in designs
       permalink = design.name.downcase.gsub(" ", "-").gsub(".", "-").gsub("/","-")      
       permalink = "#{design.id}-#{permalink}"       
       design.update_attribute(:permalink,permalink)
    end
    learnings = Learning.all
    for learning in learnings
       permalink = learning.title.downcase.gsub(" ", "-").gsub(".", "-").gsub("/","-")      
       permalink = "#{learning.id}-#{permalink}"              
       learning.update_attribute(:permalink,permalink)
    end   
    events = Event.all
    for event in events
       permalink = event.topic.downcase.gsub(" ", "-").gsub(".", "-").gsub("/","-")      
       permalink = "#{event.id}-#{permalink}"                     
       event.update_attribute(:permalink,permalink)
    end     
    games = Game.all
    for game in games
       permalink = game.title.downcase.gsub(" ", "-").gsub(".", "-").gsub("/","-")      
       permalink = "#{game.id}-#{permalink}"                   
       game.update_attribute(:permalink,permalink)
    end       
    groups = Group.all
    for group in groups
       permalink = group.name.downcase.gsub(" ", "-").gsub(".", "-").gsub("/","-")      
       permalink = "#{group.id}-#{permalink}"                 
       group.update_attribute(:permalink,permalink)
    end           
    news = News.all
    for n in news
       permalink = n.title.downcase.gsub(" ", "-").gsub(".", "-").gsub("/","-")      
       permalink = "#{n.id}-#{permalink}"                     
       n.update_attribute(:permalink,permalink)
    end      
    topics = Topic.all
    for topic in topics
       permalink = topic.title.downcase.gsub(" ", "-").gsub(".", "-").gsub("/","-")   
       permalink = "#{topic.id}-#{permalink}"                 
       topic.update_attribute(:permalink,permalink)
    end          
#    redirect_to "/"            
  end  
  
end
