class NewsCategory < Category
  
    
  named_scope :all_active,:conditions => "status = 1",:order => "created_at DESC"
  named_scope :find_all,:order => "created_at DESC"
  
  has_many :news,:foreign_key => :category_id, :dependent => :destroy

  
  
end
