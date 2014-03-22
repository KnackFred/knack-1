Then /^I should see "(.*?)" items on the update external page$/ do |count|
  visit "/registrant/update_external"
  page.should have_css(".gift", :count => count.to_i)
end

Then /^I should see the item on the update external page$/ do
  visit "/registrant/update_external"
  within(".gift") do
    page.find(".name").value.should == @registry_item.product.Name
    page.find("select").value.should == (@registry_item.product.external ? "true" : "false")
    page.find(".source-name").value.should == @registry_item.product.source_name
    page.find(".source-url").value.should == @registry_item.product.source_url
  end
end

Then /^I change the values for the item on the update external page$/ do
  visit "/registrant/update_external"
  within(".gift") do
    @registry_item.product.Name = "New Name"
    page.find(".name").set(@registry_item.product.Name)
    @registry_item.product.source_name = "New Source Name"
    page.find(".source-name").set(@registry_item.product.source_name)
    @registry_item.product.source_url = "New Source URL"
    page.find(".source-url").set(@registry_item.product.source_url)
  end
  click_button "Save Changes"
end

Then /^I set an invalid value on the update external page$/ do
  visit "/registrant/update_external"
  within(".gift") do
    page.find(".source-url").set("")
  end
  click_button "Save Changes"
end