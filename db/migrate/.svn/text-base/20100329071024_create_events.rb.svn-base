class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.column :topic,:string
      t.column :eventtype,:string
      t.column :product,:string
      t.column :description,:text
      t.column :organizer,:text
      t.column :date,   :date
      t.column :start_time,:time
      t.column :end_time,:time
      t.column :city,:string
      t.column :state,:string
      t.column :pin,:string
      t.column :location,:text
      t.column :sponsor,:text
      t.column :phone_no,:string
      t.column :directions,:text
      t.column :status,:integer,:size => 4
      t.column :view_count, :integer
      t.column :agenda, :text
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
