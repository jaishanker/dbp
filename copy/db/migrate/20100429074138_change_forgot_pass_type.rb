class ChangeForgotPassType < ActiveRecord::Migration
  def self.up
    change_column :forgot_passwords, :key, :string
  end

  def self.down
   change_column :forgot_passwords, :key, :string
  end
end
