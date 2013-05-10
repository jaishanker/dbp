set :application, "dbp"
#set :repository,  "svn://216.205.98.18/dbpsvn/dbp"
set :repository,  "svn://208.43.176.230:3980/live_dbpsvn/dbp"

#set :domain, "216.205.98.18"

set :domain, "208.43.176.230"
# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/html/#{application}"
set :deploy_via, :checkout
#set :deploy_via, :rsync_with_remote_cache
#set :rsync_options, '-az --delete --exclude=.svn --delete-excluded'
# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
set :scm_username,  "girish"
set :scm_password,  "girish"

#set :user,          "gfmediaadmin"
#set :password,      "!gfmedia@admin!"

set :user,          "root"
set :password,      "M@$_t1ff2010_m3p"

set :use_sudo, false

role :app, domain
role :web, domain
role :db, domain, :primary => true