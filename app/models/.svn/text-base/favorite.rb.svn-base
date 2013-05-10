# Defines named favorites for users that may be applied to objects in a polymorphic fashion.
class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :favorable, :polymorphic => true
  
  
  def self.favorites_count(class_name)
    self.count(:conditions => ["favorable_type = ?",class_name])
  end

  def self.favorites_count_for_obj(class_name,id)
    self.count(:conditions => ["favorable_id = ? and favorable_type = ?",id,class_name])
  end

  def self.my_favorites(user_id, favorabale_type , page)
            favorabale_type.constantize.paginate :page => page, :include => :favorites,
                                :conditions => ['favorites.user_id = ? AND favorites.favorable_type = ? and favorites.status = 1', 
                                                user_id, favorabale_type ] 
  end
  
  
  def self.get_reporting_values(start_date,type,group)
    find_by_sql("select #{group}(created_at) as splitter, count(*) as count from favorites where favorable_type = '#{type}' \
     and date(created_at) >= '#{start_date.to_s(:db)}' group by #{group}(created_at)")
  end

  def self.get_single_reporting_values(start_date,type,group,id)
    find_by_sql("select #{group}(created_at) as splitter, count(*) as count from favorites where favorable_id =#{id} and favorable_type = '#{type}' \
     and date(created_at) >= '#{start_date.to_s(:db)}' group by #{group}(created_at)")
  end
  
  
end
