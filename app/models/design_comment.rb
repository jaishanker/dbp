
class DesignComment < Comment

   belongs_to :design,:foreign_key => "commentable_id"
  
   named_scope :all_active,:conditions => "status = 1",:order => "created_at DESC"

   has_many :replies,:class_name => "DesignComment",:foreign_key => :parent_id,:conditions => "status = 1"


  def self.recent_comments(top,offset=0)
    result = DesignComment.find(:all,:conditions =>"commentable_type='Design' and status = 1",
                                :order => "created_at DESC",
                                :offset => offset,
                                :limit => top,
                                :include => [{:user => :pictures},{:design => :user}])
    return result
  end

  def self.design_comment(id,top,offset=0)
    result = DesignComment.find(:all,:conditions =>"parent_id is null and commentable_id=#{id} and commentable_type='Design'",
                                :order => "created_at ASC",:include =>[{:user => :pictures},{:design => :user}],:offset => offset, :limit => top)
    return result
  end

  def self.get_count
    count(:all,:conditions => "Status = 1 and commentable_type='Design'" )
  end

  def self.get_count_for_design(id)
    count(:all,:conditions => "commentable_id = #{id} and Status = 1 and commentable_type='Design'" )
  end

end
