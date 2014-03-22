#set :repository,  "https://knackregistry.jira.com/svn/KR/branches/1.6/source/"
set :repository,  "https://knackregistry.jira.com/svn/KR/trunk/source/"

role :web, "knackregistry.com"                          # Your HTTP server, Apache/etc
role :app, "knackregistry.com"                          # This may be the same as your `Web` server
role :db,  "knackregistry.com", :primary => true # This is where Rails migrations will run

set :rails_env, 'production'