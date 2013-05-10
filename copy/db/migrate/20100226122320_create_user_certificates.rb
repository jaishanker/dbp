class CreateUserCertificates < ActiveRecord::Migration
  def self.up
    create_table :user_certificates do |t|
     t.column :user_id,                     :integer
     t.column :certificate,                      :string, :limit => 100
     t.column :description,                      :text
      t.timestamps
    end
  end

  def self.down
    drop_table :user_certificates
  end
end
