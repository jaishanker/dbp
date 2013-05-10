class RenameGroupColumns < ActiveRecord::Migration
  def self.up
    rename_column :groups, :category, :category_id
    rename_column :groups, :type, :group_type
  end

  def self.down
    rename_column :groups, :category_id, :category
    rename_column :groups, :group_type, :type
  end
end
