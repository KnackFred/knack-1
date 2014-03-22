Given /^I am an authenticated partner with (\d+) administrators$/ do |admin_num|
  Given "I am an authenticated partner"
  @partner_administrators = FactoryGirl.create_list(:partner_administrator, admin_num.to_i, :Partner_ID => @partner.id)
end


When /^I create an administrator$/ do
  @partner_administrators = [Factory.build(:partner_administrator)]
  When 'I go to the partner administrators page'
  page.find(".btn-add").click
  fill_in "administrator_FirstName", :with => @partner_administrators[0].FirstName
  fill_in "administrator_LastName", :with => @partner_administrators[0].LastName
  fill_in "administrator_Login", :with => @partner_administrators[0].Login
  fill_in "administrator_Password", :with => @partner_administrators[0].Password
  fill_in "administrator_Email", :with => @partner_administrators[0].Email
  page.find(".btn-save").click
end

When /^I try to create the same administrator$/ do
  When 'I go to the partner administrators page'
  page.find(".btn-add").click
  fill_in "administrator_FirstName", :with => @partner_administrators[0].FirstName
  fill_in "administrator_LastName", :with => @partner_administrators[0].LastName
  fill_in "administrator_Login", :with => @partner_administrators[0].Login
  fill_in "administrator_Password", :with => @partner_administrators[0].Password
  fill_in "administrator_Email", :with => @partner_administrators[0].Email
  page.find(".btn-save").click
  end

When /^I delete the first administrator$/ do
  When 'I go to the partner administrators page'
  page.find("#product-table a.delete").click
end

Then /^I should see the administrator in the administrator list$/ do
  Then 'I go to the partner administrators page'
  within("#product-table") do
     page.should have_content(@partner_administrators[0].id)
     page.should have_content(@partner_administrators[0].FirstName)
     page.should have_content(@partner_administrators[0].LastName)
     page.should have_content(@partner_administrators[0].Login)
     page.should have_content(@partner_administrators[0].Phone)
     page.should have_content(@partner_administrators[0].Email)
   end
end

Then /^I should not see the administrator in the administrator list$/ do
  Then 'I go to the partner administrators page'
  within("#product-table tbody") do
     page.should have_no_content(@partner_administrators[0].id.to_s)
     page.should have_no_content(@partner_administrators[0].FirstName)
     page.should have_no_content(@partner_administrators[0].LastName)
     page.should have_no_content(@partner_administrators[0].Login)
   end
end

Then /^I should see (.*) (administrators|stores)$/ do |entry_count, arg|
  expected = entry_count.to_i
  actual = page.all(:xpath, '//table[@id="product-table"]/tbody/tr').size
  raise("Exception") unless expected == actual
end
