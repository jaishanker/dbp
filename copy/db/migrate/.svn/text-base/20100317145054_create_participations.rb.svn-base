class CreateParticipations < ActiveRecord::Migration
  def self.up
    create_table :participations do |t|
      t.column :title,                      :string, :limit => 100, :unique => true
      t.column :description,                      :text
      t.column :category_id,                     :string, :limit => 100      
      t.column :tags,                   :string
      t.column :reason_to_win,                      :text    
      t.column :user_id, :integer
      t.column :contest_id, :integer
    end
  end

  def self.down
    drop_table :participations
  end
end
