Then /^I should entries for each category in the system$/ do
  page.should have_css(".category-row", :count => Category.count)
end