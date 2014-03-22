Given /^I have "([^"]*)" products? in cart how "([^"]*)" for buy$/ do |count, role|
  count.to_i.times do |i|
    Given "I have a product named \"MY PRODUCT (#{i})\""
  end
  
  case role
    when 'registrant'
      Given "I am an authenticated registrant"
    when 'registrant giver'
      Given "I am an authenticated registrant how giver"
      role = 'registrant'
  end
  count.to_i.times do |i|
    Given "I go to the catalog page"
    Given "I follow \"MY PRODUCT (#{i})\""
    Given "I press the buy button"
    Given "I wait until all Ajax requests are complete"
  end
  Given 'I follow "Yes"'
end

Given /^I have "([^"]*)" products? in cart how "([^"]*)" for "([^"]*)" to someone from the "([^"]*)" page$/ do |count, role, type, src|
  Given "I am an authenticated registrant"
  Given "a registry with \"#{count}\" products in it"

  Given "I have \"#{count}\" \"available\" \"catalogue\" gift in my registry with names how \"registrant\""
  Given "I sign out"

  if role == "registrant"
    Given "I am an authenticated registrant how giver"
  end
  
  count.to_i.times do |i|
    And "I visit the registry page"
    case src
      when 'registry'
        case type
          when 'buy'
            Given "I buy registry item \"#{i}\""
          when 'contribute'
            Given "I buy registry item \"#{i}\""
          else
            throw('No Match')
        end
      when 'item'
        Given "I click on registry item \"#{i}\""
        case type
          when 'buy'
            Given "I buy the registry item"
          when 'contribute'
            Given "I buy the registry item"
          else
            throw('No Match')
        end
      else
        throw('No Match')
    end
    
  end
end

Given /^I have two products in cart how "([^"]*)" for buy and contribute to someone from the "([^"]*)" page$/ do |role, src|
  Given "a registry"
  And "the registry has a \"available\" product in it with quantity \"2\""
  And "the registry has one product eligible for contributions in it"

  if role == "registrant"
    Given "I am an authenticated registrant how giver"
  end

  case src
    when 'registry'
      Given "I visit the registry page"
      Given "I buy registry item \"0\""
      Given "I visit the registry page"
      Given "I contribute \"10\" to registry item \"1\""
    when 'item'
      Given "I visit the registry page"
      Given "I click on registry item \"0\""
      Given "I buy the registry item"
      Given "I visit the registry page"
      Given "I click on registry item \"1\""
      Given "I contribute \"10\" to the registry item"
    else
      throw('No Match')
  end
end

Given /^I have "([^"]*)" "([^"]*)" products? in cart how "([^"]*)" from manage registry for "([^"]*)"$/ do |count, type1, role, type2|
  case role
    when 'registrant'
      Given "I am an authenticated registrant"
    when 'registrant giver'
      Given "I am an authenticated registrant how giver"
  end
  
  Given "I have \"#{count}\" \"#{type1}\" \"catalogue\" gift in my registry with names how \"#{role}\""
    
  count.to_i.times do |i|
    Given "I go to the manage_registry page"
    case type2
      when 'buy'
        Given "I click \"Buy\" for product \"MY PRODUCT (#{i})\""
        Given "I wait for \"1\" seconds"
        Given "I hit ok in the buy-contribute dialog"
      when 'order'
        Given "I click \"Order\" for product \"MY PRODUCT (#{i})\""
      when 'withdraw'
        Given "I click \"Exchange For Cash\" for product \"MY PRODUCT (#{i})\""
      else
        throw('No Match')
    end
    Given "I wait for \"1\" seconds"
    Given "I follow \"Yes\""
    Given "I wait until all Ajax requests are complete"
    Given "I wait for \"1\" seconds"
  end
end

And /^I should see "([^"]*)" items? in my cart$/ do |count|
  Then 'I should be on "Cart"'
  page.should have_selector('.productName', :count => count)
end

And /^I should see the item in my cart$/ do
  Then 'I should be on "Cart"'
  page.find('.productName').should have_content(@registry_item.product.Name)
  page.find('.div-description').should have_content(@registry_item.product.Description)
  page.find('.productPrice').should have_content(@registry_item.Price)
end

And /^I should see "([^"]*)" withdrawal items? in my cart$/ do |count|
    page.should have_selector('.td-withdraw', :count => count)
end

Then /^I should see empty cart$/ do
    page.should have_no_selector('.productName')
end

When /^I click "DELETE ITEM" for item "([^"]*)"$/ do |name|
  find(:xpath, "//td[contains(.,'#{name}') and @class='td-items']/../*/div[@class='div-delete']/input[@type='button']").click
end

When /^I press button "EMPTY CART"$/ do
  find('.emptycart').click
end

When /^I press button "CHECK OUT"$/ do
  find('.checkout').click
end

When /^I press button "CONTINUE"$/ do
  find('.btn-continue').click
end

When /^I press button "PROCESS ORDER"$/ do
  find('.btn-process').click
end

Then /^I should see an item in my cart with quantity "([^"]*)"$/ do |quantity|
  find('.td-quantity').text.should == quantity
end

Then /^I should see an item in my cart with "([^"]*)" contributed$/ do |quantity|
  find('.td-total .total-div').text.should == "$%.2f" % quantity
end