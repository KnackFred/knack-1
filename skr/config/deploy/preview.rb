#set :repository,  "https://knackregistry.jira.com/svn/KR/branches/1.6/source/"
set :repository,  "ssh://git@bitbucket.org/srushti/knack-registry.git"

role :web, "preview.knackregistry.com"                          # Your HTTP server, Apache/etc
role :app, "preview.knackregistry.com"                          # This may be the same as your `Web` server
role :db,  "preview.knackregistry.com", :primary => true # This is where Rails migrations will run

set :rails_env, 'preview'
