class IndexAndFk < ActiveRecord::Migration
  
  extend MigrationHelpers
  
  def self.up
    
    # indexes
    
    add_index :views,[:viewable_type,:viewable_id]
    add_index :users,[:login,:user_type,:status]
    add_index :user_qualifications,:user_id
    add_index :topics,[:sub_category_id,:status]
    add_index :tags,[:status,:tagable_type]
    add_index :sub_categories,[:discussion_category_id,:status]
    add_index :shares,[:shareable_type,:shareable_id]
    add_index :requests,[:requestable_type,:requestable_id]
    add_index :report_abuses,[:type,:entity_id]
    add_index :ratings,[:rateable_type,:rateable_id]
    add_index :profiles,:user_id
    add_index :privacy_settings,:user_id
    add_index :posts,[:topic_id,:status]
    add_index :pictures,[:gallerie_id,:gallerie_type]
    add_index :news,[:start_date,:end_date,:status]
    add_index :learnings,:status
    add_index :groups,:status
    add_index :games,:status
    add_index :follows,[:followable_id,:followable_type]
    add_index :follows,[:follower_id,:follower_type]
    add_index :favorites,[:favorable_type,:favorable_id]
    add_index :events,[:start_time,:end_time,:status]
    add_index :event_participants,[:event_id,:status]
    add_index :designs,:status
    add_index :comments,[:commentable_id,:commentable_type]
    add_index :categories,[:type,:status]
    add_index :banners,[:banner_type,:status]
    add_index :assets,[:attachable_type,:attachable_id]
    add_index :activities,[:object_id,:object_type]
    
    # foreign keys
    
    fk :user_qualifications,:user_id,:users 
    fk :user_professions,:user_id,:users 
    fk :user_certificates,:user_id,:users
    fk :topics,:sub_category_id,:sub_categories 
    fk :topics,:user_id,:users 
    fk :shares,:user_id,:users 
    fk :report_abuses,:user_id,:users 
    fk :ratings,:user_id,:users 
    fk :profiles,:user_id,:users 
    fk :privacy_settings,:user_id,:users
    fk :posts,:user_id,:users
    fk :posts,:topic_id,:topics
    fk :learning_requests,:user_id,:users
    fk :group_memberships,:user_id,:users
    fk :group_memberships,:group_id,:groups
    fk :games,:user_id,:users
    fk :follows,:followable_id,:users
    fk :follows,:follower_id,:users
    fk :favorites,:user_id,:users
    fk :event_participants,:user_id,:users
    fk :event_participants,:event_id,:events
    fk :designs,:user_id,:users
    fk :comments,:user_id,:users
    fk :activity_streams,:actor_id,:users
    fk :activities,:user_id,:users
    
    
  end
  
  def self.down
    
    # indexes
    
    remove_index :views,:column => [:viewable_type,:viewable_id]
    remove_index :users,:column => [:login,:user_type,:status]
    remove_index :topics,:column => [:subcategory_id,:status]
    remove_index :tags,:column => [:status,:tagable_type]
    remove_index :sub_categories,:column => [:discussion_category_id,:status]
    remove_index :shares,:column => [:shareble_type,:sharable_id]
    remove_index :requests,:column => [:requestable_type,:requestable_id]
    remove_index :reposr_abuses,:column => [:type,:entity_id]
    remove_index :ratings,:column => [:rateable_type,:rateable_id]
    remove_index :profiles,:user_id
    remove_index :privacy_settings,:user_id
    remove_index :posts,:column => [:topic_id,:status]
    remove_index :pictures,:column => [:gallerie_id,:gallerie_type]
    remove_index :news,:column => [:start_date,:end_date,:status]
    remove_index :learnings,:status
    remove_index :groups,:status
    remove_index :games,:status
    remove_index :follows,:column => [:followable_id,:followable_type]
    remove_index :follows,:column => [:follower_id,:follower_type]
    remove_index :favorites,:column => [:favorable_type,:favorable_id]
    remove_index :events,:column => [:start_time,:end_time,:status]
    remove_index :event_participants,:column => [:event_id,:status]
    remove_index :designs,:status
    remove_index :comments,:column => [:commentable_id,:commentable_type]
    remove_index :categories,:column => [:type,:status]
    remove_index :banners,:column => [:banner_type,:status]
    remove_index :assets,:column => [:attachable_type,:attachable_id]
    remove_index :activities,:column => [:object_id,:object_type]
    
    # foreign keys
    
    drop_fk :user_qualifications,:user_id 
    drop_fk :user_professions,:user_id 
    drop_fk :user_certificates,:user_id
    drop_fk :topics,:sub_category_id 
    drop_fk :topics,:user_id 
    drop_fk :shares,:user_id 
    drop_fk :report_abuses,:user_id 
    drop_fk :ratings,:user_id 
    drop_fk :profiles,:user_id 
    drop_fk :privacy_settings,:user_id
    drop_fk :posts,:user_id
    drop_fk :posts,:topic_id
    drop_fk :learning_requests,:user_id
    drop_fk :group_memberships,:user_id
    drop_fk :group_memberships,:group_id
    drop_fk :games,:user_id
    drop_fk :follows,:followable_id
    drop_fk :follows,:follower_id
    drop_fk :favorites,:user_id
    drop_fk :event_participants,:user_id
    drop_fk :event_participants,:event_id
    drop_fk :designs,:user_id
    drop_fk :comments,:user_id
    drop_fk :activity_streams,:actor_id
    drop_fk :activities,:user_id
    
  end
end
