class DiscussionCategory < Category
  
  named_scope :all_active,:conditions => "status = 1 and name != 'Groups'",:order => "created_at DESC",
              :include => {:sub_categories => {:topics => {:posts => :user }}}
  named_scope :find_all,:order => "created_at DESC",:include => :sub_categories
  
  has_many :sub_categories,:conditions => "status = 1", :dependent => :destroy
  has_many :all_subcategories, :class_name => "SubCategory", :dependent => :destroy    
  
#  def self.find_all
#    find(:all,:conditions => "status = 1",:order => "created_at DESC",:include => :sub_categories)
#  end
    
    
  def self.find_details(id)
    find(id,:include => {:sub_categories => {:topics => :posts}})
  end

   def self.find_all_details()
    find(:all,:conditions => "status = 1",:order => "created_at DESC",:include => {:sub_categories => {:topics => :posts}})
  end

   def self.count_active(class_name)
    self.count(:conditions => ["type = ? and status = ?",class_name,1])
  end

end
