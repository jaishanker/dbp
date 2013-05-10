
class LearningComment < Comment
  
  belongs_to :learning,:foreign_key => "commentable_id"
  
  named_scope :all_active,:conditions => "status = 1",:order => "created_at DESC"
  
  has_many :replies,:class_name => "LearningComment",:foreign_key => :parent_id,:conditions => "status = 1"
  
  def self.recent_comments(top)
    result = LearningComment.find(:all,:order => "created_at DESC", :limit => top,:include => {:learning => :user})
    return result
  end
  
  def self.friends_comments(user,limit = PER_PAGE , offset = 0)
#    offset = 0
    followers = user.followers
#    followers = user.learning_paginate_followers(offset)
    followers_ids = followers.collect(&:id)
    result = LearningComment.find(:all,:conditions => ["user_id in (?) and commentable_type = 'Learning' and status = 1", followers_ids],:order => "created_at DESC", :limit => limit, :offset => offset ,
                                  :include => [{:learning => :user},{:user => :pictures}])
    return result
  end
  
  def self.learning_comment(id,top,offset=0)
    result = LearningComment.find(:all,:conditions =>"parent_id is null and commentable_id=#{id} and commentable_type='Learning'",:order => "created_at ASC",
                                  :include =>[{:user => :pictures}],:limit => top, :offset => offset)
    return result
  end
  
  def self.get_count
    count(:all,:conditions => "Status = 1 and commentable_type='Learning'" )
  end

  def self.get_count_for_learning(id)
    count(:all,:conditions => "commentable_id = #{id} and Status = 1 and commentable_type='Learning'" )
  end
  
end
