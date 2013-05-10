class CreateEventParticipants < ActiveRecord::Migration
  def self.up
    create_table :event_participants do |t|
      t.column :event_id,:integer
      t.column :user_id,:integer
      t.column :status,:integer,:limit => 4
      t.timestamps
    end
  end

  def self.down
    drop_table :event_participants
  end
end
