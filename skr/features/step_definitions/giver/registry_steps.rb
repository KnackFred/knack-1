Given /^a registry for "([^"]*)" "([^"]*)" and "([^"]*)" "([^"]*)" with description "([^"]*)"$/ do |first_name, last_name, co_first_name, co_last_name, description|
  @registry = Factory.create(:registrant,
                             :FirstName => first_name,
                             :LastName => last_name,
                             :FirstNameCoCreated => co_first_name,
                             :LastNameCoCreated => co_first_name,
                             :Description => description
  )
end

Given /^a registry$/ do
  @registry = Factory.create(:registrant)
end

Given /^a registry with products in it$/ do
  step "a registry"
  step 'the registry has "5" "available" products in it'
  step 'the registry has "5" "purchased" products in it'
end


Given /^(?:the|a) registry (?:has|with) one product eligible for contributions in it$/ do
  step 'the registry has a "available" product in it with quantity "1" and price "200"'
end


Given /^(?:the|a) registry (?:has|with) a "([^"]*)" product in it$/ do |type|
  step 'the registry has a "'+type+'" product in it with quantity "1" and price "12"'
end

Given /^(?:the|a) registry (?:has|with) "([^"]*)" products? in it$/ do |count|
  step 'the registry has "' + count + '" "available" products in it'
end

Given /^(?:the|a) registry (?:has|with) "([^"]*)" "([^"]*)" products? in it$/ do |count, type|
  count.to_i.times do
    step 'the registry has a "'+type+'" product in it with quantity "1" and price "12"'
  end
end

Given /^(?:the|a) registry (?:has|with) a "([^"]*)" product in it with quantity "([^"]*)"$/ do |type, quantity|
  step 'the registry has a "'+type+'" product in it with quantity "'+quantity+'" and price "10" with "0" contributed'
end

Given /^(?:the|a) registry (?:has|with) a "([^"]*)" product in it with quantity "([^"]*)" and price "([^"]*)"$/ do |type, quantity, price|
  step 'the registry has a "'+type+'" product in it with quantity "'+quantity+'" and price "'+price+'" with "0" contributed'
end

Given /^(?:the|a) registry (?:has|with) a "([^"]*)" product in it with quantity "([^"]*)" and price "([^"]*)" with "([^"]*)" contributed$/ do |type, quantity, price, contributed|
  step "a registry" if @registry.nil?

  case type
    when "available"
      purchase_status = RegistryItem::AVAILABLE
    when "purchased"
      purchase_status = RegistryItem::PURCHASED
    when "ordered"
      purchase_status = RegistryItem::ORDERED
    else
      raise("Exception")
  end
  product = Factory.create(:product, :MasterPrice => price)
  @registry_item = Factory.create(:registry_item, :registrant => @registry, :product => product, :Purchased_ID => purchase_status, :Price => price, :Quantity => quantity, :Price => price, :Contributed => 0)
  if contributed.to_i > 0
    Factory.create(:contribute, :registry_item => @registry_item, :Contribute => contributed)
  end
end

Given /^(?:the|a) registry (?:has|with) an external gift in it$/ do
  step "a registry" if @registry.nil?
  @registry_item = Factory.create(:registry_item_external, :registrant => @registry)
end

Given /^(?:the|a) registry (?:has|with) an external gift in it with varients$/ do
  step "a registry" if @registry.nil?
  @registry_item = Factory.create(:registry_item_external, :registrant => @registry, :ext_color => "Red", :ext_size => "Large", :ext_other => "Other")
end

When /^I buy "([^"]*)" of the first registry item$/ do |quantity|
  step "I click contribute"
  step "I fill out the gift info"
  within_frame "ifr-popup" do
    fill_in "buy_registry_item_quantity", :with => quantity
  end
  step "I hit ok in the buy-contribute dialog"
end

When /^I buy registry item "([^"]*)"/ do |number|
  page.all(:css, '.contribute')[number.to_i].click
  step "I fill out the gift info"
  step "I hit ok in the buy-contribute dialog"
end

When /^I buy the first registry item/ do
  step 'I buy registry item "0"'
  end

When /^I contribute "([^"]*)" to registry item "([^"]*)"/ do |amount, number|
  page.all(:css, '.contribute')[number.to_i].click
  step "I fill out the gift info"
  within_frame "ifr-popup" do
    fill_in "buy_registry_item_contribute", :with => amount
  end
  step "I hit ok in the buy-contribute dialog"
end

Given /^I press "BUY" on registry item "([^"]*)"$/ do |number|
  page.all(:css, '.contribute')[number.to_i].click
end

When /^I contribute "([^"]*)" to the first registry item/ do |amount|
  When 'I contribute "'+amount+'" to registry item "0"'
end

When /^I click the button to add the first item to my registry$/ do
  page.find(".addfromregistry").click()
  page.find(".btn-save").click()
end

When /^I add the first item to my registry$/ do
  page.find(".addfromregistry").click()
  page.find(".btn-save").click()
end

When /^I click on the first registry item/ do
  When "I click on registry item \"0\""
end

When /^I click on registry item "([^"]*)"/ do |number|
  entry = page.all(:css, '.gift-entry')[number.to_i]
  id = entry.find('input').value
  @registry_item = RegistryItem.find id
  entry.find('a').click
end

When /^I initiate the external buying process$/ do
  step "I visit the registry item page"
  step "I click buy"
  step "I click continue"
end

When /^I confirm my purchase$/ do
  within_window(page.driver.browser.window_handles[1]) do
    fill_in "buy_registry_item[quantity]", :with => @registry_item.Quantity
    @from = "John And Sally"
    @note = "Thanks so Much"
    @email = "test@test.com"
    fill_in "buy_registry_item[from]", :with => @from
    fill_in "buy_registry_item[notes]", :with => @note
    fill_in "buy_registry_item[email]", :with => @email
    click_button("Confirm")
  end
end

When /^I try to confirm my purchase with invalid data$/ do
  within_window(page.driver.browser.window_handles[1]) do
    fill_in "buy_registry_item[quantity]", :with => ""
    @from = "John And Sally"
    @note = "Thanks so Much"
    @email = "test@test.com"
    fill_in "buy_registry_item[from]", :with => ""
    fill_in "buy_registry_item[quantity]", :with => @note
    fill_in "buy_registry_item[email]", :with => @email
    click_button("Confirm")
  end
end

When /^I buy the external item$/ do
  step "I initiate the external buying process"
  step "I confirm my purchase"
end

Then /^I should see "([^"]*)" registry items$/ do |count|
  page.should have_css('.gift-entry, .gift-entry-purchased', :count => count)
end

Then /^I should see "([^"]*)" "([^"]*)" registry items$/ do |count, type|
  case type
    when "available"
      count.to_i.should == page.all('.gift-entry').size - page.all('.gift-entry-purchased').size
    when "purchased"
      page.should have_css('.gift-entry-purchased', :count => count)
    when "ordered"
      page.should have_css('.gift-entry-purchased', :count => count)
    else
      raise("Exception")
  end
end

Then /^I should see a pop\-up explaining the process$/ do
   within("div.block-add-ext-inner") do
     page.should have_content("Buy gift from another site")
   end
end

Then /^I should see a pop\-up with the varients in it$/ do
  within_window(page.driver.browser.window_handles[1]) do
    page.should have_content("Style")
    page.should have_content(@registry_item.product.ext_color)
    page.should have_content("Size")
    page.should have_content(@registry_item.product.ext_size)
    page.should have_content(@registry_item.product.ext_other)
  end
end

Then /^I should see two pop\-ups one with instructions and the other with the item$/ do
  page.driver.browser.window_handles.length.should == 3
  within_window(page.driver.browser.window_handles[1]) do
    page.should have_css("#step1")
  end
end

Then /^I should see the external purchase confirmation$/ do
  within_window(page.driver.browser.window_handles[1]) do
    page.should have_css("div#confirm")
  end
end

Then /^I should see a validation error in the window$/ do
  within_window(page.driver.browser.window_handles[1]) do
      page.should have_css(".field_with_errors")
  end
end
