## Steps relating to store management

When /^I press the back button$/ do
  page.find('.btn-back').click
end

When /^I press the add button$/ do
  page.find('.btn-add').click
end

When /^I create a new store$/ do
  When "I go to the edit store page"

  fill_in "store_Name", :with => "TestStore"
  fill_in "store_Street", :with => "1-st"
  fill_in "store_City", :with => "Benton"
  fill_in "store_ZIP", :with => "36785"
  fill_in "store_Phone", :with => "5666892"
  fill_in "store_Email", :with => "TestStore@store.com"

  select "Alabama", :from => "store[State_ID]"
  page.find('.btn-save').click
end


