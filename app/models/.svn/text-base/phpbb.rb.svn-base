class Phpbb < ActiveRecord::Base
  
  set_table_name :learning_center_items
  
  def self.connect
    ActiveRecord::Base.establish_connection(
    :adapter => 'mysql',
    :host => 'localhost',
    :username => 'root',
    :password => '',
    :database => 'dbp_live_original'
    )
    
    all = Phpbb.find(:all,:conditions => "forum_id not in (8,9)")
    
    
    all.each do |a|
      
      ActiveRecord::Base.establish_connection(
    :adapter => 'mysql',
    :host => 'localhost',
    :username => 'root',
    :password => '',
    :database => 'dbp_live_original'
      )
      
      self.add(a.forum_name,a.forum_desc)
    end
  end
  
  def self.add(forum_name,forum_desc)
    
    ActiveRecord::Base.establish_connection(
    :adapter => 'mysql',
    :host => 'localhost',
    :username => 'root',
    :password => '',
    :database => 'dbp_live_dump'
    )
    
    scat = SubCategory.new
    scat.discussion_category_id = 34
    scat.name = forum_name
    scat.description = forum_desc
    scat.user_id = 1
    scat.status = 1
    scat.save
    
    
  end
  
  
  def self.dump_learnings
    
    learnings = self.find(:all)
    
    learnings.each do |l|
      lr = Learning.new
      lr.title = l.TITLE
      lr.description = l.DESCRIPTION
      lr.category_id = l.CATEGORY_ID.to_i == 2 ? 35 : 36
      lr.status = l.STATUS
      lr.user_id = 1
      lr.view_count = nil
      lr.embed_code = l.SOURCE
      lr.created_at = l.CREATED_ON
      lr.updated_at = l.MODIFIED_ON
      
      lr.save
    end
    
  end
  
  def self.get_topic_id(id)
    id = self.find_by_sql(["select f.topic_title as name from phpbb_topics f where f.topic_id = ?",id])
    return id[0].name
    puts id
  end
  
  def self.get_user_id(id)
    
    uid = self.find_by_sql(["select u.ID as id from users u, phpbb_users pu where u.EMAIL_ID = pu.user_email and pu.user_id = ?",id])
    
    return uid[0].id
    
  end
  
  def self.import_posts
    posts = self.find_by_sql("select topic_id,forum_id,poster_id,post_text,post_time from phpbb_posts")
    
    posts.each do |p|
      a = Topic.find_by_title(self.get_topic_id(p.topic_id))
      unless a.nil?
      pt = Post.new
      pt.topic_id = a.id
      pt.user_id = self.get_user_id(p.poster_id)
      pt.body = p.post_text
      pt.created_at = Time.at(p.post_time.to_i).to_s(:db)
      pt.updated_at = Time.at(p.post_time.to_i).to_s(:db)
      pt.status = 1
      pt.save!
      puts  pt.topic_id
      end
    end
  end
  
  def self.import_topics
    topics = self.find_by_sql("select topic_id,forum_id,topic_poster,topic_title,topic_time,topic_views from phpbb_topics where forum_id != 0")
    
    topics.each do |p|
      if Topic.find_by_title(p.topic_title).nil?
      pt = Topic.new
      pt.discussion_category_id = 46
      pt.sub_category_id = p.forum_id
      pt.user_id = self.get_user_id(p.topic_poster)
      pt.title = p.topic_title
      pt.created_at = Time.at(p.topic_time.to_i).to_s(:db)
      pt.updated_at = Time.at(p.topic_time.to_i).to_s(:db)
      pt.view_count = p.topic_views
      pt.status = 1
      pt.save!
      puts  pt.title
      
      end
    end
  end
  
  #  def self.import_scs
  #    sc = self.find_by_sql("select forum_name,forum_desc from phpbb_forums where forum_id in(12,13)")
  #   
  #    sc.each do |p|
  #      pt = SubCategory.new
  #      pt.discussion_category_id = 46
  #      pt.name = p.forum_name
  #      pt.description = p.forum_name
  #      pt.user_id = 1
  #      pt.view_count = 0
  #      pt.status = 1
  #      pt.save!
  #      puts  pt.name
  #    end
  #  
  #  end
  
end
