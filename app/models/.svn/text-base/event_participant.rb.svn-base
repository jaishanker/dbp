class EventParticipant < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :event
  
  validates_presence_of :event_id,:user_id,:status
  validates_presence_of :organization, :message => "Organization can't be blank"
  validates_presence_of :position, :message => "Position can't be blank"
  validates_presence_of :name, :message => "Name can't be blank"  
  validates_presence_of :role, :message => "Please select role"    
  validates_presence_of :mob_no, :message => "Mobile number can't be blank"  
  validates_format_of :mob_no,:message => "Please enter valid mobile no",  :with => /^((\+){0,1}91(\s){0,1}(\-){0,1}(\s){0,1}){0,1}9[0-9](\s){0,1}(\-){0,1}(\s){0,1}[1-9]{1}[0-9]{7}$/, :allow_blank => true    
  validates_format_of :fax_no, :message => "Please enter valid fax no", :with => /([\(\+])?([0-9]{1,3}([\s])?)?([\+|\(|\-|\)|\s])?([0-9]{2,4})([\-|\)|\.|\s]([\s])?)?([0-9]{2,4})?([\.|\-|\s])?([0-9]{4,8})/, :allow_blank => true    
   validates_uniqueness_of :event_id,:scope => :user_id

  def self.get_reporting_values(start_date,group)
    find_by_sql("select #{group}(created_at) as splitter, count(*) as count from event_participants where date(created_at) >= '#{start_date.to_s(:db)}' group by #{group}(created_at)")
  end

  def self.get_reporting_values_for_event(start_date,group,id)
    find_by_sql("select #{group}(created_at) as splitter, count(*) as count from event_participants where event_id = #{id} and date(created_at) >= '#{start_date.to_s(:db)}' group by #{group}(created_at)")
  end
  
  def self.get_participants(organizer_id)
    current_date = Date.today().to_s(:db)        
    find_by_sql("SELECT distinct(ep.user_id) FROM event_participants ep where ep.status = 1 and ep.event_id in (select id from events where status = 1 and date>='#{current_date}' and user_id = #{organizer_id})")
  end

end
