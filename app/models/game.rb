class Game < ActiveRecord::Base
  
  
  has_many :pictures, :as => :gallerie  
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :activity_streams, :as => :actor, :dependent => :destroy  
  has_many :activity_streams, :as => :object, :dependent => :destroy   
  has_many :requests, :as => :requestable, :dependent => :destroy    
  has_many :game_tags, :class_name => 'Tag', :as => :tagable, :dependent => :destroy       
  
  belongs_to :user

  has_many :favorites, :as => :favorable, :dependent => :destroy  
  
  validates_presence_of :title,:description,:user_id,:embed_code
  validates_uniqueness_of :title,:case_sensitive => true 
  
  acts_as_rateable
  
  acts_as_commentable
  
  acts_as_shareable
  
  acts_as_favorite
  
  named_scope :recent_games, :conditions => "status = 1",:order => "created_at DESC",:limit => 5,:include=>:pictures
  named_scope :top_rated_games,:conditions => "d.status = 1",:select => "d.*, AVG(r.rating) as avg",:from => "games d JOIN ratings r ON d.id = r.rateable_id and r.rateable_type = 'Game'",
    :group => "d.id", :order => "avg DESC",:limit=>5
  cattr_reader :per_page
  @@per_page =PER_PAGE
  
  def self.all_count
    self.count("status = 1")
  end
  
  after_create :create_permalink
  #  after_update :create_permalink    
  #before_save :create_permalink    
  
  def self.find_all(top = 1000)
    find(:all,:order => "created_at DESC",:limit => top,:include => [:comments,:favorites])
  end
  
  def self.total_count(status)
    Game.count(:conditions => ['status = ?', status ])
  end
  
  def self.views_count
    sum = self.find_by_sql("select sum(view_count) as sum from games")
    return sum[0].sum || 0
  end
  
  
  def update_count
    self.view_count = view_count.nil? ? 1 : view_count + 1
    self.save
    View.add_view(self.class,self.id)
  end
  
  def self.search_games(search_text, page)
   condtion_str = Learning.construct_condition_string(search_text)        
   paginate_by_sql("select * from games where status = 1 and #{condtion_str} order by title",:include => [:pictures,:ratings,:comments,:favoriting_users],:page => page)    
#    paginate :page => page,
#             :conditions => ['status = ? and title like ?', 1, "%#{search_text}%"],
#             :include => [:pictures,:ratings,:comments,:favoriting_users],            
#             :order => 'title'    
    #    result = Game.find(:all, :conditions => ["status = ? and title like ? ",1,"%#{search_text}%"] ,:include=>[:pictures,:ratings,:comments,:favoriting_users])
    #    return result
  end
  
  def self.find_active(top)
    find(:all, :conditions => "status = 1", :order => "created_at DESC",:limit => top,
        :include=>[:pictures,:ratings,:comments,:favoriting_users])
  end
  
  def self.search_by_tag(tag,page) 
    paginate :page => page,
             :conditions => ['status = ? and tags like ?', 1, "%#{tag}%"],
             :include => [:user,:pictures,:ratings,:comments,:favoriting_users],            
             :order => 'created_at'
  end      
  
  def create_permalink
    design_name = self.title.downcase.gsub(" ", "-").gsub(".", "-").gsub("/","-")
    self.permalink = "#{self.id}-#{design_name}"
    self.save
  end   

  def self.paginate_top_rated_games(status,page)
    paginate :page => page,
             :include => [:ratings,:comments,:favoriting_users],
             :joins => "left outer join ratings on (games.id = ratings.rateable_id and ratings.rateable_type = 'Game')",             
             :conditions => ["games.status = ?",status],
             :group => "games.id",
             :order => "AVG(ratings.rating) DESC"
  end  
end
