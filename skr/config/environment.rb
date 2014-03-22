# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
KnackRegistry::Application.initialize!

# Fix issue with the number of accepted form fields to make sure design registry works with a large number of items.
if Rack::Utils.respond_to?("key_space_limit=")
  Rack::Utils.key_space_limit = 262144 # 4 times the default size
end