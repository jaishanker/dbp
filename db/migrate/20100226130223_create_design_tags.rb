class CreateDesignTags < ActiveRecord::Migration
  def self.up
    create_table :design_tags do |t|
      t.column :design_id,                     :integer
      t.column :tag_id,                      :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :design_tags
  end
end
