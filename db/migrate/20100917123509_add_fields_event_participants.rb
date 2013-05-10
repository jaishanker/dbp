class AddFieldsEventParticipants < ActiveRecord::Migration
  def self.up
    add_column :event_participants, :salutation, :string, :limit => 10          
    add_column :event_participants, :name, :string
    add_column :event_participants, :mob_no,:string, :limit => 30   
    add_column :event_participants, :fax_no,:string, :limit => 30    
    add_column :event_participants, :role,:string, :limit => 30        
  end

  def self.down
    remove_column :event_participants, :salutation         
    remove_column :event_participants
    remove_column :event_participants, :mob_no
    remove_column :event_participants, :fax_no,:string 
    remove_column :event_participants, :role
  end
end
