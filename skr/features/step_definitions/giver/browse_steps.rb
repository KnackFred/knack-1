## General items

Given /^I have "([^"]*)" categories? in "([^"]*)" category$/ do |count, root_name|
  root_category = Category.find_by_name(root_name)
  @categories = Array.new
  count.to_i.times{
    @categories << Factory.create(:category, :parent => root_category)
  }
end

Given /^I have a category named "([^"]*)" in "([^"]*)" category$/ do |category_name, root_name|
  @parent_category = Category.find_by_name(root_name)
  @categories = [Factory.create(:category, :parent_id => @parent_category.id, :name => category_name)]
end

Given /^I have "([^"]*)" stores? in each categories$/ do |count_stores|
  @stores_by_categories = Array.new
  @categories.each do |category|
    @stores = Array.new
    count_stores.to_i.times{
      @stores << Factory.create(:store, :category => category)
    }
    @stores_by_categories << @stores
  end
end

Given /^I have "([^"]*)" brands$/ do |count_brands|
  @brands = Array.new
  1.upto(count_brands.to_i){ |i|
    @brands << Factory.create(:brand)
  }
end

Given /^I have a brand named "([^"]*)"$/ do |brand_name|
  @brands = [Factory.create(:brand, :Name => brand_name)]
end

Given /^I have a brand named "([^"]*)" with "(\d+)" products? in it$/ do |brand_name, product_count|
  @brands = [Factory.create(:brand, :Name => brand_name)]
  Factory.create_list(:product, product_count.to_i, :brand => @brands[0])
end

Given /^I have a store named "([^"]*)" in one category$/ do |store_name|
  @stores_by_categories = Array.new
  partner = Factory.create(:partner)
  @stores_by_categories << @stores = [Factory.create(:store, :Name => store_name, :category => @categories.first, :partner => partner, :IsDefault => true)]
end

Given /^I have "(\d+)" products? in one store from each category stores$/ do |count_products|
  @categories.each_with_index do |category, i|
    count_products.to_i.times { |j|
      product = Factory.create(:product, :Name => "Test product #{10*i + j}", :MasterPrice => 100*i + j*10, :SalesPrice => nil)
      Factory.create(:products2category, :product => product, :category => category)
      Factory.create(:products2store, :product => product, :store => @stores_by_categories[i].first)
    }
  end
end

Given /^I have products? with the following attributes in one store and one category stores$/ do |table|
  table.hashes.each_with_index do |hash, i|
    unless hash['Brand'].nil?
      brand = Brand.find_by_Name(hash['Brand'])
      brand = Factory.create(:brand, :Name => hash['Brand']) if brand.nil?
    end
    product = Factory.create(:product, :categories => [@categories.first], :stores => [@stores_by_categories.first.first], :Name => hash['Name'], :Description => hash['Description'], :brand =>  brand, :MasterPrice => 100*i + 10, :SalesPrice => nil)
  end
end

Given /^I have "(\d+)" products?$/ do |count_products|
  @products = Array.new
  1.upto(count_products.to_i){ |i|
    product = Factory.create(:product)
    @products << product
  }
end

Given /^(?:I have|There is) a product named "([^"]*)"$/ do |name|
  @products = [Factory.create(:product_with_params, :Name => name)]
end

Given /^There is a cash product named "([^"]*)"$/ do |name|
  reg = Factory.create(:registrant)
  @products = [Factory.create(:cash_product, :Name => name, :Registrant_ID => reg.id)]
end

Given /^I have product "([^"]*)" with priority "([^"]*)"$/ do |name, priority|
  product = Factory.create(:product, :Name => name, :MasterPrice => 100, :SalesPrice => nil, :ShipmentType => 3, :priority => priority)
end

Given /^I have products? with priority$/ do |table|
  @products ||= []
  table.hashes.each do |hash|
    product = Factory.create(:product, :Name => hash[:Name], :MasterPrice => 100, :SalesPrice => nil, :ShipmentType => Product::FREE, :priority => hash[:Priority])
    @products << product
  end
end

Given /^I have "(\d+)" products? in each brand$/ do |count_products|
  @products ||= []
  @brands.each do |brand|
    count_products.to_i.times {
      product = Factory.create(:product, :brand => brand)
      @products << product
    }
  end
end

When /^I shift the "([^"]*)" slider by "([^"]*)" positions$/ do |slide, value|
  case slide
    when 'left'
      index_slide = 0
    when 'right'
      index_slide = 1
    else
      throw("No Match")
  end
  page.execute_script "s=$('#slider-range-min');"
  page.execute_script "s.slider('values', #{index_slide}, [#{value}]);"
  page.execute_script "s.slider('option', 'stop').call(s,null,{ handle: $('.ui-slider-handle', s), values: [#{value}, $('#valright').val()]});"
end

When /^I click "([^"]*)" category with "([^"]*)" products$/ do |index_category, count_products|
  click_link("#{@categories[index_category.to_i-1].Name}(#{count_products})")
end

When /^I click the first product$/ do
  find('.productTR:first-child > .productTDH:first-child > a').click
end

When /^I visit the item page for "([^"]*)" product and "([^"]*)" category$/ do |id_product, id_category|
  visit from_catalog_path(id_category,id_product)
end

When /^I visit the item page for the first product$/ do
  visit from_catalog_path(Category.root.id ,@products[0].id)
end

When /^I click "([^"]*)" in category menu$/ do |name|
  case name
    when 'Essentials'
      find('#essent-div').click
    when 'Experiences'
      find('#exper-div').click
    when 'Unique Items'
      find('#unique-div').click
    when 'Bridal Party'
      find('#bridal-div').click
    else
      throw("No Match")
  end
end

When /^I press button "BACK TO CATALOG"$/ do
  find('#btn-backtocatalog').click
end

When /^I press the buy button$/ do
  if page.has_selector?("#buynow")
    find("#buynow").click
  elsif page.has_selector?(".btn-proceed")
    find("#btn-contribute").click
  else
    throw "Can not find button"
  end
  sleep(1)
end

When /^I press button "ADD TO REGISTRY"$/ do
  find('#addtoregistry').click
  When 'I wait until all Ajax requests are complete'
end

When /^I press button "BUY NOW"$/ do
  find("#buynow").click
end

Then /^I should see "([^"]*)" products$/ do |count|
  page.should have_css('td.productTDH', :count => count.to_i)
end

Then /^I should see "([^"]*)" product name$/ do |index|
  page.should have_content(@products[index.to_i-1].Name)
end

Then /^I should see drop-down block with "([^"]*)" products$/ do |count|
  page.should have_css('.autocomplete>div', :count => count.to_i)
end

Then /^I should not see drop-down block$/ do
  page.should_not have_css('.autocomplete>div')
end

Then /^I should see "([^"]*)" stores? from each category$/ do |count_stores|
  within_frame "ifr-popup" do
    @categories.each_with_index do |category, i|
      1.upto(count_stores.to_i){ |j|
        page.should have_link("#{@stores_by_categories[i][j-1].Name}")
      }
    end
  end
end

Then /^I should see "([^"]*)" action and no others$/ do |type_user|
  case type_user
    when 'buy'
      page.should have_selector('#buynow')
      page.should have_no_selector('#addtoregistry')
      page.should have_no_selector('#btn-contribute')
    when 'contribute'
      page.should have_selector('#btn-contribute')
      page.should have_no_selector('#addtoregistry')
      page.should have_no_selector('#buynow')
    when 'buy and add'
      page.should have_selector('#addtoregistry')
      page.should have_selector('#buynow')
      page.should have_no_selector('#btn-contribute')
    when 'no'
      page.should have_no_selector('#addtoregistry')
      page.should have_no_selector('#buynow')
      page.should have_no_selector('#btn-contribute')
    else
      throw("No Match")
  end
  page.should have_selector('#btn-backtocatalog')
end

Then /^I should see the how does knack work section$/ do
  page.should have_selector('.div-howd')

end

Then /^I should not see the how does knack work section$/ do
  page.should have_no_selector('.div-howd')
end

Then /^I should see the registry info/ do
  page.should have_selector('.div-registrantimage')
end

Then /^I should not see the registry info$/ do
  page.should have_no_selector('.div-registrantimage')
end



require "nokogiri"
require "pp"

Then /^I should see products in that order$/ do |expected_table|
  expected_table.hashes.each_with_index do |hash, index|
    tr = index.div(4) + 1
    td = index % 4 + 1
    page.find(:xpath, "//table[@id='tableProducts']/tbody/tr[#{tr}]/td[#{td}]/table/tbody/tr[2]/td[1]/div/b").text.strip.should have_content(hash['Name'])
  end
end

When /^I should see store bio for "([^"]*)"$/ do |store_name|
  page.should have_selector('.partnerBlock', :content => store_name)
end

When /^I follow the Brand Link$/ do
  find('#brand-link').click
end

Then /^I should see variant "([^"]*)" with value "([^"]*)"$/ do |name, value|
  within_frame 'ifr-popupBuy' do
    response.should have_select("product_params_"+name, :Selected => value)
  end
end

Then /^I should see "(\d+)" brands in the pop-up$/ do |count_brands|
  within_frame "ifr-popup" do
    if count_brands == "0"
      page.should have_no_css(".brand")
    else
      page.should have_css(".brand", :count => count_brands)
    end
  end
end
