When /^I visit the registry item page$/ do
  visit from_registry_path(:r => @registry_item.registrant.id, :r2p => @registry_item.id, :id => @registry_item.product.id, :item_name => "item")
end

When /^I buy the registry item$/ do
  When "I click contribute"
  When "I fill out the gift info"
  When "I hit ok in the buy-contribute dialog"
end

When /^I buy "([^"]*)" of the registry item$/ do |quantity|
  When "I click contribute"
  When "I fill out the gift info"
  within_frame "ifr-popup" do
    fill_in "buy_registry_item_quantity", :with => quantity
  end
  When "I hit ok in the buy-contribute dialog"
end

When /^I contribute "([^"]*)" to the registry item$/ do |amount|
  When "I click contribute"
  When "I fill out the gift info"
  within_frame "ifr-popup" do
    fill_in "buy_registry_item_contribute", :with => amount
  end
  When "I hit ok in the buy-contribute dialog"
end

When /^I click continue$/ do
  if page.has_selector?("div.block-add-ext .do-contribute-ext")
    find('div.block-add-ext .do-contribute-ext').click
  else
    throw "Can not find button"
  end
end

When /^I click buy$/ do
   step "I click contribute"
end
When /^I click contribute$/ do
  if page.has_selector?("#btn-contribute")
    find('#btn-contribute').click
  elsif page.has_selector?(".contribute")
    find(".contribute").click
  elsif page.has_selector?(".contribute-ext")
    find(".contribute-ext").click
  else
    throw "Can not find button"
  end
end

Then /^I should see the registry item$/ do
  current_path.should == from_registry_path(:r => @registry_item.registrant.id, :r2p => @registry_item.id, :id => @registry_item.product.id, :item_name => "item")

  page.find('.item-name').should have_content(@registry_item.product.Name)
  page.find('.item-price').should have_content(@registry_item.Price)
  page.find('.item-description').should have_content(@registry_item.product.Description)

end



When /^I press button "BUY"$/ do
  if page.has_selector?("#btn-contribute")
    find("#btn-contribute").click
  elsif page.has_selector?("#buynow")
    find("#buynow").click
  else
      raise("Button not found")
  end
end


When /^I press button "BUY" on the registry page$/ do
  find('.contribute').click
end

When /^I should not see the BUY button$/ do
  response.should_not have_selector('.contribute')
end

When /^I should see an error indicating that the item is already in the cart$/ do
  within_frame "ifr-popup" do
    response.should_not have_selector('.contribute')
  end
end