class CreateForgotPasswords < ActiveRecord::Migration
  def self.up
    create_table :forgot_passwords do |t|
      t.column :user_id, :integer
      t.column :expires, :integer
      t.column :key, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :forgot_passwords
  end
end
