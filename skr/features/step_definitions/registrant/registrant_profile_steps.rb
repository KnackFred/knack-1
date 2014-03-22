## General items

Then /^I fill out my profile$/ do
  @registrant.Email = "new@test.com"
  fill_in 'registrant_Email', :with => @registrant.Email

  @registrant.FirstName = "newFirstName"
  fill_in 'registrant_FirstName', :with => @registrant.FirstName

  @registrant.LastName = "newLastName"
  fill_in 'registrant_LastName', :with => @registrant.LastName

  @registrant.Address = "newAddress"
  fill_in 'registrant_Address', :with => @registrant.Address

  @registrant.City = "newCity"
  fill_in 'registrant_City', :with => @registrant.City

#  @registrant.State_ID = "4"
#  fill_in 'registrant_State_ID', :with => @registrant.State_ID

  @registrant.ZIP = "33333"
  fill_in 'registrant_ZIP', :with => @registrant.ZIP

  @registrant.PhoneNumber = "123-555-5555"
  fill_in 'registrant_PhoneNumber', :with => @registrant.PhoneNumber

  @registrant.FirstNameCoCreated  = "NEW FirstNameCoCreated"
  fill_in 'registrant_FirstNameCoCreated', :with => @registrant.FirstNameCoCreated

  @registrant.LastNameCoCreated  = "NEW LastNameCoCreated"
  fill_in 'registrant_LastNameCoCreated', :with => @registrant.LastNameCoCreated

#  @registrant.Type_ID = "1"
#  fill_in 'registrant_Type_ID', :with => @registrant.Type_ID

  @registrant.EventDate = Time.now()
  fill_in 'registrant_EventDate', :with => @registrant.EventDate.strftime("%m/%d/%Y")

  @registrant.EventLocation = "NEW Event Location"
  fill_in 'registrant_EventLocation', :with => @registrant.EventLocation

  @registrant.Description = "NEW Description"
  fill_in 'registrant_Description', :with => @registrant.Description

end

Then /^I fill out an empty profile$/ do
  @registrant.Email = "new@test.com"
  fill_in 'registrant_Email', :with => @registrant.Email

  @registrant.FirstName = "newFirstName"
  fill_in 'registrant_FirstName', :with => @registrant.FirstName

  @registrant.LastName = "newLastName"
  fill_in 'registrant_LastName', :with => @registrant.LastName

  @registrant.Address = ""
  fill_in 'registrant_Address', :with => @registrant.Address

  @registrant.City = ""
  fill_in 'registrant_City', :with => @registrant.City

#  @registrant.State_ID = "4"
#  fill_in 'registrant_State_ID', :with => @registrant.State_ID

  @registrant.ZIP = ""
  fill_in 'registrant_ZIP', :with => @registrant.ZIP

  @registrant.PhoneNumber = ""
  fill_in 'registrant_PhoneNumber', :with => @registrant.PhoneNumber

  @registrant.FirstNameCoCreated  = ""
  fill_in 'registrant_FirstNameCoCreated', :with => @registrant.FirstNameCoCreated

  @registrant.LastNameCoCreated  = ""
  fill_in 'registrant_LastNameCoCreated', :with => @registrant.LastNameCoCreated

#  @registrant.Type_ID = "1"
#  fill_in 'registrant_Type_ID', :with => @registrant.Type_ID

  @registrant.EventDate = Time.now()
  fill_in 'registrant_EventDate', :with => @registrant.EventDate.strftime("%m/%d/%Y")

  @registrant.EventLocation = ""
  fill_in 'registrant_EventLocation', :with => @registrant.EventLocation

  @registrant.Description = ""
  fill_in 'registrant_Description', :with => @registrant.Description

end


And /^I should see my profile information$/ do
   find_field('registrant_Email').value.should == @registrant.Email
   find_field('registrant_FirstName').value.should == (@registrant.FirstName || "")
   find_field('registrant_LastName').value.should == (@registrant.LastName || "")
   find_field('registrant_Address').value.should == (@registrant.Address || "")
   find_field('registrant_City').value.should == (@registrant.City || "")
   find_field('registrant_State_ID').value.should == @registrant.State_ID.to_s
   find_field('registrant_ZIP').value.should == (@registrant.ZIP || "")
   find_field('registrant_PhoneNumber').value.should == (@registrant.PhoneNumber|| "")
   find_field('registrant_FirstNameCoCreated').value.should == (@registrant.FirstNameCoCreated || "")
   find_field('registrant_LastNameCoCreated').value.should == (@registrant.LastNameCoCreated || "")
   find_field('registrant_RegistryType_ID').value.should == @registrant.RegistryType_ID.to_s
   #find_field('registrant_EventDate').value.should == (@registrant.EventDate.nil? ? "" : @registrant.EventDate.strftime("%m/%d/%Y"))
   find_field('registrant_EventLocation').value.should == (@registrant.EventLocation || "")
   find_field('registrant_Description').value.should == (@registrant.Description || "")

end

And /^I change my password$/ do
  check('registrant_change_password')
  fill_in 'registrant_old_password', :with => @pwd
  fill_in 'registrant_new_password', :with => "new password"
  click_button ("Save")
  @pwd = "new password"
end

And /^I click on the profile picture$/ do
  page.find(".image").click
end
