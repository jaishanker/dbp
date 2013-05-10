class Post < ActiveRecord::Base
  
  validates_presence_of :body
  belongs_to :topic,:foreign_key => :topic_id
  belongs_to :user

  cattr_reader :per_page
  @@per_page = PER_PAGE  

  def self.find_weekly_report(start_date,end_date)

     Post.find_by_sql("select COUNT(*) as c from posts where date(created_at) BETWEEN '#{start_date}' and '#{end_date}'")

  end

  def self.count_all
    count(:all,:conditions => "status = 1")
  end
  
  def self.count_members
    c = find_by_sql("select count(distinct(user_id)) as members from posts where status = 1")
    return c[0].members
  end
  
  def self.find_all_with_abuses
    find_by_sql("select posts.id as id,topics.id as topic_id,topics.permalink as permalink,  topics.title as title,posts.body as body, posts.created_at as date, \
    users.login as posted_by, posts.status as status, count(posts.id ) as abuse_count  
    from posts, topics, report_abuses,users where posts.id = report_abuses.entity_id and 
    report_abuses.type = 'DiscussionReportAbuse' and posts.user_id = users.id  and posts.topic_id = topics.id\
    group by posts.id  order by report_abuses.updated_at DESC")
    
  end


  
  def self.top_participants
      find_by_sql "select user_id,count(id) as post_count from posts where status = 1 and created_at > '2010-05-01 00:00:00' group by user_id order by post_count desc limit 6"
  end    
 
  
  def self.get_reporting_values(start_date,group)
    find_by_sql("select #{group}(created_at) as splitter, count(*) as count from posts where status = 1 \
     and date(created_at) >= '#{start_date.to_s(:db)}' group by #{group}(created_at)")
  end

  def self.get_single_reporting_values(start_date,group,id)
    find_by_sql("select #{group}(created_at) as splitter, count(*) as count from posts where topic_id = #{id} and status = 1 \
     and date(created_at) >= '#{start_date.to_s(:db)}' group by #{group}(created_at)")
  end
  
end
