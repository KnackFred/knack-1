

Given /^I am an authenticated administrator on productlist page$/ do
  Given 'I am an authenticated administrator'
  Given 'I go to the administrator products page'
end

Then /^I should see "([^"]*)" rows? in the products table$/ do |row_count|
  expected = row_count.to_i
  actual = page.all(:xpath, '//table[@id="product-table"]/tbody/tr').size
  raise("Exception! Expected #{expected} rows, but got #{actual}") unless expected == actual
end

Then /^I should see edit for the product$/ do
  product = @products[0]
  URI.parse(current_url).path.should == "/admin/products/#{product.id}/edit"
  find_field("product_Name").value.should == product.Name
  find_field("product_MasterPrice").value.to_f.should == product.MasterPrice
  find_field("product_SalesPrice").value.to_f.should == product.SalesPrice
  find_field("product_Description").value.should == product.Description
  find_field("product_priority").value.to_i.should == product.priority
  find_field("product_ProductStatus_ID").value.to_i.should == product.ProductStatus_ID
  find_field("product[Brand_ID]").value.to_i.should == (product.Brand_ID.blank? ? 0 : product.Brand_ID)
  product.categories.each do |cat|
    step "I should see \"#{cat.name}\" in categories table"
  end
  product.colors.each do |color|
    step "I should see \"#{color.Name}\" in colors table"
  end
  product.product_params.each do |param|
    step "I should see \"#{param.Name}\" in variants table"
  end
  product.stores.each do |store|
    step "I should see \"#{store.Name}\" in stores table"
  end

end

Then /^I should see edit for the saved product$/ do
  page.should have_content "Product Updated"
  step "I should see edit for the product"
end

Given /^I have products? with the following statuses$/ do |table|
  table.hashes.each do |hash|
    product = Factory.create(:product, :ProductStatus_ID => hash['product_status'])
  end
end

Given /^I have products? with the following prices$/ do |table|
  table.hashes.each do |hash|
    Factory.create(:product, :MasterPrice => hash['master_price'], :SalesPrice => hash['sales_price'])
  end
end

Given /^I have "([^"]*)" products in category "([^"]*)"$/ do |number, category|
  cat = Category.find_by_name(category)
  cat ||= Factory.create(:category, :name => category)
  number.to_i.times do
    product = Factory.create(:product)
    Factory.create(:products2category, :product => product, :category => cat)
  end
end

Given /^There are "([^"]*)" cash products$/ do |number|
  number.to_i.times do
    Factory.create(:cash_product)
  end
end

Given /^There are "([^"]*)" catalog products$/ do |number|
  number.to_i.times do
    Factory.create(:product)
  end
end

Then /^I should see rows in the products table sorted by price$/ do
  page.all(:xpath, '//table[@id="product-table"]/tbody/tr[1]/td[5]')[0].text.should == '$10.00'
  page.all(:xpath, '//table[@id="product-table"]/tbody/tr[2]/td[5]')[0].text.should == '$20.00'
  page.all(:xpath, '//table[@id="product-table"]/tbody/tr[3]/td[5]')[0].text.should == '$30.00'
end

Given /^I have products selected to registries at following quantities$/ do |table|
  @registrant = Factory.create(:registrant)
  table.hashes.each do |hash|
    product = Factory.create(:product, :Name => hash['name'])
    hash['quantity'].to_i.times { Factory.create( :registry_item, :IsDeleted => false,
                                                  :Purchased_ID => RegistryItem::AVAILABLE,
                                                  :product => product,
                                                  :registrant => @registrant) }
  end
end

Then /^I should see rows in the products table sorted low-high$/ do
  page.all(:xpath, '//table[@id="product-table"]/tbody/tr[1]/td[2]')[0].text.should == 'product3'
  page.all(:xpath, '//table[@id="product-table"]/tbody/tr[2]/td[2]')[0].text.should == 'product1'
  page.all(:xpath, '//table[@id="product-table"]/tbody/tr[3]/td[2]')[0].text.should == 'product2'
end

Given /^I have products purchased at following quantities$/ do |table|
  @registrant = Factory.create(:registrant)
  table.hashes.each do |hash|
    product = Factory.create(:product, :Name => hash['name'])
    hash['quantity'].to_i.times { Factory.create( :registry_item, :IsDeleted => false,
                                                  :Purchased_ID => RegistryItem::PURCHASED,
                                                  :product => product,
                                                  :registrant => @registrant) }
  end
end

Given /^I have products ordered at following quantities$/ do |table|
  @order = Factory.create(:order)
  table.hashes.each do |hash|
    product = Factory.create(:product, :Name => hash['name'])
    hash['quantity'].to_i.times { Factory.create( :orders2product, :product => product, :order => @order ) }
  end
end

Given /^I have products with the following priorities$/ do |table|
  table.hashes.each do |hash|
    product = Factory.create(:product, :Name => hash['name'], :priority =>  hash['priority'])
  end
end





