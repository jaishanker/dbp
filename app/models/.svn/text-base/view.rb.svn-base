class View < ActiveRecord::Base
  
  def self.add_view(type,id)
    
    view = self.find_by_viewable_type_and_viewable_id(type.to_s,id)
    unless view.nil?
      if view.created_at.to_date == Date.today
        view.count = view.count + 1  
        view.save
      else
        self.create(:viewable_type => type.to_s,:viewable_id => id,:count => 1)
      end
    else
      self.create(:viewable_type => type.to_s,:viewable_id => id,:count => 1)
    end
    
  end
  
  def self.get_reporting_values(start_date,type,group)
    find_by_sql("select #{group}(created_at) as splitter, sum(count) as count from views where viewable_type = '#{type}' \
     and date(created_at) >= '#{start_date.to_s(:db)}' group by #{group}(created_at)")
  end

  def self.get_single_reporting_values(start_date,type,group,id)
    find_by_sql("select #{group}(created_at) as splitter, sum(count) as count from views where viewable_id = '#{id}' and viewable_type = '#{type}' \
     and date(created_at) >= '#{start_date.to_s(:db)}' group by #{group}(created_at)")
  end
  
end
