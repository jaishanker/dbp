class AddDetailsEventParticipation < ActiveRecord::Migration
  def self.up
    add_column :event_participants, :organization, :string   
    add_column :event_participants, :position, :string
  end

  def self.down
    remove_column :event_participants, :organization
    remove_column :event_participants, :position
  end
end
