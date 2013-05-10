class Group < ActiveRecord::Base
  include Authentication
  
  has_many :group_memberships, :dependent => :destroy     
  has_many :users, :through => :group_memberships
  has_many :pictures, :as => :gallerie
  belongs_to :owner,:class_name => "User"
  has_many :activity_streams, :as => :actor, :dependent => :destroy  
  has_many :activity_streams, :as => :object, :dependent => :destroy     
  
  validates_presence_of     :name, :on => :create, :message => "Group name can't be blank"
  #  validates_presence_of     :category_id, :message => "Group category can't be blank"
  #validates_presence_of     :group_type
  validates_presence_of     :email, :message => "Email can't be blank" 
#  validates_presence_of     :country, :message => "Country can't be blank" 
#  validates_presence_of     :street_adds, :message => "Street address can't be blank"   
#  validates_presence_of     :city, :message => "City can't be blank"   
  validates_length_of       :name,    :within => 3..25, :on => :create, :message => "Group name should be between 3 to 25 characters long"
  validates_format_of       :name, :with => /^[0-9A-Za-z. ]*\z/, :on => :create, :message => "Group Name can't contain special characters"
  validates_format_of       :email,    :with => Authentication.email_regex, :message => "Email "+Authentication.bad_email_message
  #validates_uniqueness_of   :email
  validates_uniqueness_of   :name, :on => :create, :message => "Group name has already been taken"
  validates_length_of       :website,    :within => 6..40, :allow_blank => true, :allow_nil => true, :message => "Website should be between 6 to 40 characters long"
  validates_length_of       :description,    :within => 3..100, :allow_blank => true, :allow_nil => true, :message => "Description should be between 6 to 50 characters long"
  #  validates_format_of       :website,    :with => /\A#{Authentication.email_name_regex}.#{Authentication.domain_tld_regex}\z/i,:allow_blank => true, :allow_nil => true
  validates_associated      :pictures
  
  acts_as_favorite  
  
  cattr_reader :per_page
  @@per_page =PER_PAGE
  
  after_create :create_permalink
  #  after_update :create_permalink    
  #   before_save :create_permalink      
  #Forum partitipants
  
  def validate_on_create
    sc = SubCategory.find_by_name(self.name)
    
    unless sc.nil?
      self.errors.add('name','Group Name is unavailable')
    end
    
  end

  def self.active_groups(top , page = 1)
    paginate_by_sql ["SELECT groups.*,count(posts.topic_id) as c from groups join sub_categories on sub_categories.name=groups.name join topics on (topics.sub_category_id= sub_categories.id and topics.status= 1) join posts on posts.topic_id=topics.id where (groups.status = 1 or groups.status is null) group by groups.id order by c DESC"],
      :page => page, :per_page => top
  end

  def self.popular_groups(top , page = 1)
    paginate_by_sql ["SELECT groups.* from group_memberships,groups,pictures where groups.id = group_memberships.group_id and (groups.status = 1 or groups.status is null) group by group_id order by count(group_memberships.user_id) DESC"],
      :page => page, :per_page => top
    #    result = Group.find_by_sql(["SELECT groups.* from group_memberships,groups,pictures where groups.id = group_memberships.group_id group by group_id order by count(user_id) DESC limit ?", top])
    #    result = Group.find(:all,:order=>"created_at DESC", :limit => top,:include=>[:pictures])
    #    return result
  end
  
  def self.find_all(top = 1000)   
    find(:all,:order => "created_at DESC",:limit => top,:include => [:pictures,:group_memberships])
  end
  
  def self.find_active(top)
    find(:all, :condition => "status = 1", :order => "created_at DESC",:limit => top,:include => [:pictures,:group_memberships])
  end
  
  def self.search(search_text,page) 
   condtion_str = Design.construct_condition_string(search_text)        
   paginate_by_sql("select * from groups where (status is null or status = 1) and #{condtion_str} order by name",:include => [:users,:pictures],:page => page)        
#    paginate :page => page,
#             :conditions => ['name like ?', "%#{search_text}%"],
#             :include => [:users,:pictures],            
#             :order => 'name'
    #    result = Design.find(:all, :conditions => ["status = ? and name like ? ",1,"%#{search_text}%"],:include => [:user,:pictures,:ratings,:comments,:favoriting_users])
    #    return result
  end
  
  def self.search_by_group_type(cat_id,page)
    paginate :page => page,
             :conditions => ['group_type = ? and (status is null or status = 1)', cat_id],
             :include => [:pictures,:group_memberships,:users],
             :order => "created_at DESC"
  end
  
  def self.search_active(page)
    paginate :page => page,
             :include => [:pictures,:group_memberships,:users],
             :conditions => ['status is null or status = 1'],             
             :order => "created_at DESC"
  end  
  
  def self.find_all_with_abuses
    find_by_sql("select groups.id as id,groups.permalink as permalink,groups.name as name, groups.created_at as date, \
    users.login as posted_by, groups.status as status, count(groups.id ) as abuse_count  
    from groups, report_abuses,users where groups.id = report_abuses.entity_id and 
    report_abuses.type = 'GroupReportAbuse' and groups.owner_id = users.id \
    group by groups.id  order by report_abuses.updated_at DESC")
    
  end
  
  
  def create_permalink
    design_name = self.name.downcase.gsub(" ", "-").gsub(".", "-").gsub("/","-")
    self.permalink = "#{self.id}-#{design_name}"
    self.save
  end   
  
  def self.views_count
    sum = self.find_by_sql("select sum(view_count) as sum from groups")
    return sum[0].sum || 0
  end
  
  def update_count
    self.view_count = view_count.nil? ? 1 : view_count + 1
    self.save
    View.add_view(self.class,self.id)
    
  end
  
  
  def find_topic
    SubCategory.find_by_name(self.name)  
  end
  

  def self.search_groups_for_categoy(search_text,category_id,page) 
   condtion_str = Design.construct_condition_string(search_text)        
   paginate_by_sql("select * from groups where (status is null or status = 1) and group_type = '#{category_id}' and #{condtion_str} order by name",:include => [:users,:pictures],:page => page)        
  end  
  
  def self.create_group_discussion
    
    category = DiscussionCategory.find_by_name("Groups")
    if category.nil?
      category = DiscussionCategory.create(:name => "Groups",:status => 1)
    end
    
    Group.all.each do |g|
      
      SubCategory.create(:name => g.name,:description => g.description,:user_id => g.owner_id,:discussion_category_id => category.id,:status => 1)
      
    end
    
  end
  
  def after_create
    category = DiscussionCategory.find_by_name("Groups")
    if category.nil?
      category = DiscussionCategory.create(:name => "Groups",:status => 1)
    end
    
    sc = SubCategory.new 
    sc.name = self.name
    sc.description = self.description
    sc.user_id = self.owner_id
    sc.discussion_category_id = category.id
    sc.status = 1
    sc.save!
    
  end
end
