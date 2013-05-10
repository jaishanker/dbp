class CreateRequests < ActiveRecord::Migration
  def self.up
    create_table :requests do |t|
      t.column :sender_id,            :integer
      t.column :recipient_id,            :integer      
      t.column :requestable_type,     :string, :limit => 30
      t.column :requestable_id,       :integer
      t.column :status,     :string, :limit => 50      
      t.timestamps
    end
  end

  def self.down
    drop_table :requests
  end
end
