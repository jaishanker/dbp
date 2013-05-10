class Comment < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :commentable, :polymorphic => true
  has_many :comments, :as => :commentable

  has_many :activity_streams, :as => :actor, :dependent => :destroy
  has_many :activity_streams, :as => :object, :dependent => :destroy   


  validates_presence_of :comment, :message => "Comment can't be blank"
  acts_as_commentable
  
  after_create :notify_comment_posting

  def self.find_weekly_report(start_date,end_date)
      Comment.find_by_sql("select COUNT(*) as c from comments where date(created_at) BETWEEN '#{start_date}' and '#{end_date}'")
  end

  def self.get_reporting_values(start_date,type,group)
    find_by_sql("select #{group}(created_at) as splitter, count(*) as count from comments where commentable_type = '#{type}' \
     and status = 1 and date(created_at) >= '#{start_date.to_s(:db)}' group by #{group}(created_at)")
  end

  def self.get_single_reporting_values(start_date,type,group,id)
    find_by_sql("select #{group}(created_at) as splitter, count(*) as count from comments where commentable_id = #{id} and commentable_type = '#{type}' \
     and status = 1 and date(created_at) >= '#{start_date.to_s(:db)}' group by #{group}(created_at)")
  end

  def notify_comment_posting
    commentable_object = self.commentable
    if self.commentable_type == "Design"
        users = commentable_object.comments.collect{ |c| c.user } << commentable_object.user
    else
        users = commentable_object.comments.collect{ |c| c.user }
    end
    for user in users.uniq
       unless user.nil?
         if user.subscribe == 1
            UserMailer.deliver_comment_posting_notification(user , self)  unless user == self.user
         end
    end
    end
  end  
end
