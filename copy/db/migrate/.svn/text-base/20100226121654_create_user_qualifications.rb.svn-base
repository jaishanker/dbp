class CreateUserQualifications < ActiveRecord::Migration
  def self.up
    create_table :user_qualifications do |t|
      t.column :user_id,                     :integer
      t.column :qualification,                      :string, :limit => 100
      t.column :specification,                      :string, :limit => 100
      t.column :year_of_passing,                      :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :user_qualifications
  end
end
