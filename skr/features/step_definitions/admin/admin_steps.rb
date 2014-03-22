Given /^I am an authenticated administrator$/ do
  step 'I am a registered partner with email "fred@knackregistry.com" and password "11111"'
  step 'I go to the partner sign-in page'
  step 'I enter the credentials for partner sign in: email "fred@knackregistry.com" and password "11111"'
  step 'I should be on the administrator profile page'
end
