class Request < ActiveRecord::Base
      belongs_to :sender, :class_name => 'User'
      belongs_to :recipient, :class_name => 'User'  
      belongs_to :requestable, :polymorphic => true

  def self.my_incoming_requests(recipient_id , offset)
        find(:all, :conditions => ["recipient_id = ? and (active = 1 or active is null) and status <> 'ignored'", recipient_id],:order => "created_at desc",  :offset => offset, :limit => PER_PAGE)
  end  

  def self.my_outgoing_requests(sender_id , offset)
        find(:all, :conditions => ["sender_id = ? and (active = 1 or active is null) and status <> 'ignored'", sender_id],:order => "created_at desc", :offset => offset, :limit => PER_PAGE)
  end   
  
  def self.filter_incoming_requests(recipient_id , filter_by ,  offset)
        find(:all, :conditions => ["recipient_id = ? and (Requestable_type= ? or status=?) and (active = 1 or active is null) and status <> 'ignored'", recipient_id,filter_by,filter_by],:order => "created_at desc", :offset => offset, :limit => PER_PAGE)  
  end    

  def self.filter_outgoing_requests(sender_id , filter_by ,  offset)
        find(:all, :conditions => ["sender_id = ? and (Requestable_type= ? or status=?) and (active= 1 or active is null)  and status <> 'ignored'", sender_id,filter_by,filter_by],:order => "created_at desc", :offset => offset, :limit => PER_PAGE)  
  end    
end
