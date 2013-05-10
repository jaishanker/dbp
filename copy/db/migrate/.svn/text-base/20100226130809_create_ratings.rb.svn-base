class CreateRatings < ActiveRecord::Migration

     def self.up
      create_table :ratings, :force => true do |t|
        t.column :rating, :integer, :default => 0
        t.column :rateable_type, :string, :limit => 15,
          :default => "", :null => false
        t.column :rateable_id, :integer, :default => 0, :null => false
        t.column :user_id, :integer, :default => 0, :null => false
        t.column :created_at, :datetime, :null => false
        t.column :updated_at, :datetime, :null => false
      end

      add_index :ratings, ["user_id"], :name => "fk_ratings_user"
    end

    def self.down
      drop_table :ratings
    end

#  def self.up
#    create_table :ratings do |t|
#      t.column :ratings,                      :string, :limit => 100
#      t.column :type,                      :string, :limit => 50
#      t.column :user_id,                      :integer
#      t.column :type_id,                      :integer
#      t.column :status,                    :integer, :limit => 4
#      t.timestamps
#    end
#  end
#
#  def self.down
#    drop_table :ratings
#  end
end


