class CampLog < ActiveRecord::Base
  def self.get_campaign_reporting_values(start_date,group,campaign_id)
    find_by_sql("select #{group}(created_at) as splitter,count(distinct user_id) count from camp_logs where camp_id = #{campaign_id} and date(created_at) >= '#{start_date.to_s(:db)}' group by #{group}(created_at)" )
  end
end
