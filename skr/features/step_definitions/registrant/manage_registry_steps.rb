When /^I buy the first item in my registry$/ do
  click_link "Buy"

  within_frame "ifr-popupBuy" do
    click_link "proceed-buy"
  end

  click_link "Yes"
  end

When /^I buy "([^"]*)" of the first item in my registry$/ do |quantity|
  click_link "Buy"

  within_frame "ifr-popupBuy" do
    fill_in "quantity", :with => quantity
    click_link "proceed-buy"
  end

  click_link "Yes"
end

When /^I set the item to redirect and provide a source url and name$/ do
  click_link "Edit"
  find("#edit-source-link").click
  check("registry_item_product_attributes_external")
  @registry_item.product.source_name = "macys.com"
  @registry_item.product.source_url = "www.macys.com/testproduct"
  fill_in("Site Name", :with => @registry_item.product.source_name)
  fill_in("Link To Gift", :with => @registry_item.product.source_url)
  click_button("SAVE")
end

When /^I edit the items varients$/ do
  step "I go to the manage_registry page"
  click_link "Edit"
  fill_in("Color", :with => "Blue")
  fill_in("Size", :with => "Large")
  fill_in("Other", :with => "Other Instructions")
  click_button("SAVE")
end

When /^I set the item to redirect without providing a source url and name$/ do
  click_link "Edit"
  find("#edit-source-link").click
  check("registry_item_product_attributes_external")
  fill_in("Site Name", :with => "")
  fill_in("Link To Gift", :with => "")
  click_button("SAVE")
end

Then /^I open the contributions pop\-up for the first gift$/ do
  page.find(".contributors").click()
end


Then /^I should see the external item$/ do
  page.should have_content('External Gift')
  step "I should see an external link with text \"#{@registry_item.product.source_name}\""
end

Then /^I should see the item has updated varients$/ do
  step "I go to the manage_registry page"
  click_link "Edit"
  page.should have_field("Color", :with => "Blue")
  page.should have_field("Size", :with => "Large")
  page.should have_field("Other", :with => "Other Instructions")
end
