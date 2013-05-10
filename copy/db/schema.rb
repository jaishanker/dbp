# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110510101933) do

  create_table "abuse_causes", :force => true do |t|
    t.string   "cause"
    t.string   "description"
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "activities", :force => true do |t|
    t.integer  "user_id"
    t.string   "activity",           :limit => 100
    t.integer  "object_id"
    t.string   "object_type",        :limit => 100
    t.integer  "points_earned"
    t.integer  "points_spend"
    t.integer  "points_substracted"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["object_id", "object_type"], :name => "index_activities_on_object_id_and_object_type"
  add_index "activities", ["user_id"], :name => "fk_activities_user_id"

  create_table "activity_stream_preferences", :force => true do |t|
    t.string   "activity"
    t.string   "location"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_stream_preferences", ["activity", "user_id"], :name => "activity_stream_preferences_idx"

  create_table "activity_stream_totals", :force => true do |t|
    t.string   "activity"
    t.integer  "object_id"
    t.string   "object_type"
    t.float    "total",       :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_stream_totals", ["activity", "object_id", "object_type"], :name => "activity_stream_totals_idx"

  create_table "activity_streams", :force => true do |t|
    t.string   "verb"
    t.string   "activity"
    t.integer  "actor_id"
    t.string   "actor_type"
    t.string   "actor_name_method"
    t.integer  "count",                       :default => 1
    t.integer  "object_id"
    t.string   "object_type"
    t.string   "object_name_method"
    t.integer  "indirect_object_id"
    t.string   "indirect_object_type"
    t.string   "indirect_object_name_method"
    t.string   "indirect_object_phrase"
    t.integer  "status",                      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_streams", ["actor_id", "actor_type"], :name => "activity_streams_by_actor"
  add_index "activity_streams", ["indirect_object_id", "indirect_object_type"], :name => "activity_streams_by_indirect_object"
  add_index "activity_streams", ["object_id", "object_type"], :name => "activity_streams_by_object"

  create_table "assets", :force => true do |t|
    t.string   "data_file_name"
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "attachable_id"
    t.string   "attachable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "assets", ["attachable_id", "attachable_type"], :name => "index_assets_on_attachable_id_and_attachable_type"
  add_index "assets", ["attachable_type", "attachable_id"], :name => "index_assets_on_attachable_type_and_attachable_id"

  create_table "banners", :force => true do |t|
    t.string   "banner_type",     :limit => 100
    t.text     "banner_code"
    t.string   "banner_page",     :limit => 100
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "banner_link"
    t.string   "banner_position"
  end

  add_index "banners", ["banner_type", "status"], :name => "index_banners_on_banner_type_and_status"

  create_table "camp_logs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "camp_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "campaigns", :force => true do |t|
    t.string   "title",      :limit => 100
    t.integer  "camp_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.string   "name",        :limit => 45,  :null => false
    t.string   "description", :limit => 200
    t.string   "type"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["type", "status"], :name => "index_categories_on_type_and_status"

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.string   "comment",                        :default => ""
    t.datetime "created_at",                                     :null => false
    t.integer  "commentable_id",                 :default => 0,  :null => false
    t.integer  "user_id",                        :default => 0,  :null => false
    t.string   "commentable_type", :limit => 15, :default => "", :null => false
    t.integer  "status"
    t.integer  "parent_id"
  end

  add_index "comments", ["commentable_id", "commentable_type"], :name => "index_comments_on_commentable_id_and_commentable_type"
  add_index "comments", ["user_id"], :name => "fk_comments_user"

  create_table "contest_participants", :force => true do |t|
    t.integer  "contest_id"
    t.integer  "user_id"
    t.integer  "design_id"
    t.integer  "status",     :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contests", :force => true do |t|
    t.string   "name",               :limit => 100
    t.text     "description"
    t.integer  "status"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "permalink"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tags"
    t.date     "result_date"
    t.integer  "total_participants"
    t.string   "contest_tag"
    t.integer  "winner1"
    t.integer  "winner2"
  end

  create_table "design_tags", :force => true do |t|
    t.integer  "design_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "designs", :force => true do |t|
    t.integer  "category_id"
    t.string   "name",        :limit => 100
    t.text     "description"
    t.integer  "status"
    t.integer  "user_id"
    t.integer  "view_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tags"
    t.string   "permalink"
  end

  add_index "designs", ["status"], :name => "index_designs_on_status"
  add_index "designs", ["user_id"], :name => "fk_designs_user_id"

  create_table "event_participants", :force => true do |t|
    t.integer  "event_id"
    t.integer  "user_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "organization"
    t.string   "position"
    t.string   "salutation",   :limit => 10
    t.string   "name"
    t.string   "mob_no",       :limit => 30
    t.string   "fax_no",       :limit => 30
    t.string   "role",         :limit => 30
  end

  add_index "event_participants", ["event_id", "status"], :name => "index_event_participants_on_event_id_and_status"
  add_index "event_participants", ["user_id"], :name => "fk_event_participants_user_id"

  create_table "events", :force => true do |t|
    t.string   "topic"
    t.string   "eventtype"
    t.string   "product"
    t.text     "description"
    t.text     "organizer"
    t.date     "date"
    t.time     "start_time"
    t.time     "end_time"
    t.string   "city"
    t.string   "state"
    t.string   "pin"
    t.text     "location"
    t.text     "sponsor"
    t.string   "phone_no"
    t.text     "directions"
    t.integer  "status"
    t.integer  "view_count"
    t.text     "agenda"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
    t.integer  "user_id"
  end

  add_index "events", ["start_time", "end_time", "status"], :name => "index_events_on_start_time_and_end_time_and_status"

  create_table "favorites", :force => true do |t|
    t.integer  "user_id"
    t.string   "favorable_type", :limit => 30
    t.integer  "favorable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",                       :default => 1
  end

  add_index "favorites", ["favorable_type", "favorable_id"], :name => "index_favorites_on_favorable_type_and_favorable_id"
  add_index "favorites", ["user_id"], :name => "fk_favorites_user_id"

  create_table "follows", :force => true do |t|
    t.integer  "followable_id",                      :null => false
    t.string   "followable_type",                    :null => false
    t.integer  "follower_id",                        :null => false
    t.string   "follower_type",                      :null => false
    t.boolean  "blocked",         :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["followable_id", "followable_type"], :name => "fk_followables"
  add_index "follows", ["followable_id", "followable_type"], :name => "index_follows_on_followable_id_and_followable_type"
  add_index "follows", ["follower_id", "follower_type"], :name => "fk_follows"
  add_index "follows", ["follower_id", "follower_type"], :name => "index_follows_on_follower_id_and_follower_type"

  create_table "forgot_passwords", :force => true do |t|
    t.integer  "user_id"
    t.integer  "expires"
    t.string   "key"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.string   "title",       :limit => 100
    t.text     "description"
    t.integer  "status"
    t.integer  "user_id"
    t.integer  "view_count"
    t.string   "tags"
    t.text     "embed_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  add_index "games", ["status"], :name => "index_games_on_status"
  add_index "games", ["user_id"], :name => "fk_games_user_id"

  create_table "group_memberships", :force => true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_memberships", ["group_id"], :name => "fk_group_memberships_group_id"
  add_index "group_memberships", ["user_id"], :name => "fk_group_memberships_user_id"

  create_table "groups", :force => true do |t|
    t.string   "name",        :limit => 50
    t.text     "description"
    t.integer  "category_id"
    t.string   "group_type",  :limit => 50
    t.text     "recent_news"
    t.string   "office",      :limit => 50
    t.string   "email",       :limit => 50
    t.string   "website",     :limit => 50
    t.string   "country",     :limit => 50
    t.string   "street_adds"
    t.string   "city",        :limit => 50
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "view_count"
    t.integer  "status"
    t.string   "permalink"
  end

  add_index "groups", ["status"], :name => "index_groups_on_status"

  create_table "hall_of_fames", :force => true do |t|
    t.string   "name",               :limit => 100
    t.string   "email",              :limit => 100
    t.string   "certification",      :limit => 100
    t.string   "simulation_no",      :limit => 100
    t.date     "certification_date"
    t.integer  "status"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "learning_center_items", :primary_key => "ID", :force => true do |t|
    t.string    "TITLE",       :limit => 100,                 :null => false
    t.string    "DESCRIPTION", :limit => 5000,                :null => false
    t.integer   "CATEGORY_ID",                                :null => false
    t.string    "SOURCE",      :limit => 3000,                :null => false
    t.integer   "PHOTO_ID",                                   :null => false
    t.timestamp "CREATED_ON",                                 :null => false
    t.timestamp "MODIFIED_ON",                                :null => false
    t.integer   "STATUS",                      :default => 1, :null => false
  end

  create_table "learning_requests", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "topic"
    t.text     "description"
    t.string   "pref_format"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "learning_requests", ["user_id"], :name => "fk_learning_requests_user_id"

  create_table "learnings", :force => true do |t|
    t.string   "title",           :limit => 100
    t.text     "description"
    t.integer  "category_id"
    t.integer  "status"
    t.integer  "user_id"
    t.integer  "view_count"
    t.string   "format"
    t.text     "embed_code"
    t.integer  "position"
    t.string   "upload_material", :limit => 150
    t.integer  "size"
    t.string   "tags",            :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  add_index "learnings", ["status"], :name => "index_learnings_on_status"
  add_index "learnings", ["title"], :name => "index_learnings_on_title", :unique => true

  create_table "news", :force => true do |t|
    t.string   "title",       :limit => 100
    t.text     "description"
    t.integer  "status"
    t.integer  "user_id"
    t.integer  "view_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "end_date"
    t.text     "embed_code"
    t.integer  "category_id"
    t.string   "permalink"
  end

  add_index "news", ["start_date", "end_date", "status"], :name => "index_news_on_start_date_and_end_date_and_status"

  create_table "news_rsses", :force => true do |t|
    t.string   "title"
    t.string   "link"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "participations", :force => true do |t|
    t.string  "title",         :limit => 100
    t.text    "description"
    t.string  "category_id",   :limit => 100
    t.string  "tags"
    t.text    "reason_to_win"
    t.integer "user_id"
    t.integer "contest_id"
  end

  create_table "phpbb_topics", :primary_key => "topic_id", :force => true do |t|
    t.integer "forum_id",                  :limit => 3, :default => 0,     :null => false
    t.integer "icon_id",                   :limit => 3, :default => 0,     :null => false
    t.boolean "topic_attachment",                       :default => false, :null => false
    t.boolean "topic_approved",                         :default => true,  :null => false
    t.boolean "topic_reported",                         :default => false, :null => false
    t.string  "topic_title",                            :default => "",    :null => false
    t.integer "topic_poster",              :limit => 3, :default => 0,     :null => false
    t.integer "topic_time",                             :default => 0,     :null => false
    t.integer "topic_time_limit",                       :default => 0,     :null => false
    t.integer "topic_views",               :limit => 3, :default => 0,     :null => false
    t.integer "topic_replies",             :limit => 3, :default => 0,     :null => false
    t.integer "topic_replies_real",        :limit => 3, :default => 0,     :null => false
    t.integer "topic_status",              :limit => 1, :default => 0,     :null => false
    t.integer "topic_type",                :limit => 1, :default => 0,     :null => false
    t.integer "topic_first_post_id",       :limit => 3, :default => 0,     :null => false
    t.string  "topic_first_poster_name",                :default => "",    :null => false
    t.string  "topic_first_poster_colour", :limit => 6, :default => "",    :null => false
    t.integer "topic_last_post_id",        :limit => 3, :default => 0,     :null => false
    t.integer "topic_last_poster_id",      :limit => 3, :default => 0,     :null => false
    t.string  "topic_last_poster_name",                 :default => "",    :null => false
    t.string  "topic_last_poster_colour",  :limit => 6, :default => "",    :null => false
    t.string  "topic_last_post_subject",                :default => "",    :null => false
    t.integer "topic_last_post_time",                   :default => 0,     :null => false
    t.integer "topic_last_view_time",                   :default => 0,     :null => false
    t.integer "topic_moved_id",            :limit => 3, :default => 0,     :null => false
    t.boolean "topic_bumped",                           :default => false, :null => false
    t.integer "topic_bumper",              :limit => 3, :default => 0,     :null => false
    t.string  "poll_title",                             :default => "",    :null => false
    t.integer "poll_start",                             :default => 0,     :null => false
    t.integer "poll_length",                            :default => 0,     :null => false
    t.integer "poll_max_options",          :limit => 1, :default => 1,     :null => false
    t.integer "poll_last_vote",                         :default => 0,     :null => false
    t.boolean "poll_vote_change",                       :default => false, :null => false
  end

  add_index "phpbb_topics", ["forum_id", "topic_approved", "topic_last_post_id"], :name => "forum_appr_last"
  add_index "phpbb_topics", ["forum_id", "topic_last_post_time", "topic_moved_id"], :name => "fid_time_moved"
  add_index "phpbb_topics", ["forum_id", "topic_type"], :name => "forum_id_type"
  add_index "phpbb_topics", ["forum_id"], :name => "forum_id"
  add_index "phpbb_topics", ["topic_approved"], :name => "topic_approved"
  add_index "phpbb_topics", ["topic_last_post_time"], :name => "last_post_time"

  create_table "pictures", :force => true do |t|
    t.string   "photo_file_name"
    t.string   "photo_content_type", :limit => 50
    t.integer  "photo_file_size"
    t.integer  "gallerie_id"
    t.string   "gallerie_type",      :limit => 25
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pictures", ["gallerie_id", "gallerie_type"], :name => "index_pictures_on_gallerie_id_and_gallerie_type"

  create_table "posts", :force => true do |t|
    t.integer  "topic_id"
    t.integer  "user_id"
    t.text     "body"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["topic_id", "status"], :name => "index_posts_on_topic_id_and_status"
  add_index "posts", ["user_id"], :name => "fk_posts_user_id"

  create_table "privacy_settings", :force => true do |t|
    t.integer  "user_id"
    t.boolean  "basic_info_member",       :default => true
    t.boolean  "basic_info_following",    :default => true
    t.boolean  "qualification_member",    :default => true
    t.boolean  "qualification_following", :default => true
    t.boolean  "profession_member",       :default => true
    t.boolean  "profession_following",    :default => true
    t.boolean  "certification_member",    :default => true
    t.boolean  "certification_following", :default => true
    t.boolean  "designs_member",          :default => true
    t.boolean  "designs_following",       :default => true
    t.boolean  "requests_member",         :default => false
    t.boolean  "requests_following",      :default => true
    t.boolean  "followings_member",       :default => false
    t.boolean  "followings_following",    :default => true
    t.boolean  "followers_member",        :default => false
    t.boolean  "followers_following",     :default => true
    t.boolean  "favourites_member",       :default => false
    t.boolean  "favourites_following",    :default => true
    t.boolean  "groups_member",           :default => true
    t.boolean  "groups_following",        :default => true
    t.boolean  "contests_member",         :default => false
    t.boolean  "contests_following",      :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "privacy_settings", ["user_id"], :name => "index_privacy_settings_on_user_id"

  create_table "products", :force => true do |t|
    t.string   "title",              :limit => 100
    t.text     "description"
    t.integer  "status"
    t.date     "expiry_date"
    t.integer  "product_count"
    t.integer  "points_required"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "products_available"
    t.integer  "shipment_cost"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.string   "website",                        :limit => 100
    t.string   "comm_site_1",                    :limit => 100
    t.string   "comm_site_2",                    :limit => 100
    t.string   "comm_site_3",                    :limit => 100
    t.string   "blog_1",                         :limit => 100
    t.string   "blog_2",                         :limit => 100
    t.string   "blog_3",                         :limit => 100
    t.integer  "qualification_type"
    t.integer  "graduation_year"
    t.integer  "total_exp"
    t.string   "solidworks_associate",           :limit => 5
    t.string   "cswp_surface_prof",              :limit => 5
    t.string   "cswp_shetmetal_prof",            :limit => 5
    t.string   "solidworks_version",             :limit => 150
    t.string   "solidwork_usege_exp",            :limit => 50
    t.string   "cad_usage_exp",                  :limit => 50
    t.string   "sw_simulation_or_cosmos",        :limit => 50
    t.string   "sw_flow_used",                   :limit => 5
    t.string   "solidwork_simulation_usege_exp", :limit => 50
    t.string   "comparison_phy_testing",         :limit => 5
    t.string   "worked_on_solidworks",           :limit => 5
    t.string   "solidword_product_worked_on",    :limit => 1000
    t.string   "skills",                         :limit => 1000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "diploma",                        :limit => 5
    t.string   "be",                             :limit => 5
    t.string   "masters",                        :limit => 5
    t.string   "cswe",                           :limit => 5
    t.string   "cswp",                           :limit => 5
    t.string   "cswp_mold_tools",                :limit => 5
    t.string   "cswsp",                          :limit => 5
    t.string   "simulation_version",             :limit => 150
    t.string   "epdm_version",                   :limit => 150
    t.string   "solidworks_3d_version",          :limit => 150
    t.string   "cswp_weldment_prof",             :limit => 5
    t.boolean  "pic_present"
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "ratings", :force => true do |t|
    t.integer  "rating",                      :default => 0
    t.string   "rateable_type", :limit => 15, :default => "", :null => false
    t.integer  "rateable_id",                 :default => 0,  :null => false
    t.integer  "user_id",                     :default => 0,  :null => false
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  add_index "ratings", ["rateable_type", "rateable_id"], :name => "index_ratings_on_rateable_type_and_rateable_id"
  add_index "ratings", ["user_id"], :name => "fk_ratings_user"

  create_table "redeem_user_infos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "redemption_id"
    t.string   "address_line1", :limit => 100
    t.string   "address_line2", :limit => 100
    t.string   "country",       :limit => 50
    t.string   "state",         :limit => 50
    t.string   "city",          :limit => 50
    t.integer  "pincode"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tel_no",        :limit => 30
    t.string   "mob_no",        :limit => 30
    t.integer  "shipment_type"
  end

  create_table "redemptions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "product_id"
    t.integer  "status",     :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "points"
    t.integer  "approved"
    t.integer  "shifted"
  end

  create_table "report_abuses", :force => true do |t|
    t.string   "type"
    t.string   "description"
    t.integer  "entity_id"
    t.integer  "user_id"
    t.integer  "abuse_cause_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "report_abuses", ["type", "entity_id"], :name => "index_report_abuses_on_type_and_entity_id"
  add_index "report_abuses", ["user_id"], :name => "fk_report_abuses_user_id"

  create_table "requests", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "requestable_type", :limit => 30
    t.integer  "requestable_id"
    t.string   "status",           :limit => 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active"
  end

  add_index "requests", ["requestable_type", "requestable_id"], :name => "index_requests_on_requestable_type_and_requestable_id"

  create_table "shares", :force => true do |t|
    t.integer  "user_id"
    t.string   "shareable_type", :limit => 30
    t.integer  "shareable_id"
    t.string   "shared_to_type", :limit => 30
    t.integer  "shared_to_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shares", ["shareable_type", "shareable_id"], :name => "index_shares_on_shareable_type_and_shareable_id"
  add_index "shares", ["user_id"], :name => "fk_shares_user_id"

  create_table "shouts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "to_user_id"
    t.text     "shout"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sub_categories", :force => true do |t|
    t.integer  "discussion_category_id"
    t.string   "name"
    t.integer  "user_id"
    t.integer  "status",                 :limit => 1
    t.integer  "view_count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
  end

  add_index "sub_categories", ["discussion_category_id", "status"], :name => "index_sub_categories_on_discussion_category_id_and_status"

  create_table "tags", :force => true do |t|
    t.string   "name",         :limit => 100
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "no_of_clicks"
    t.string   "tagable_type", :limit => 50
    t.integer  "tagable_id"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true
  add_index "tags", ["status", "tagable_type"], :name => "index_tags_on_status_and_tagable_type"

  create_table "topics", :force => true do |t|
    t.integer  "discussion_category_id"
    t.integer  "sub_category_id"
    t.integer  "user_id"
    t.string   "title"
    t.integer  "view_count"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
  end

  add_index "topics", ["sub_category_id", "status"], :name => "index_topics_on_sub_category_id_and_status"
  add_index "topics", ["user_id"], :name => "fk_topics_user_id"

  create_table "user_certificates", :force => true do |t|
    t.integer  "user_id"
    t.string   "certificate", :limit => 100
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_certificates", ["user_id"], :name => "fk_user_certificates_user_id"

  create_table "user_login_details", :force => true do |t|
    t.integer  "user_id"
    t.string   "user_ip",    :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_professions", :force => true do |t|
    t.integer  "user_id"
    t.string   "employer",   :limit => 100
    t.string   "position",   :limit => 100
    t.string   "industry",   :limit => 100
    t.integer  "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_professions", ["user_id"], :name => "fk_user_professions_user_id"

  create_table "user_qualifications", :force => true do |t|
    t.integer  "user_id"
    t.string   "qualification",   :limit => 100
    t.string   "specification",   :limit => 100
    t.integer  "year_of_passing"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_qualifications", ["user_id"], :name => "index_user_qualifications_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 50
    t.string   "first_name",                :limit => 50
    t.string   "last_name",                 :limit => 50
    t.string   "email",                     :limit => 50
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "gender",                    :limit => 10
    t.string   "profession",                :limit => 50
    t.string   "country",                   :limit => 50
    t.string   "contact_no",                :limit => 50
    t.date     "birth_date"
    t.integer  "display_name_type"
    t.string   "status_message"
    t.string   "preferred_page",            :limit => 50
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code"
    t.datetime "activated_at"
    t.string   "forgot_token"
    t.datetime "last_login_at"
    t.integer  "login_count"
    t.integer  "viewer_count"
    t.string   "status",                    :limit => 20
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                     :limit => 50
    t.string   "city",                      :limit => 50
    t.string   "pincode",                   :limit => 20
    t.string   "activity_stream_token"
    t.integer  "user_type"
    t.integer  "points"
    t.integer  "subscribe",                               :default => 1
    t.integer  "expertise_points",                        :default => 0
    t.integer  "profile_complete"
    t.integer  "fb_user_id",                :limit => 8
    t.string   "email_hash"
    t.integer  "news_subscribe"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["login", "user_type", "status"], :name => "index_users_on_login_and_user_type_and_status"
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

  create_table "views", :force => true do |t|
    t.integer  "count"
    t.string   "viewable_type", :limit => 50
    t.integer  "viewable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "views", ["viewable_type", "viewable_id"], :name => "index_views_on_viewable_type_and_viewable_id"

end
