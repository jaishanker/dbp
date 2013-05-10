class CreateContests < ActiveRecord::Migration
  def self.up
    create_table :contests do |t|
      t.column :name,                      :string, :limit => 100, :unique => true
      t.column :description,               :text
      t.column :status,                    :integer, :limit => 4
      t.column :start_date,                :date
      t.column :end_date,                  :date
      t.column :permalink,                  :string  
      t.timestamps
    end
  end
  
  def self.down
    drop_table :contests
  end
end
