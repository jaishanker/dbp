class Learning < ActiveRecord::Base
  
  has_many  :assets, :as => :attachable, :dependent => :destroy
  has_many :pictures, :as => :gallerie  
  has_many :comments, :as => :commentable, :dependent => :destroy
  has_many :activity_streams, :as => :actor, :dependent => :destroy  
  has_many :activity_streams, :as => :object, :dependent => :destroy   
  has_many :requests, :as => :requestable, :dependent => :destroy    
  has_many :learning_tags, :class_name => 'Tag', :as => :tagable, :dependent => :destroy       
  
  belongs_to :user
  has_many :favorites, :as => :favorable, :dependent => :destroy  
  
  validates_presence_of :title,:description,:category_id,:user_id #,:embed_code
  validates_uniqueness_of :title,:case_sensitive => true 
  validates_numericality_of :size,:allow_nil => true
  
  
  acts_as_rateable
  
  acts_as_commentable
  
  acts_as_shareable
  
  acts_as_favorite
  
  has_many :ratings_count,:class_name => "Rating",:conditions => "rateable_type = 'Learning'",:foreign_key => "rateable_id"
  
  named_scope :recent_learnings, :conditions => "status = 1",:order => "created_at DESC",:limit => 10,:include => [:assets,:pictures]
  
  #  named_scope :top_rated_learning,:select => "l.*, AVG(r.rating) as avg",:from => "learnings l JOIN ratings r ON l.id = r.rateable_id",
  #    :group => "r.rateable_id ", :order => "avg DESC",:limit=>5
  
  named_scope :top_rated_learning, :conditions => "l.status = 1",:select => "l.*, AVG(r.rating) as avg",:from => "learnings l JOIN ratings r ON l.id = r.rateable_id and r.rateable_type = 'Learning'",
    :group => "l.id", :order => "avg DESC",:limit=>5
  
  named_scope :top_rated_material, :conditions => "l.status = 1",:select => "l.*, AVG(r.rating) as avg",
              :from => "learnings l JOIN ratings r ON l.id = r.rateable_id and r.rateable_type = 'Learning'",
              :group => "l.id", :order => "avg DESC",:limit=>10
  
  
  cattr_reader :per_page
  @@per_page =PER_PAGE  
  
  after_create :create_permalink  
  #  after_update :create_permalink    
  #  before_save :create_permalink    

  def self.top_rated(status,page)
    paginate :page => page,
             :include => [:user,:pictures,:ratings,:comments,:favoriting_users],
             :joins => "left outer join ratings on (learnings.id = ratings.rateable_id and ratings.rateable_type = 'Learning')",             
             :conditions => ["learnings.status = ?",status],
             :group => "learnings.id",
             :order => "AVG(ratings.rating) DESC"

  end

  def self.all_count
    self.count("status = 1")
  end
  
  def self.find_all(top = 1000)
    find(:all,:order => "created_at DESC",:limit => top,:include => [:assets,:favorites,{:user => :learnings}])
  end
  
  def self.views_count
    sum = self.find_by_sql("select sum(view_count) as sum from learnings")
    return sum[0].sum || 0
  end
  
  def self.total_count(status)
    Learning.count(:conditions => ['status = ?', status ])
  end
  
  def update_count
    self.view_count = view_count.nil? ? 1 : view_count + 1
    self.save
    View.add_view(self.class,self.id)
  end
  
  def self.search_learning(search_text,page)
   condtion_str = self.construct_condition_string(search_text)    
    paginate_by_sql("select * from learnings where status=1 and #{condtion_str} order by title",:include => [:assets,:pictures,:ratings,:comments,:favoriting_users],:page => page)    
#    paginate :page => page,
#             :conditions => ['status = ? and title like ?', 1, "%#{search_text}%"],
#             :include => [:assets,:pictures,:ratings,:comments,:favoriting_users],            
#             :order => 'title'    
    #    result = Learning.find(:all, :conditions => ["status = ? and title like ? ",1,"%#{search_text}%"],
    #                           :include => [:assets,:pictures,:ratings,:comments,:favoriting_users])
    #    return result
  end
  
  def self.find_active(top = nil)
    find(:all, :conditions => "status = 1", :order => "created_at DESC",:limit => top,
           :include => [:assets,:user,:pictures,:ratings,:comments,:favoriting_users])
  end

  def self.find_active_by_id(ids)
    find(:all, :conditions => ["status = ? and id IN (#{ids}) ",1 ], :order => "created_at DESC",
           :include => [:assets,:user,:pictures,:ratings,:comments,:favoriting_users])
  end
  
  def self.top_rated_materials(top)
    find(:all, :conditions => "status = 1", :order => "created_at DESC",:limit => top,
           :include => [:ratings,:comments,:favoriting_users])
  end
  
  def self.find_all_with_abuses
    
    find_by_sql("select learnings.id as id,learnings.permalink as permalink, learnings.title as title, learnings.created_at as date, \
    users.login as posted_by, learnings.status as status, count(learnings.id ) as abuse_count  
    from learnings, report_abuses,users where learnings.id = report_abuses.entity_id and 
    report_abuses.type = 'LearningReportAbuse' and learnings.user_id = users.id  \
    group by learnings.id  order by report_abuses.updated_at DESC")
    
  end
  
  def self.active_contributors(top)
    result =  Learning.find_by_sql("select user_id,count(id) as post_count from learnings group by user_id order by post_count desc limit #{top}")
    return result
  end  
  
  def self.search_by_tag(tag,page) 
    paginate :page => page,
             :conditions => ['status = ? and tags like ?', 1, "%#{tag}%"],
             :include => [:user,:pictures,:ratings,:comments,:favoriting_users],            
             :order => 'created_at DESC'
  end
  
  def self.search_by_status(status,page)
    paginate :page => page,
             :conditions => ['status = ?', status],
             :include => [:user,:pictures,:ratings,:comments,:favoriting_users],
             :order => 'created_at DESC'
  end
  
  def self.search_by_category(cat_id,status,page)
    paginate :page => page,
             :conditions => ['category_id = ? and status = ?',cat_id,status],
             :include => [:user,:pictures,:ratings,:comments,:favoriting_users],
             :order => 'created_at DESC'
  end
  
  def self.search_by_format_and_status(format,status,page)
    paginate :page => page, 
             :joins => ['join assets a on learnings.id = a.attachable_id'],
             :conditions => ['a.data_content_type = ? and learnings.status = ?',format,status],             
             :include => [:user,:pictures,:ratings,:comments,:favoriting_users],
             :order => 'created_at DESC'
  end   
  
  def create_permalink
    design_name = self.title.downcase.gsub(" ", "-").gsub(".", "-").gsub("/","-")
    self.permalink = "#{self.id}-#{design_name}"
    self.save
  end   
  
  #  def self.update_permalinks
  #    find(:all).each do |d|
  #      d.permalink = d.id.to_s + '-' + d.title.gsub(' ','-')
  #      d.save!
  #    end
  #  end
  
  
  def self.get_reporting_values(start_date,group)
    find_by_sql("select #{group}(created_at) as splitter, count(*) as count from learnings where \
     date(created_at) >= '#{start_date.to_s(:db)}' group by #{group}(created_at)")
  end

  def self.search_learnings_for_categoy(search_text,category_id,page) 
     condtion_str = self.construct_condition_string(search_text)    
     paginate_by_sql("select * from learnings where status=1 and category_id = #{category_id} and #{condtion_str} order by title",:include => [:user,:pictures,:ratings,:comments,:favoriting_users],:page => page)
  end  
  
  def self.get_learning_images
    
    # sample :  http://designbetterproducts.in/photos/users/286/thumb.jpg
    
    learning = Learning.find(:all)
    learning.each do |l|
      if Picture.find_by_gallerie_type_and_gallerie_id('Learning',l.id).nil?
        begin
        #  file = UrlUpload.new(photo)
        path = "/root/Desktop/dbp/learning_images/"
        puts "Processing : " + l.title
        open(File.join(File.expand_path(path), "#{l.title}.PNG"), "r") do |file1|
          picture = Picture.new 
          picture.photo = file1
          l.pictures << picture  
        end
                rescue 
                  puts "error for " + l.title 
                else
                end
      end
    end
    
  end
  
  def self.construct_condition_string(search_text)
        arr = []
        condition_string = "("
        arr =  search_text.split(" ")
        for i in 0..arr.length-1
                if i == 0
                    condition_string = condition_string+"(title like '%%"+arr[i].to_s+"%%')"
                else
                     condition_string = condition_string+" AND (title like '%%"+arr[i].to_s+"%%')"
                 end
          end
          condition_string += ")"
          condition_string
  end    
  
  
end
