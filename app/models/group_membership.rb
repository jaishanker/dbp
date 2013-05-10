class GroupMembership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group
  belongs_to :active_group, :class_name => "Group", :foreign_key => 'group_id', :conditions => "status = 1"  
  
  validates_uniqueness_of :group_id,:scope => :user_id

  cattr_reader :per_page
  @@per_page =PER_PAGE + 2  

  def self.get_reporting_values(start_date,group)
    find_by_sql("select #{group}(created_at) as splitter, count(*) as count from group_memberships where date(created_at) >= '#{start_date.to_s(:db)}' group by #{group}(created_at)")
  end

  def self.get_single_reporting_values(start_date,group,id)
    find_by_sql("select #{group}(created_at) as splitter, count(*) as count from group_memberships where group_id = #{id} and date(created_at) >= '#{start_date.to_s(:db)}' group by #{group}(created_at)")
  end
end
