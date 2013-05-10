class Rating < ActiveRecord::Base
  
  
  def self.ratings_count(class_name)
    self.count(:conditions => ["rateable_type = ?",class_name])
  end

  def self.ratings_count_for_obj(id,class_name)
    self.count(:conditions => ["rateable_id = #{id} and rateable_type = ?",class_name])
  end

  def self.get_reporting_values(start_date,type,group)
    find_by_sql("select #{group}(created_at) as splitter, count(*) as count from ratings where rateable_type = '#{type}' \
     and date(created_at) >= '#{start_date.to_s(:db)}' group by #{group}(created_at)")
  end

  def self.get_single_reporting_values(start_date,type,group,id)
    find_by_sql("select #{group}(created_at) as splitter, count(*) as count from ratings where rateable_id =#{id} and rateable_type = '#{type}' \
     and date(created_at) >= '#{start_date.to_s(:db)}' group by #{group}(created_at)")
  end

  def self.get_old_rating(user,object)    
    find(:first, :select => 'rating' , :conditions => ['user_id = ? and rateable_id = ? and rateable_type = ?', user.id,object.id, object.class.to_s])
  end  
end
