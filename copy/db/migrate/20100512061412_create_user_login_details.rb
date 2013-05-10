class CreateUserLoginDetails < ActiveRecord::Migration
  def self.up
    create_table :user_login_details do |t|
      t.column :user_id, :integer
      t.column :user_ip, :string ,:limit => 100
      t.timestamps
    end
  end

  def self.down
    drop_table :user_login_details
  end
end
