#--
# Copyright (c) 2008 Matson Systems, Inc.
# Released under the BSD license found in the file 
# LICENSE included with this ActivityStreams plug-in.
#++
# ActivityStreams configuration/initilization

# NOTE: The activites keys must be unique
ACTIVITY_STREAM_ACTIVITIES = { 
    :follow_creator => 'Subscribe or Unsubscribe to a Content Creator',
    :follow_category => 'Subscribe or Unsubscribe to a Category',
    :sponsor_creator => 'Sponsor a Content Creator',
    :posted_torrent => 'Upload a new torrent',
    :posted_message => 'Post a public message',
    :changed_profile => 'Changed profile',
    :profile_updater => 'Updated profile',
    :posted_comment => 'Post a comment',    
    :shared_with_followings => 'Shared with followings',     
    :shared_with_followers => 'Shared with followers',     
    :added_to_favorite => 'Added to favorite',     
    :removed_from_favorite => 'Removed from favorite',     
    :shared_with_network => 'Shared with network',         
    :joined_group=> 'Joined group', 
    :unjoined_group=> 'Joined group',     
    :created_group=> 'Created group',         
    :uploaded_design=> 'Uploaded design',    
    :started_following => "Is now following",
    :replied_comment => "Replied to comment",    
    :posted_topic => 'Posted topic',    
    :posted_reply => 'Posted reply',      
    :download => 'Download a torrent'}

# NOTE: These have hard coded meanings
ACTIVITY_STREAM_LOCATIONS = { 
    :public_location => 'Public Portion of of this site',
    :logged_in_location => 'Logged In Portion of this site',
    :feed_location => 'Your Activity Stream Atom Feed' }

ACTIVITY_STREAM_SERVICE_STRING="MyServiceName"
ACTIVITY_STREAM_USER_MODEL='User'
ACTIVITY_STREAM_USER_MODEL_ID='user_id'
ACTIVITY_STREAM_USER_MODEL_NAME='first_name'
#ACTIVITY_STREAM_USER_MODEL_NAME='friendly_name'
