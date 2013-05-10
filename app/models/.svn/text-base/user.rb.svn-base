require 'digest/sha1'

class User < ActiveRecord::Base  
  has_many :sent_requests, :class_name => 'Request', :foreign_key => 'sender_id', :dependent => :destroy 
  has_many :received_requests, :class_name => 'Request', :foreign_key => 'recipient_id', :dependent => :destroy   
  has_many :active_received_requests, :class_name => 'Request', :foreign_key => 'recipient_id',:conditions => "active = 1 or active is null",:order => "created_at DESC"  
  #  belongs_to :invitation
  
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken  
# include Clearance::App::Models::User
  
  
  has_one :profile
  has_many :user_qualifications, :dependent => :destroy
  has_many :user_professions, :dependent => :destroy  
  has_many :user_certificates, :dependent => :destroy   
  has_one :privacy_setting
  
  has_many :designs,:conditions => "status = 1",:order => "created_at DESC"
  has_many :shouts_got,:conditions => "status = 1",:class_name=>"Shout",:foreign_key=>:to_user_id,:order => "created_at DESC"
  has_many :learnings
  has_many :comments
  has_many :pictures, :as => :gallerie    
  has_many :learning_requests
  
  has_many :group_memberships, :dependent => :destroy  
  has_many :groups, :through => :group_memberships, :dependent => :destroy  
  has_many :active_groups, :through => :group_memberships, :dependent => :destroy  
  has_many :posts, :dependent => :destroy  
  has_many :report_abuses,:class_name => "ReportAbuse"
  has_many :activity_streams, :as => :actor, :dependent => :destroy  
  has_many :activity_streams, :as => :object, :dependent => :destroy     
  has_many :activities, :dependent => :destroy  
  has_many :redemptions, :dependent => :destroy    
  has_many :redeem_user_infos, :dependent => :destroy      
  has_many :participants,:class_name => "ContestParticipant",:foreign_key => "user_id", :dependent => :destroy  
  has_many :events, :dependent => :destroy
  
  acts_as_follower
  acts_as_followable  
  
  acts_as_favorite_user  
  
  has_captcha
  
  
  validates_presence_of     :login, :message => "Username can't be blank"
  validates_length_of       :login,    :within => 3..40, :message => "Username should be between 3 to 40 characters long"
  validates_uniqueness_of   :login, :message => "Username has already been taken"
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message,
                                             :message =>"Please choose proper username"
  validates_format_of       :first_name,     :with => /^[A-Za-z ]*\z/, :allow_nil => true,
                                             :message =>"First name is not in proper format"
  validates_length_of       :first_name,     :maximum => 100,  :message =>"First name is too long"
  
  validates_format_of       :last_name,     :with => /^[A-Za-z ]*\z/, :allow_nil => true,
                                             :message =>"Last name is not in proper format"
  validates_length_of       :last_name,     :maximum => 100,  :message =>"First name is too long"  
  
  validates_presence_of     :first_name, :message => "First name  can't be blank"
  validates_presence_of     :last_name, :message => "Last name can't be blank"
  
  validates_presence_of     :email, :message => "Email can't be blank"
  validates_length_of       :email,    :within => 6..100, :message => "Email should be between 6 to 100 characters long"  #r@a.wk,
  validates_uniqueness_of   :email, :message => "Email has already been taken"
  validates_format_of       :email,    :with => Authentication.email_regex,
                                             :message =>"Please specify valid email address"
  validates_presence_of    :country, :message => 'Please select a country'
  validates_date :birth_date, :message => "Please select valid date", :on => :create
  validates_date :birth_date,:before => Proc.new { Date.today },:message => "Date of Birth should be less than today", :on => :create
  validates_format_of :contact_no,
    :message => "Contact no must be a valid telephone number",
    :with => /^[\(\)0-9\- \+]{7,14} *[extension]{0,9} *[0-9]{0,5}$/i
  validates_presence_of     :password, :message => "Password can't be blank" ,                :if => :password_required?
  validates_presence_of     :password_confirmation, :message => "Password confirmation can't be blank",      :if => :password_required?
  validates_length_of       :password, :within => 6..30, :message => "Password should be between 6 to 30 characters long", :if => :password_required?
  validates_confirmation_of :password, :message => "Password confirmation doesn't match password",                   :if => :password_required? 
  validates_acceptance_of :terms_of_service , :message => "Please accept the terms of service"
  
#  validates_length_of       :std_code,     :maximum => 6,  :message =>"Zip code is too long"
  
  # validates_associated :pictures
  
  validates_associated :user_qualifications
  validates_associated :user_professions
  
  validate :email_for_consecutive_dots
  validate :std_code_length
  
  
#  validates_presence_of :twitter_id
#  validates_uniqueness_of :twitter_id  
  #  
  after_update :save_user_qualifications
  after_update :save_user_professions
  after_update :save_user_certificates
  
  
  before_create :make_activation_code 
#  after_create :register_user_to_fb
  
  
  # Virtual attribute for the unencrypted password
  #  cattr_accessor :logged_in_user  
  cattr_reader :per_page
  @@per_page = USERS_PER_PAGE
  
  attr_accessor :password
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessor :std_code,:phone_no
  attr_accessible :login, :email, :first_name,  :last_name, :gender, :password, :password_confirmation, :profession, :country,  :contact_no,  :birth_date, :display_name_type, :status_message, :preferred_page, :pin_code, :remember_token, :remember_token_expires_at, :activation_code, :activated_at, :forgot_token, :last_login_at, :login_count, :viewer_count, :status, :state, :city, :pincode, :terms_of_service, :captcha_solution, :captcha_secret, :std_code,:phone_no
  
  named_scope :top_rated_user,:select => "users.*, AVG(r.rating) as avrg, COUNT(d.id) as dcount",          
              :from => "users join designs d on (users.id = d.user_id and d.status=1) JOIN ratings r ON d.id = r.rateable_id and r.rateable_type = 'Design' ",
               :conditions => "users.activation_code is null and users.status = '1'",
              :group => "users.id", :having => "dcount >= 5",  :order => "avrg DESC",:include =>[:pictures,:designs],:limit=>6
            
#  named_scope :top_contest_participants,:select => "users.*, count(c.contest_id) as cnt",          
#              :from => "users join contest_participants c on (users.id = c.user_id and c.status=1) ",
#               :conditions => "users.activation_code is null and users.status = '1'",
#              :group => "users.id",  :order => "cnt DESC",:include =>[:pictures],:limit=>6  
            
  
  def self.top_rated_designers(page)
    
    #    paginate_by_sql("select users.*,AVG(ratings.rating) as avg from users,ratings,designs  where users.activation_code is null and ratings.rateable_type = 'Design' and users.id = designs.user_id  group by designs.user_id order by avg DESC" , :page => page)
    paginate_by_sql("select users.*, AVG(r.rating) as avrg, COUNT(d.id) as dcount from users join designs d on (users.id = d.user_id and d.status=1) JOIN ratings r ON (d.id = r.rateable_id and r.rateable_type = 'Design') where users.activation_code is null and users.status = '1' group by users.id having dcount >= 5 order by avrg DESC" , :page => page)    
    
  end
  
  
  def self.find_all
    find(:all,:select => "id,status,points",:conditions => "activated_at is not null and status = '1'" )
  end
  
  #Top rated designers
  def self.top_rated(top)
    
    result = User.find(:all,:conditions=>"",:order=>"created_at DESC", :limit => top,:include => [:pictures,:designs])
    #    result = User.find_by_sql(["select * from users where activation_code is null order by created_at DESC limit ?", top])
    return result
  end
  
  #Top Recent activity.
  def self.recent_activity(top)
    
    result = User.find(:all,:conditions=>" activation_code is null and status = '1'",:order=>"created_at DESC", :limit => top)
    #    result = User.find_by_sql(["select * from users where activation_code is null order by created_at DESC limit ?", top])
    return result
  end
  
  #Top belts user.
  def self.top_belts(top)
    result = User.find(:all, :select => "users.*,count(*) as c",
                                    :joins => "inner join activity_streams on users.id = activity_streams.actor_id",       
                                    :conditions=>" activation_code is null and activity_streams.status = 0 and users.status = '1'",
                                    :group => "users.id",
                                    :order=>"c DESC", :limit => top,:include => :pictures)
    #    result = User.find(:all,:conditions=>" activation_code is null",:order=>"created_at DESC", :limit => top,:include => :pictures)
    #    result = User.find_by_sql(["select * from users where activation_code is null order by created_at DESC limit ?", top])
    return result
  end
  
  #Forum partitipants
  def self.forum_participants(top)
    
    result = User.find(:all,:conditions=>" activation_code is null  and status = '1'",:order=>"created_at DESC", :limit => top,:include => [:pictures])
    #    result = User.find_by_sql(["select * from users where activation_code is null order by created_at DESC limit ?", top])
    return result
  end
  
  #Active Contributor
  def self.active_contributor(top)
    
    result = User.find(:all,:conditions=>" activation_code is null and status = '1'",:order=>"created_at DESC", :limit => top,:include=>:pictures)
    #    result = User.find_by_sql(["select * from users where activation_code is null order by created_at DESC limit ?", top])
    return result
  end
  
  # Activates the user in the database.
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(false)
  end
  
  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
  
  def active?
    # the existence of an activation code means they have not activated yet
    activation_code.nil?
  end
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find :first, :conditions => ['(login = ? or email = ?)', login,login] # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end
  
  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  # Added on 5/03/10 by anil
  def admin?
    #    if logged_in?
    #		(current_user.role == 'admin')
    #    end    
    return true
  end  
  
  def new_user_qualification_attributes=(user_qualification_attributes)
    user_qualification_attributes.each do |attributes|
      user_qualifications.build(attributes)
    end
  end
  
  def existing_user_qualification_attributes=(user_qualification_attributes)
    user_qualifications.reject(&:new_record?).each do |user_qualification|
      attributes = user_qualification_attributes[user_qualification.id.to_s]
      if attributes
        user_qualification.attributes = attributes
      else
        user_qualifications.delete(user_qualification)
      end
    end
  end
  
  def save_user_qualifications
    user_qualifications.each do |user_qualification|
      user_qualification.save(false)
    end
  end
  
  def new_user_profession_attributes=(user_profession_attributes)
    user_profession_attributes.each do |attributes|
      user_professions.build(attributes)
    end
  end
  
  def existing_user_profession_attributes=(user_profession_attributes)
    user_professions.reject(&:new_record?).each do |user_profession|
      attributes = user_profession_attributes[user_profession.id.to_s]
      if attributes
        user_profession.attributes = attributes
      else
        user_professions.delete(user_profession)
      end
    end
  end
  
  def save_user_professions
    user_professions.each do |user_profession|
      user_profession.save(false)
    end
  end
  
  def new_user_certificate_attributes=(user_certificate_attributes)
    user_certificate_attributes.each do |attributes|
      user_certificates.build(attributes)
    end
  end
  
  def existing_user_certificate_attributes=(user_certificate_attributes)
    user_certificates.reject(&:new_record?).each do |user_certificate|
      attributes = user_certificate_attributes[user_certificate.id.to_s]
      if attributes
        user_certificate.attributes = attributes
      else
        user_certificates.delete(user_certificate)
      end
    end
  end
  
  def save_user_certificates
    user_certificates.each do |user_certificate|
      user_certificate.save(false)
    end
  end
  
  def self.search_members(search_text,page)
    condtion_str = self.construct_condition_string(search_text)    
    members = paginate_by_sql("select users.* from users where users.activation_code is null and users.status = '1' and #{condtion_str} order by users.login",:include => [:pictures],:page => page)    
    members    
    #    paginate :page => page,
    #      :conditions => [' activation_code is null and (first_name like ? or last_name like ? or login like ?)', "%#{search_text}%", "%#{search_text}%", "%#{search_text}%"],
    #      :order => 'login'  
  end
  
  def self.active_members(page)
    paginate :page => page,
      :select => "users.*,count(*) as c",
      :joins => "inner join activity_streams on users.id = activity_streams.actor_id",
      :conditions => ["users.activation_code is null and activity_streams.status = 0 and users.status = '1'"],
      :include => [:pictures],
      :group => "users.id",
      :order => 'c DESC'  
  end

  def self.find_weekly_report(start_date,end_date)
      User.find_by_sql("select COUNT(*) as c from users where date(created_at) BETWEEN '#{start_date.to_date}' and '#{end_date.to_date}'")
  end
  
  def self.search_active_members(search_text,page)
    condtion_str = self.construct_condition_string(search_text)    
    members = paginate_by_sql("select users.*,count(*) as c from users inner join activity_streams on users.id = activity_streams.actor_id where users.activation_code is null and users.status = '1' and activity_streams.status = 0 and #{condtion_str} group by users.id order by users.login",:include => [:pictures],:page => page)    
    members
    #    paginate :page => page,
    #      :conditions => [' activation_code is null and ?',condtion_str],
    #       :include => [:pictures],
    #      :order => 'login'  
  end
  
  def self.top_designers(page)
    paginate :page => page,
      :conditions => [' activation_code is null'],
      :include => [:pictures],
      :order => 'created_at DESC'  
  end  
  
  def self.search_top_desingers(search_text,page)
    condtion_str = self.construct_condition_string(search_text)
    members  = paginate_by_sql("select users.*, AVG(r.rating) as avg, COUNT(d.id) as dcount from users join designs d on (users.id = d.user_id  and d.status=1) JOIN ratings r ON d.id = r.rateable_id and r.rateable_type = 'Design' where users.activation_code is null and users.status = '1' and #{condtion_str} group by users.id having dcount >= 5 order by users.login",:include => [:pictures],:page => page)
    #  
    #    members = paginate :page => page,
    #      :conditions =>['activation_code is null and ?',condtion_str],
    #      :order => 'login'  
    members
  end  
  
  def self.total_sharing_count(user_id)
    count_by_sql("select count(*) from shares where shared_to_type = 'User' and shared_to_id = #{user_id}")
  end    
  
  
  def self.find_all_users(page,alpha,per_page)
    
    conditions= ""
    unless alpha == "All"
      case alpha.length 
        when  1
        conditions = "login like '#{alpha}%'"
        when 0
      else
        conditions = "login like '%#{alpha}%'"
      end
    end
    paginate(:page => page,:conditions => conditions,:per_page => per_page,:order => "created_at DESC",:include => [:designs,:learning_requests,:followings,:groups,:posts,:report_abuses])
    
  end
  
  
  def self.get_user_data
    
    # sample :  http://designbetterproducts.in/photos/users/286/thumb.jpg
    
    user = User.find(:all,:conditions => "id > 1474")
    user.each do |u|
      
      ['jpg','gif','jpeg','png'].each do |fmt|
        
        photo = "http://designbetterproducts.in/photos/users/#{u.id.to_s}/thumb.#{fmt}"
        
        puts photo
        
        begin
          file = UrlUpload.new(photo)
          path = "./public/images/temp/"
          open(File.join(File.expand_path(path), "#{file.original_filename}"), "wb") do |file1|
            file1.write(file.read)
          end
          open(File.join(File.expand_path(path), "#{file.original_filename}"), "r") do |file1|
            picture = Picture.new 
            picture.photo = file1
            u.pictures << picture  
          end
        rescue
        else
        end
      end
      puts "---------------------------"
    end 
  end
  
  def add_points(points,activity,object, old_points = 0)
    if self.points.nil?
      self.points = 0
    end
    self.points += points
    self.save  
    if points >= old_points
      points -= old_points
      Activity.create(:user_id => self.id, :activity => activity, :points_earned => points, :points_spend => 0, :object_id => object.id, :object_type => object.class.to_s, :points_substracted => 0  )      
    else
      points = old_points - points
      if activity == "updated_profile"
        Activity.create(:user_id => self.id, :activity => activity, :points_earned => 0, :points_spend => points, :object_id => object.id, :object_type => object.class.to_s, :points_substracted => 0  )            
      else
        Activity.create(:user_id => self.id, :activity => activity, :points_earned => 0, :points_spend => 0, :object_id => object.id, :object_type => object.class.to_s, :points_substracted => points  )                    
      end
    end
  end  
  
  def substract_points(points,activity,object)
    Activity.create(:user_id => self.id, :activity => activity, :points_earned => 0, :points_spend => points, :object_id => object.id, :object_type => object.class.to_s, :points_substracted => 0  )
  end   
  
  def actual_substract_points(points,activity,object)    
    unless activity== "substracted_old_points"
      Activity.create(:user_id => self.id, :activity => activity, :points_earned => 0, :points_spend => 0, :object_id => object.id, :object_type => object.class.to_s, :points_substracted => points  )      
    end
    if self.points.nil?
      self.points = 0
    end
    self.points -= points
    if self.points <= 0
      self.points = 0
    end
    self.save
  end   
  
  def notify_favorite_received(favorited_by,design)  
    UserMailer.deliver_favorite_received_notification(self,favorited_by,design)
  end

  def notify_rating_received(rated_by,design)  
    UserMailer.deliver_rating_received_notification(self,rated_by,design)
  end  
  
  def notify_follower_addtion(follower)  
    UserMailer.deliver_follower_addition_notification(self,follower)
  end    
  
  def self.search_followers(user_id,search_text,offset)
    condtion_str = self.construct_condition_string(search_text)        
    find_by_sql("select * from users,  follows f where users.id = f.follower_id and users.activation_code is null and users.status = '1' and #{condtion_str} and f.blocked=0  and f.followable_id = #{user_id} limit #{offset},#{PER_PAGE}")
  end
  
  def self.search_followees(user_id,search_text,offset)
    condtion_str = self.construct_condition_string(search_text)    
    find_by_sql("select * from users,  follows f where users.id = f.followable_id and users.activation_code is null and users.status = '1' and #{condtion_str} and f.blocked=0  and f.follower_id = #{user_id} limit #{offset},#{PER_PAGE}")
  end  
  #  def self.get_verb
  ##    if User.logged_in_user.gender == "Male"
  #      verb = "has updated his profile"
  ##    else
  ##      verb = "has updated his profile"      
  ##    end
  ##    verb
  #  end      
  
  def self.find_auto_complete_results(query)
    find(:all,:select => "concat(first_name, ' ', last_name, ' ' , '(', login,')',' < ',email,' >') as result",:conditions => "email like '%#{query}%' or login like '%#{query}%' or first_name like '%#{query}%' or last_name like '%#{query}%'")
  end
  
  def self.members(group_id,page = 1)
    paginate_by_sql("SELECT users.* FROM `users` INNER JOIN `group_memberships` ON users.id = `group_memberships`.user_id WHERE (`group_memberships`.group_id = #{group_id}  and users.activation_code is null and users.status = '1')",:include => [:pictures], :page => page)
  end
  
  def self.search_group_members(search_text,group_id,page)
    condtion_str = self.construct_condition_string(search_text)
    paginate_by_sql("SELECT users.* FROM `users`  INNER JOIN `group_memberships` ON users.id = `group_memberships`.user_id WHERE `group_memberships`.group_id = #{group_id} and users.activation_code is null and users.status = '1' and #{condtion_str}",:include => [:pictures], :page => page)    
  end  
  
  def self.active_forum_participants(page)  
    paginate_by_sql "select posts.user_id,count(posts.id) as post_count from posts INNER JOIN profiles ON posts.user_id = profiles.user_id where posts.status = 1 and profiles.pic_present = 1 group by posts.user_id order by post_count desc", :page => page
  end  
  
  
  def self.search_active_forum_participants(search_text , page)
    condtion_str = self.construct_condition_string(search_text)                 
    paginate_by_sql("select p.user_id,count(users.id) as post_count from users inner join posts p on users.id = p.user_id INNER JOIN profiles ON p.user_id = profiles.user_id where #{condtion_str} and users.activation_code is null and users.status = '1' group by p.user_id order by post_count desc" ,:include => [:pictures], :page => page)
  end   
  
  def self.paginate_active_contributors(page)
    paginate_by_sql "select user_id,count(id) as post_count from learnings group by user_id order by post_count desc" , :page => page
  end  
  
  def self.search_active_contributors(search_text , page)
    condtion_str = self.construct_condition_string(search_text)          
    paginate_by_sql("select l.user_id,count(l.id) as learning_count from users inner join learnings l on users.id = l.user_id where #{condtion_str} and users.activation_code is null and users.status = '1' group by l.user_id order by learning_count desc",:include => [:pictures] , :page => page)
  end      
  
  def self.construct_condition_string(search_text)
    arr = []
    condition_string = "("
    arr =  search_text.split(" ")
    for i in 0..arr.length-1
      if i == 0
        condition_string = condition_string+"(users.first_name like '%%"+arr[i].to_s+"%%' OR users.last_name like '%%"+arr[i].to_s+"%%')"
      else
        condition_string = condition_string+" AND (users.first_name like '%%"+arr[i].to_s+"%%' OR users.last_name like '%%"+arr[i].to_s+"%%')"
      end
    end
    condition_string += ")"
    condition_string
  end
  
  def get_redemptions(offset)
    
  end
  
  def redeemed_points
    (self.redemptions.find(:all,:select => "sum(points) as sum",:conditions => "status = 1")[0].sum || 0).to_i
  end
  
  def self.all_redeem_points
    find_by_sql("select sum(points) as sum,user_id from redemptions where status = 1 group by user_id")
  end
  
  def set_profile_complete
    unless self.profile.nil?
#        profile_complete = ((self.profile.percent_complete) / 10.0).round * 10
        self.update_attribute(:profile_complete, self.profile.percent_complete.to_i)
     end
  end  

  def self.weekly_report

      @week_end = Date.today
      @week_start = Date.today - 1.week

      @users = User.find_weekly_report(@week_start.strftime('%Y-%m-%d'),@week_end.strftime('%Y-%m-%d'))
      @users_count = @users[0].c

      @total_users = User.find_all
      @total_active_users_count = @total_users.count

      @total_user_count = User.count

      @posts = Post.find_weekly_report(@week_start.strftime('%Y-%m-%d'),@week_end.strftime('%Y-%m-%d'))
      @posts_count = @posts[0].c

      @new_designs = Design.find_weekly_report(@week_start.strftime('%Y-%m-%d'),@week_end.strftime('%Y-%m-%d'))
      @new_designs_count = @new_designs[0].c

      @new_comment = Comment.find_weekly_report(@week_start.strftime('%Y-%m-%d'),@week_end.strftime('%Y-%m-%d'))
      @new_comment_count = @new_comment[0].c

      UserMailer.deliver_weekly_report(@week_start,@week_end,@users_count,@total_active_users_count,@total_user_count,@posts_count,@new_designs_count,@new_comment_count)

  end
  
  def self.contest_participants(page)    
    #    paginate_by_sql("select users.*,AVG(ratings.rating) as avg from users,ratings,designs  where users.activation_code is null and ratings.rateable_type = 'Design' and users.id = designs.user_id  group by designs.user_id order by avg DESC" , :page => page)
    paginate_by_sql("select users.*, count(c.contest_id) as cnt from users join contest_participants c on (users.id = c.user_id and c.status=1) where users.activation_code is null and users.status = '1' group by users.id order by cnt DESC" , :page => page)    
    
  end  
  
  def self.top_contest_participants(limit)    
    #    paginate_by_sql("select users.*,AVG(ratings.rating) as avg from users,ratings,designs  where users.activation_code is null and ratings.rateable_type = 'Design' and users.id = designs.user_id  group by designs.user_id order by avg DESC" , :page => page)
    find_by_sql("select users.*, count(c.contest_id) as cnt from users join contest_participants c on (users.id = c.user_id and c.status=1) where users.activation_code is null and users.status = '1' group by users.id order by cnt DESC limit #{limit}")    
    
  end  
  
    #find the user in the database, first by the facebook user id and if that fails through the email hash
    def self.find_by_fb_user(fb_user)
      User.find_by_fb_user_id(fb_user.uid) || User.find_by_email_hash(fb_user.email_hashes)
    end

    #Take the data returned from facebook and create a new user from it.
    #We don't get the email from Facebook and because a facebooker can only login through Connect we just generate a unique login name for them.
    #If you were using username to display to people you might want to get them to select one after registering through Facebook Connect
    def self.create_from_fb_connect(fb_user)
       gender = fb_user.sex.capitalize if fb_user.sex 
      dob = fb_user.birthday_date.to_datetime.to_s(:db) if !fb_user.birthday_date.nil?      
      country = fb_user.current_location.country unless fb_user.current_location.nil?      
      if country.nil?
        country = 'India'
      end

      if !fb_user.first_name.nil? && !fb_user.last_name.nil?
          login = fb_user.first_name.to_s+"."+fb_user.last_name.to_s
          login_taken = User.find_by_login(login)
          if login_taken
            login = fb_user.first_name.to_s+"_"+fb_user.last_name.to_s
            login_taken = User.find_by_login(login)
            if login_taken
                login = fb_user.first_name.to_s+fb_user.last_name.to_s
                login_taken = User.find_by_login(login)
                if login_taken
                  login = "fb_"+fb_user.first_name.to_s+"_"+fb_user.last_name.to_s
                end                                  
            end           
          end       
      elsif !fb_user.first_name.nil?
        login = fb_user.first_name.to_s
          login_taken = User.find_by_login(login)
          if login_taken
            login = "fb_"+fb_user.first_name.to_s
           login_taken = User.find_by_login(login)
            if login_taken
              login = fb_user.first_name.to_s+"_fb"
            end                   
          end             
      else
        login = fb_user.last_name.to_s
         login_taken = User.find_by_login(login)
          if login_taken
            login = "fb_"+fb_user.last_name.to_s
            login_taken = User.find_by_login(login)
            if login_taken
              login = fb_user.last_name.to_s+"_fb"
            end               
          end     
      end    
    
      new_facebooker = User.new(:first_name => fb_user.first_name,:last_name => fb_user.last_name, :login => login, :password => "", :email =>login, :gender => gender, :birth_date => dob, :country => country, :status => 1)
      new_facebooker.fb_user_id = fb_user.uid.to_i
      new_facebooker.points = 300
      #We need to save without validations
      new_facebooker.save(false)
      new_facebooker.register_user_to_fb
      
   # getting facebook pic
    begin
      file = UrlUpload.new(fb_user.pic_square)
      path = "./public/images/profile_photo/"
      open(File.join(File.expand_path(path), "#{file.original_filename}"), "wb") do |file1|
        file1.write(file.read)
      end
      open(File.join(File.expand_path(path), "#{file.original_filename}"), "r") do |file1|
        picture = Picture.new 
        picture.photo = file1
        new_facebooker.pictures << picture  
        new_facebooker.profile.pic_present = 1
        new_facebooker.profile.save(false)
      end
    rescue
    else
    end      
    new_facebooker.set_profile_complete
    new_facebooker.activation_code = nil
    new_facebooker.activated_at = Time.now
    new_facebooker.save(false)
    end

    #We are going to connect this user object with a facebook id. But only ever one account.
    def link_fb_connect(fb_user_id)
      unless fb_user_id.nil?
        #check for existing account
        existing_fb_user = User.find_by_fb_user_id(fb_user_id)
        #unlink the existing account
        unless existing_fb_user.nil?
          existing_fb_user.fb_user_id = nil
          existing_fb_user.save(false)
        end
        #link the new one
        self.fb_user_id = fb_user_id
        save(false)
      end
    end

    #The Facebook registers user method is going to send the users email hash and our account id to Facebook
    #We need this so Facebook can find friends on our local application even if they have not connect through connect
    #We hen use the email hash in the database to later identify a user from Facebook with a local user
    def register_user_to_fb
      users = {:email => email, :account_id => id}
      Facebooker::User.register([users])
      self.email_hash = Facebooker::User.hash_email(email)
      save(false)
    end
    def facebook_user?
      return !fb_user_id.nil? && fb_user_id > 0
    end
    
    def normal_user?
      return fb_user_id.nil?
    end    

    def details_filled?
        return (self.email != self.login) && self.first_name && self.last_name && self.gender && self.profession && self.country && self.contact_no && self.birth_date
      end      

#  def twitter
#    consumer_token = YAML::load_file("#{RAILS_ROOT}/config/twitter_oauth.yml").symbolize_keys
#    #oauth = Twitter::OAuth.new(consumer_token[:consumer_key], consumer_token[:consumer_secret])
#    #oauth.authorize_from_access(token, secret)
#    consumer = OAuth::Consumer.new(consumer_token[:consumer_token], consumer_token[:consumer_secret])
#    access = OAuth::AccessToken.new(consumer, access_token, access_secret)
#    Twitter::Base.new(OAuth::AccessToken.new(access))
#  end  
#    
#  
#def authorized?
#    !atoken.blank? && !asecret.blank?
#  end
#  
#  def oauth
#    @oauth ||= Twitter::OAuth.new(ConsumerConfig['token'], ConsumerConfig['secret'])
#  end
#  
#  def client
#    @client ||= begin
#      oauth.authorize_from_access(atoken, asecret)
#      Twitter::Base.new(oauth)
#    end
#  end  

  protected
  
  def make_activation_code
    self.activation_code = self.class.make_token
  end
  
  def password_required?
    (crypted_password.blank? || !password.blank?) 
  end
  
 def email_for_consecutive_dots
    errors.add(:email, "Email should not contain cosecutive dots") if  email.include?("..") 
 end   
 
 def std_code_length
   if contact_no
     if contact_no.include?("-")
       a= contact_no.split("-")
       errors.add(:contact_no, "Zip code cannot be more than 6 digits") if  a[0].length > 6
       errors.add(:contact_no, "No is too short") if  a[1].length < 6
     end
   end
 end
  
end
