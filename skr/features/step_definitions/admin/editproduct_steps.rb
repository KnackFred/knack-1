Given /^I am an authenticated administrator editing existing product$/ do
  partner = Factory.create(:partner)
  Factory.create(:store, :Name => 'MyStore', :partner => partner) #necessary for store-adding scenario
  step 'I am an authenticated administrator'
  step 'I have "1" product'
  step 'I go to the administrator products page'
  step 'I should see "1" row in the products table'
  step 'I follow edit link for product in row "1"'
end

When /^I enter invalid product data$/ do
  fill_in "product[Name]", :with => ""

  find('#save').click
end

When /^I edit the products basic data$/ do
  @products[0].Name = "test1"
  @products[0].MasterPrice = 33
  @products[0].SalesPrice = 22
  @products[0].Description = "Description"
  @products[0].priority  = 12
  @products[0].ProductStatus_ID  = 2

  fill_in "product[Name]", :with => @products[0].Name
  fill_in "product[MasterPrice]", :with => @products[0].MasterPrice
  fill_in "product[SalesPrice]", :with => @products[0].SalesPrice
  fill_in "product[Description]", :with => @products[0].Description
  select ProductStatus::STATUSES[@products[0].ProductStatus_ID], :from => "product[ProductStatus_ID]"
  select @products[0].priority.to_s, :from => "product[priority]"

  find('#save').click
end

When /^I set a new brand for the product$/ do
  @products[0].Brand_ID = Brand.first() ? Brand.first().id + 1 : 1
  choose "product_BrandType_2"
  fill_in "product[BrandName]", :with => "brand1"
  find('#save').click
end

When /^I edit the products shipment category/ do
  @products[0].shipment_category = Category.root.children[0]
  choose "product_ShipmentType_1"
  select @products[0].shipment_category.name, :from  => "product[ShipmentCategory_ID]"
  find('#save').click
end

When /^I add a category to the product/ do
 click_link "Add category"
 step 'I select category "child" in popup'
 find('#btn-add-cat').click
 step 'I should see "child" in categories table'
 find('#save').click
end

When /^I add a color to the product/ do
  @products[0].colors = [Color.find_by_Name("Black")]
  click_link "Add color"
  step 'I click on black color in popup'
  step 'I should see "Black" in colors table'
  find('#save').click
end

When /^I add a varient to the product/ do
  click_link "Add variant"
  fill_in "param-name", :with => "Size"
  step 'I fill field for value with "50"'
  find('#btn-add-param').click
  step 'I should see "Size" in variants table'
  find('#save').click
end

When /^I add a store to the product/ do
  store = Store.first
  @products[0].stores << store

  click_link "Add store"
  step 'I wait for "1" seconds'
  step "I select store \"#{store.Name}\" in popup"
  step 'I press button to add store'
  step "I should see \"#{store.Name}\" in stores table"
  find('#save').click
end

When /^I follow edit link for product in row "([^"]*)"$/ do |row|
  click_link page.find(:xpath, "//table[@id=\"product-table\"]/tbody/tr[#{row}]/td[13]").text
end

When /^I select category "([^"]*)" in popup/ do |category|
  page.find(:xpath, "//span[text()='#{category}']/parent::*/preceding-sibling::*[2]/img").click
end

When /^I select store "([^"]*)" in popup/ do |store|
  page.find(:xpath, "//td[@class=\"standartTreeRow\"]/span[text()=\"#{store}\"]/../../td[not(@class)]/img").click
end

When /^I press button to add category$/ do
  find('#btn-add-cat').click
end

When /^I press button to add variant$/ do
  find('#btn-add-param').click
end

When /^I press button to add store$/ do
  find('#btn-add-store').click
end

When /^I press save button$/ do
  find('#save').click
end

When /^I choose radio for brand$/ do
  find('#product_BrandType_2').click
end

When /^I choose radio for shipment category$/ do
  find('#product_ShipmentType_1').click
end

When /^I click on Add color$/ do
  find('#add-color').click
end

When /^I click on black color in popup$/ do
  page.all(:xpath, "//div[@id=\"jquery-colour-picker\"]/ul[1]/li[1]/a[1]")[0].click
end

When /^I fill field for value with "([^"]*)"$/ do |value|
  page.all(:xpath, "//div[@id=\"param-iframe\"]/div[2]/div[3]/div[2]/input[1]")[0].set value
end

Then /^I should see the saved product$/ do |category|
  page.all(:xpath, "//table[@id=\"t-category\"]/tbody/tr[1]/td[1]")[0].text.should == category
end

Then /^I should see "([^"]*)" in categories table$/ do |category|
  page.all(:xpath, "//table[@id=\"t-category\"]/tbody/tr[1]/td[1]")[0].text.should == category
end

Then /^I should see "([^"]*)" in colors table$/ do |color|
  page.all(:xpath, "//table[@id=\"t-color\"]/tbody/tr[1]/td[1]")[0].text.should == color
end

Then /^I should see "([^"]*)" in variants table$/ do |param|
  within('#t-param') do
    page.should have_content(param)
  end
end

Then /^I should see "([^"]*)" in stores table$/ do |store|
  within('#t-store') do
    page.should have_content(store)
  end
end

