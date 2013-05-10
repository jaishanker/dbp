
class CreateReportAbuses < ActiveRecord::Migration
  def self.up
    create_table :report_abuses do |t|
      t.column :type,                 :string
      t.column :description,          :string
      t.column :entity_id,            :integer
      t.column :user_id,              :integer
      t.column :abuse_cause_id,       :integer
     
    end
  end

  def self.down
    drop_table :report_abuses
  end
end
