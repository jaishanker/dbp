class AddParticipantsCount < ActiveRecord::Migration
  def self.up
    add_column :contests, :total_participants, :integer   
    add_column :contests, :contest_tag, :string    
  end

  def self.down
    remove_column :contests, :total_participants   
    remove_column :contests, :contest_tag
  end
end
