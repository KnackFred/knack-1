# Require bermuda
#require 'bermuda/cucumber'
Capybara.server_boot_timeout = 30
# If webkit options are disabled selenium will be used. Selenium is required for test relating to buying external to pass.  But it's slower.'
Capybara.javascript_driver = :webkit
#Capybara.javascript_driver = :webkit_debug