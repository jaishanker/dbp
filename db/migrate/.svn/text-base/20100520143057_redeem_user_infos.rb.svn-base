class RedeemUserInfos < ActiveRecord::Migration
  def self.up
    create_table :redeem_user_infos do |t|
      t.column :user_id,                   :integer
      t.column :redemption_id,             :integer
      t.column :address_line1,             :string, :limit => 100
      t.column :address_line2,             :string, :limit => 100
      t.column :country,                   :string, :limit => 50
      t.column :state,                     :string, :limit => 50
      t.column :city,                      :string, :limit => 50
      t.column :pincode,                   :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :redeem_user_infos
  end
end
