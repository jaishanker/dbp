class CreateContestParticipants < ActiveRecord::Migration
  def self.up
    create_table :contest_participants do |t|
      t.column :contest_id, :integer
      t.column :user_id, :integer
      t.column :design_id, :integer
      t.column :status, :integer,:default => "1"
      t.timestamps
    end
  end

  def self.down
    drop_table :contest_participants
  end
end
