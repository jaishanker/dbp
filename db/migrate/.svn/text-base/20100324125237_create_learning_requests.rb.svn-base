class CreateLearningRequests < ActiveRecord::Migration
  def self.up
    create_table :learning_requests do |t|
      t.column :user_id,    :integer
      t.column :title,      :string
      t.column :topic,      :string
      t.column :description,:text
      t.column :pref_format,:string
      t.column :status,     :integer, :limit => 4
      t.timestamps
    end
  end
  
  def self.down
    drop_table :learning_requests
  end
end
