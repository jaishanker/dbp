class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :login,                     :string, :limit => 50, :unique => true
      t.column :first_name,                      :string, :limit => 50
      t.column :last_name,                      :string, :limit => 50
      t.column :email,                     :string, :limit => 50, :unique => true
      t.column :crypted_password,          :string
      t.column :salt,                      :string
      t.column :gender,                     :string, :limit => 10
      t.column :profession,                     :string, :limit => 50
      t.column :country,                     :string, :limit => 50
      t.column :contact_no,                     :string, :limit => 50
      t.column :birth_date,                     :date      
      t.column :display_name_type,                     :integer, :limit => 4
      t.column :status_message,                     :string
      t.column :preferred_page,                     :string, :limit => 50 
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
      t.column :activation_code, :string
      t.column :activated_at, :datetime      
      t.column :forgot_token, :string
      t.column :last_login_at,             :datetime      
      t.column :login_count, :integer
      t.column :viewer_count, :integer  
      t.column :status, :string, :limit => 20
      t.timestamps
    end
    add_index :users, :login, :unique => true
    add_index :users, :email, :unique => true
  end

  def self.down
    remove_index :users, :login
    remove_index :users, :email
    drop_table "users"
  end
end
