## General items

Given /^I am a registered user with email "([^"]*)" and password "([^"]*)"$/ do |email, pwd|
  @category = Factory.create(:category)
  @registrant = Factory.create(:registrant, :Email => email, :new_password => pwd)
  @pwd = pwd
end

Given /^I am a registered facebook user with email "([^"]*)"$/ do |email|
  @category = Factory.create(:category)
  @registrant = Factory.create(:registrant, :Email => email, :fbuid => 12)
  @email = email
end

Given /^I am a new user who has been activated$/ do
  @category = Factory.create(:category)
  @registrant = Factory.create(:registrant, :new_password => "Swordfish", :State_ID => nil)
  @pwd = "Swordfish"
end

Given /^I am a new user who has not seen the invite friends page$/ do
  @category = Factory.create(:category)
  @registrant = Factory.create(:registrant, :new_password => "Swordfish", :invite_friends_shown => false)
  @pwd = "Swordfish"
end

When /^I log in$/ do
  step 'I go to the signin page'
  step 'I enter the credentials: email "' + @registrant.Email + '" and password "' + @pwd + '"'
end

When /^I log out$/ do
  step 'I go to the signout page'
end



Given /^I am an authenticated registrant$/ do
  if @registrant.nil?
    @state = Factory.create(:state)

    @registrant = Factory.create(:registrant, :Email => "user@test.com", :new_password => "swordfish", :State_ID => @state.id)
    @pwd = "swordfish"
  end
  step "I go to the signin page"
  step 'I enter the credentials: email "user@test.com" and password "swordfish"'
  step 'I should be on the manage_registry page'
end

Given /^I am an authenticated registrant how giver$/ do
  @category_giver = Factory.create(:category)
  @state_giver = Factory.create(:state)
  @registrant_giver = Factory.create(:registrant, :Email => "user_giver@test.com", :new_password => "swordfish", :State_ID => @state_giver.id)
  @pwd = "swordfish"

  step "I go to the signin page"
  step 'I enter the credentials: email "user_giver@test.com" and password "swordfish"'
  step 'I should be on the manage_registry page'
end

Given /^I have "([^"]*)" "([^"]*)" "([^"]*)" gift in my registry with "([^"]*)" dollars contributed$/ do |count, type1, type2, amount|
  case type1
    when "available"
      purchase_status = RegistryItem::AVAILABLE
    when "purchased"
      purchase_status = RegistryItem::PURCHASED
    when "ordered"
      purchase_status = RegistryItem::ORDERED
    else
      raise("Exception")
  end

  count.to_i.times {
    case type2
      when "catalogue"
        product = Factory.create(:product)
      when "unique"
        product = Factory.create(:product, :IsKind => true)
      when "cash"
        product = Factory.create(:product, :Registrant_ID => 1, :quantity => 1)
      when "external"
        product = Factory.create(:product, :Registrant_ID => 1, :quantity => 1, :external => true)
      else
        raise("Exception")
    end

    r2p = Factory.create(:registry_item_with_contributions, :registrant => @registrant, :product => product, :Purchased_ID => purchase_status, :contributed => amount)
    @registry_item = r2p
    if type1 == "ordered"
      order = Factory.create(:order)
      Factory.create(:orders2registrant2product, :registry_item => r2p, :order => order)
    end
  }
end

Given /^I have "([^"]*)" "([^"]*)" "([^"]*)" gifts? in my registry$/ do |count, type1, type2|
  count.to_i.times {
    step "I have a \"#{type1}\" \"#{type2}\" gift in my registry"
  }
end

Given /^I have a "([^"]*)" "([^"]*)" gift in my registry$/ do |type1, type2|
  step "I have a \"#{type1}\" \"#{type2}\" gift in my registry with a total price of \"12\" dollars"
end

Given /^I have "([^"]*)" "([^"]*)" "([^"]*)" gifts? in my registry with names how "([^"]*)"$/ do |count, type1, type2, role|
  count.to_i.times do |i|
    step "I have a \"#{type1}\" \"#{type2}\" gift in my registry named \"MY PRODUCT (#{i})\" how \"#{role}\""
  end
end

Given /^I have a "([^"]*)" "([^"]*)" gift in my registry named "([^"]*)" how "([^"]*)"$/ do |type1, type2, name, role|
  step "I have a \"#{type1}\" \"#{type2}\" gift in my registry named \"#{name}\" with a total price of \"12\" dollars how \"#{role}\""
end

Given /^I have a "([^"]*)" "([^"]*)" gift in my registry with a total price of "([^"]*)" dollars$/ do |type1, type2, price|
  step "I have a \"#{type1}\" \"#{type2}\" gift in my registry named \"Product\" with a total price of \"#{price}\" dollars how \"registrant\""
end


Given /^I have a "([^"]*)" "([^"]*)" gift in my registry with quantity "([^"]*)"$/ do |type1, type2, quantity|
  step 'I have a "'+type1+'" "'+type2+'" gifts in my registry named "test" with a total price of "10" dollars and quantity "'+quantity+'" how "registrant"'
end

Given /^I have a "([^"]*)" "([^"]*)" gifts? in my registry named "([^"]*)" with a total price of "([^"]*)" dollars how "([^"]*)"$/ do |type1, type2, name, price, role|
  step 'I have a "'+type1+'" "'+type2+'" gifts in my registry named "'+name+'" with a total price of "'+price+'" dollars and quantity "1" how "'+role+'"'
end

Given /^I have a "([^"]*)" "([^"]*)" gifts? in my registry named "([^"]*)" with a total price of "([^"]*)" dollars and quantity "([^"]*)" how "([^"]*)"$/ do |type1, type2, name, price, quantity, role|
  case type1
    when "available"
      purchase_status = RegistryItem::AVAILABLE
    when "purchased"
      purchase_status = RegistryItem::PURCHASED
    when "ordered"
      purchase_status = RegistryItem::ORDERED
    else
      raise("Exception")
  end

  case type2
    when "catalogue"
      @product = Factory.create(:product, :Name => name, :MasterPrice => price)
    when "unique"
      @product = Factory.create(:product, :Name => name, :MasterPrice => price, :IsKind => true)
    when "cash"
      @product = Factory.create(:product, :Name => name, :MasterPrice => price, :Registrant_ID => 1, :quantity => 1)
    when "external"
    else
      raise("Exception")
  end
  
  case role
    when "registrant"
      registrant = @registrant
    when "registrant giver"
      registrant = @registrant_giver
    else
      raise("Exception")
  end

  if type2 == "external"
    r2p = Factory.create(:registry_item_external, :registrant => registrant, :Price => price, :Quantity=> quantity, :Purchased_ID => purchase_status, :Tax => 1, :Shipment => 2)
  else
    r2p = Factory.create(:registry_item, :registrant => registrant, :Price => price, :product => @product, :Quantity=> quantity, :Purchased_ID => purchase_status, :Tax => 1, :Shipment => 2)
  end

  @registry_item = r2p
  if type1 == "purchased"
    order = Factory(:order_contributing, :registry_items => [r2p])
  end

  if type1 == "ordered"
    order = Factory.create(:order)
    Factory.create(:orders2registry_item, :registry_item => r2p, :order => order)
  end
end

And /^I have an "([^"]*)" gift in my registry with a variant named "([^"]*)" and value "([^"]*)" of "([^"]*)"$/ do |type, variant_name, variant_value, variant_values|
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

  product = Factory.create(:product)
  variant = Factory.create(:product_param, :product => product, :Name => variant_name)
  variant_values.split(",").each do |val|
    Factory.create(:value_param, :product_param => variant, :Value => val)
  end


  r2p = Factory.create(:registry_item, :registrant => @registrant, :product => product, :Purchased_ID => purchase_status)
  Factory.create(:product_params2order, :registry_item => r2p,:Name => variant_name, :Value => variant_value)

  if type != "available"
    r2p.Contributed = 10
    r2p.save()
  end

  if type == "ordered"
    order = Factory.create(:order)
    Factory.create(:orders2registry_item, :registry_item => r2p, :order => order)
  end
end

Given /^"([^"]*)" guests have contributed "([^"]*)" dollars$/ do |count, amount|
  step "\"#{count}\" guests have contributed \"#{amount}\" dollars from \"John\" with note \"Note\""
end

Given /^"([^"]*)" guests have contributed "([^"]*)" dollars from "([^"]*)" with note "([^"]*)"$/ do |count, amount, from, note|
  @registrant.registry_items.each do |r2p|
    count.to_i.times do
      r2p.Contributed += amount.to_i
      Factory.create(:contribute, :registry_item => r2p, :Contribute => amount, :From => from, :Notes => note)
    end
    r2p.save
  end
end

Given /^I have gifts of a certain price and type in my registry$/ do
  product = Factory.create(:product)
  r2p = Factory.create(:registry_item, :Quantity => 10, :Price => 1, :registrant => @registrant, :product => product, :Purchased_ID => RegistryItem::AVAILABLE)
  product = Factory.create(:product)
  r2p = Factory.create(:registry_item, :Quantity => 10, :Price => 2, :registrant => @registrant, :product => product, :Purchased_ID => RegistryItem::PURCHASED)
  product = Factory.create(:product)
  r2p = Factory.create(:registry_item, :Quantity => 10, :Price => 3, :registrant => @registrant, :product => product, :Purchased_ID => RegistryItem::ORDERED)
  product = Factory.create(:product)
  order = Factory.create(:order)
  Factory.create(:orders2registry_item, :registry_item => r2p, :order => order)
end


Given /^"([^"]*)" "([^"]*)" contributed "([^"]*)" dollars with a note "([^"]*)"$/ do |first_name, last_name, amount, note|
  @registrant.registry_items.each do |r2p|
    r2p.Contributed += amount.to_i
    Factory.create(:Contribute, :FirstName => first_name, :LastName => last_name, :registry_item => r2p, :Contribute => amount, :Notes => note)
    r2p.save
  end
end

Given /^I have a gift from "([^"]*)" with url "([^"]*)" in my registry$/ do |name, url|
  Factory.create(:registry_item_added_myself, :registrant => @registrant, :source_name => name, :source_url => url)
end

Given /^I have a gift ordered on "([^"]*)", it is order number "([^"]*)" and it is expected to be delivered in "([^"]*)"$/ do |order_date, order_number, delivery_date|
  product = Factory.create(:product)
  r2p = Factory.create(:registry_item, :registrant => @registrant, :product => product, :Purchased_ID =>  purchase_status = RegistryItem::ORDERED)
  order = Factory.create(:order, :DateTime => order_date, :id => order_number, :DeliveryDate => delivery_date)
  Factory.create(:orders2registry_item, :registry_item => r2p, :order => order)
end

When /^I enter the credentials: email "([^"]*)" and password "([^"]*)"$/ do |username, password|
  fill_in "registrant_Email", :with => username
  fill_in "registrant_Password", :with => password
  click_button "Login"
end

When /^I sign out$/ do
  click_link('Sign Out')
end

When /^I visit the registry page$/ do
  if @registry.nil?
    visit registry_path(@registrant.id)
  else
    visit registry_path(@registry.id)
  end

  begin
    page.find(".btn-close").click
    page.execute_script("$('.buttons-left').css('visibility', 'visible')")
    page.execute_script("$('.buttons-right').css('visibility', 'visible')")
  rescue
    true # If we get an exception it likely means that javascript isn't enabled.'
  end

end

When /^I click first product registry$/ do
  first(:css, '.gift-entry a').click
end

Then /^I should see an empty message$/ do
  page.should have_css('.not-found')
end


## LINKS ACTIONS

Then /^I should see 4 banners$/ do
  page.should have_css('.banner1')
  page.should have_css('.banner2')
  page.should have_css('.banner3')
  page.should have_css('.banner4')
end

Then /^each banner should have a corresponding code snippet$/ do
  page.should have_css(".banner-src", :count => 4)
end

Then /^banner should have a gift count of "([^"]*)"$/ do |gift_count|
  if gift_count == "1"
    page.should have_content(gift_count + " gift")
  else
    page.should have_content(gift_count + " gifts")
  end
end


## Manage_Registry

When /^I click "([^"]*)" for product "([^"]*)"$/ do |link, name|
  find(:xpath, "//div[contains(.,'#{name}') and @class='gift-entry-details']/*/div[contains(.,'#{link}')]/a").click
end

Then /^I should see "([^"]*)" "([^"]*)" gifts? in my registry$/ do |count, type|
  case type
    when "available"
      page.should have_content("Available")
    when "purchased"
      page.should have_content("Purchased")
    when "ordered"
      page.should have_content("Ordered")
    when "exchanged"
      page.should have_content("Exchanged for Credit")
    else
      throw("No Match")
  end
end

Then /^I should see "([^"]*)" gifts? in my registry$/ do |count|
  visit manage_registry_path(@registrant)
  page.should have_css(".gift-entry", :count => count)
end

Then /^I should see the details of the gift$/ do
  within('.gift-entry-details') do
    find('.name').should have_content(@registry_item.product.Name)
    case @registry_item.Purchased_ID
      when RegistryItem::AVAILABLE
      when RegistryItem::PURCHASED
        find('.status').should have_content("Purchased")
      when RegistryItem::ORDERED
        find('.status').should have_content("Ordered")
    end
    if @registry_item.product.IsKind
      find('.type').should have_content("Unique Gift")
    elsif @registry_item.product.Registrant_ID.nil?
      find('.type').should have_content("Catalog Gift")
    elsif @registry_item.product.external
      find('.type').should have_content("External Gift")
    else
      find('.type').should have_content("Cash Gift")
    end

    case @registry_item.Purchased_ID
      when RegistryItem::AVAILABLE
        find('.status').should have_content("Available")
      when RegistryItem::PURCHASED
        find('.status').should have_content("Purchased")
      when RegistryItem::ORDERED
        find('.status').should have_content("Ordered")
    end

    find('.quantity').should have_content(@registry_item.Quantity)
    find('.item-price').should have_content(@registry_item.Price)
    find('.subtotal').should have_content(@registry_item.subtotal)
  end
end

Then /^I should have "([^"]*)" dollars in credit\.$/ do |amount|
  page.should have_content("Your Credit : $" + amount)
end


Then /^I should see action "([^"]*)"$/ do |action|
  find(".actions").should have_content(action)
end

Then /^I should not see action "([^"]*)"$/ do |action|
  find(".actions").should_not have_content(action)
end

Then /^I should see my gifts in "([^"]*)" order$/ do |arg1|
  #This matches up with Given /^I have gifts of a certain price and type in my registry$/ above
  save_and_open_page
  page.should contain(/\$40\.00.*\$30\.00.*\$20\.00.*\$10\.00/)
end

Then /^I should be able to sign\-out and sign back in$/ do
  click_link('Sign Out')
  click_link('Sign In')
  fill_in "registrant_Email", :with => @registrant.Email
  fill_in "registrant_Password", :with => @pwd
  click_button "Login"
end


And /^I should see a video$/ do
  page.should have_css('.div-video-image')
end

Then /^I should see an external link with text "([^"]*)" and location "([^"]*)"$/ do |text, url|
  page.should have_css('a[href="'+url+'"][target="_blank"]', :text => text )
end

Then /^I should see an external link with text "([^"]*)"$/ do |text|
  page.should have_css('a[target="_blank"]', :text => text )
end

Then /^I should not see the name and email fields for the contribution$/ do
  within("#ifr-popup") do
    page.should_not have_content("Email")
    page.should_not have_content("Name")
  end
end