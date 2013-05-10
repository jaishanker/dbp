
class NewsComment < Comment
  
  belongs_to :news,:foreign_key => "commentable_id"
  
  named_scope :all_active,:conditions => "status = 1",:order => "created_at DESC"
  
  has_many :replies,:class_name => "NewsComment",:foreign_key => :parent_id,:conditions => "status = 1"
  
  
  def self.recent_comments(top)
    result = NewsComment.find(:all,:order => "created_at DESC", :limit => top,:include => {:design => :user})
    return result
  end
  
  def self.news_comment(id,offset = 0)
    result = NewsComment.find(:all,:conditions =>"parent_id is null and commentable_id=#{id} and commentable_type='News'",:order => "created_at ASC",
                              :include =>[{:user => :pictures}],:limit => PER_PAGE, :offset => offset)
    return result
  end
  
  def self.get_count
    count(:all,:conditions => "Status = 1 and commentable_type='News'" )
  end

   def self.get_count_for_news(id)
    count(:all,:conditions => "commentable_id = #{id} and Status = 1 and commentable_type='News'" )
  end
  
end
