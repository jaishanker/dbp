class GameComment < Comment
  
  belongs_to :game,:foreign_key => "commentable_id"
  
  named_scope :all_active,:conditions => "status = 1",:order => "created_at DESC"
  
  has_many :replies,:class_name => "GameComment",:foreign_key => :parent_id,:conditions => "status = 1"
  
  
  def self.recent_comments(top,offset)
    result = GameComment.find(:all,:conditions =>"commentable_type='Game'",:order => "created_at DESC", 
                              :limit => top,:offset => offset,
                              :include => [:game,:user,{:game => :user},{:user=>:pictures}])
    return result
  end
  
  def self.game_comment(id,top,offset=0)
    result = GameComment.find(:all,:conditions =>"parent_id is null and commentable_id=#{id} and commentable_type='Game'",
                              :offset => offset,
                              :include =>[{:user => :pictures}],:order => "created_at ASC", :limit => top)
    return result
  end
  
  def self.get_count
    count(:all,:conditions => "Status = 1 and commentable_type='Game'" )
  end

  def self.get_count_for_game(id)
    count(:all,:conditions => "commentable_id = #{id} and Status = 1 and commentable_type='Game'" )
  end
end
