
class GroupComment < Comment

   belongs_to :design,:foreign_key => "commentable_id"
  
   named_scope :all_active,:conditions => "status = 1",:order => "created_at DESC"

   has_many :replies,:class_name => "GroupComment",:foreign_key => :parent_id,:conditions => "status = 1"


  def self.recent_comments(top)
    result = GroupComment.find(:all,:order => "created_at DESC", :limit => top,:include => {:design => :user})
    return result
  end

  def self.group_comment(id,top)
    result = GroupComment.find(:all,:conditions =>"parent_id is null and commentable_id=#{id} and commentable_type='Group'",:order => "created_at DESC", :limit => top)
    return result
  end

  def self.get_count
    count(:all,:conditions => "Status = 1 and commentable_type='Group'" )
  end

end
