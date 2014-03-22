## General items

Given /^I am a registered partner$/ do
  @partner_password = "swordfish"
  @partner = Factory.create(:partner)
  password = PasswordUtilities.hash(@partner_password)
  @partner.update_attribute(:Password, password)

  @store = Factory.create(:store, :partner => @partner)

end

Given /^I am a registered partner with "(.*)" product$/ do |name|
  step 'I am a registered partner'

  @products = [Factory.create(:product_with_params, :Name => name, :ShipmentType => Product::FREE, :stores => [@store])]
  @products.first.product_params.first.update_attribute(:Partner_ID, @partner.id)
end

Given /^I am a registered partner with email "(.*)" and password "(.*)"$/ do |email, password|
  @partner_password = password
  @partner = Factory.create(:partner, :Email => email, :Password => password, :Password_confirmation => password)
  hash_password = PasswordUtilities.hash(@partner.Password)
  @partner.update_attribute(:Password, hash_password)
end

Given /^I am an authenticated partner$/ do
  step 'I am a registered partner'
  step 'I sign in as a partner'
end

When /^I sign in as a partner$/ do
  step "I go to the partner sign-in page"
  step "I enter the credentials for partner sign in: email \"#{@partner.Email}\" and password \"#{@partner_password}\""
  step "I should be on the partner profile page"
end

When /^I enter the credentials for partner sign in: email "([^"]*)" and password "([^"]*)"$/ do |username, password|
  fill_in "partner_Email", :with => username
  fill_in "partner_Password", :with => password
  click_button "Login"
end

When /^I select (.*) from store State select box$/ do |state|
  step "I select \"#{state}\" from \"store_State_ID\""
end

When /^I select (.*) from partner State select box$/ do |state|
  step "I select \"#{state}\" from \"partner_BillingState_ID\""
end

Given /^I am a registered partner with (\d+) stores$/ do |store_num|
  @partner = Factory.create(:partner, :Email => 'test_partner@mail.com')
  password = PasswordUtilities.hash(@partner.Password)
  @partner.update_attribute(:Password, password)
  @stores = FactoryGirl.create_list(:store, store_num.to_i, :partner => @partner)

  step 'I go to the partner sign-in page'
  step 'I enter the credentials for partner sign in: email "test_partner@mail.com" and password "HelloWorld"'
  step 'I should be on the partner profile page'
end


When /^I click (.*) button$/ do |button|
  locator = "//input[@class='btn-#{button.downcase}']"
  msg = "Button #{locator} was not found"
  find(:xpath, locator, :message => msg).click
end

When /I select (.*) from category hierarchical list/ do |category|
  #page.execute_script "$('#store_Category_ID').attr({value: '10'});"
  find(:xpath, '//input[@id="store_CategoryName"]').click
  page.all(:xpath, '//tr/td[img[contains(@src,"plus")]]/img').each do |element|
    element.click
  end
  find(:xpath, "//tr[contains(.,'#{category}')][td/img]//img[not(@border)]").click
end