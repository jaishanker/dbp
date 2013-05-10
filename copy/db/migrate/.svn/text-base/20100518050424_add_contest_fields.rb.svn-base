class AddContestFields < ActiveRecord::Migration
  def self.up
    add_column :contests,:tags,:string
    add_column :contests,:result_date,:date
  end

  def self.down
    remove_column :contests,:tags
    remove_column :contests,:result_date
  end
end
