require "spec_helper"

describe Product do
  ###############################
  ## VALIDATIONS
  ###############################
  describe "Validations" do

    it "should allow the product to be created" do
      expect {
        object = Factory.build(:product)
        object.save!()
      }.to change { Product.count }.by(1)
    end

    it "should allow two product to be created" do
      expect {
        object = Factory.build(:product)
        object.save!()
        object2 = Factory.build(:product)
        object2.save!()
      }.to change { Product.count }.by(2)
    end

    ###############################
    ## Name Validations
    ###############################
    it "should not allow the product to be create without a Name " do

      object = Factory.build(:product)
      object.Name = nil
      object.should_not be_valid

    end

    it "should not allow the product to be create with a blank Name " do
      object = Factory.build(:product)
      object.Name = ""
      object.should_not be_valid
    end

    it "should allow the product to be created with max length Name" do
      expect {
        object = Factory.build(:product)
        object.Name = ("a" * 50)
        object.save!()
      }.to change { Product.count }.by(1)
    end

    it "should not allow the product to be created with max length +1 Name" do
      object = Factory.build(:product)
      object.Name = ("a" * 51)
      object.should_not be_valid
    end

    ###############################
    ## Master Price Validations
    ###############################
    it "should not allow the product to be create without a Master Price " do
      object = Factory.build(:product)
      object.MasterPrice = nil
      object.should_not be_valid
    end

    it "should not allow the product to be create with a blank Master Price " do
      object = Factory.build(:product)
      object.MasterPrice = ""
      object.should_not be_valid
    end

    it "should not allow the product to be create with not valid Master Price1 " do
      object = Factory.build(:product)
      object.MasterPrice = -1
      object.should_not be_valid
    end

    it "should allow the product to be created with valid Master Price1 " do
      expect {
        object = Factory.build(:product)
        object.MasterPrice = 10.12
        object.save!()
      }.to change { Product.count }.by(1)
    end

    it "should allow the product to be created with valid Master Price2 " do
      expect {
        object = Factory.build(:product)
        object.MasterPrice = 10.1225426
        object.save!()
      }.to change { Product.count }.by(1)
    end

    ###############################
    ## Sales Price Validations
    ###############################
    it "should allow the product to be create without a Sales Price " do
      object = Factory.build(:product)
      object.SalesPrice = nil
      object.should be_valid
    end

    it "should not allow the product to be create with a blank Sales Price " do
      object = Factory.build(:product)
      object.SalesPrice = ""
      object.should be_valid
    end

    it "should not allow the product to be create with not valid Sales Price1 " do
      object = Factory.build(:product)
      object.SalesPrice = -1
      object.should_not be_valid
    end

    it "should allow the product to be created with valid Master Sales1 " do
      expect {
        object = Factory.build(:product)
        object.SalesPrice = 10.12
        object.save!()
      }.to change { Product.count }.by(1)
    end

    it "should allow the product to be created with valid Master Sales2 " do
      expect {
        object = Factory.build(:product)
        object.SalesPrice = 10.1225426
        object.save!()
      }.to change { Product.count }.by(1)
    end

    ###############################
    ## ProductStatus_ID Validations
    ###############################
    it "should not allow the product to be created without a ProductStatus_ID" do
        object = Factory.build(:product, :ProductStatus_ID => nil)
        object.should_not be_valid
    end

    it "should not allow the product to be created with non-numeric ProductStatus_ID" do
        object = Factory.build(:product, :ProductStatus_ID => "a" )
        object.should_not be_valid
    end

    it "should not allow the product to be created with negative ProductStatus_ID" do
        object = Factory.build(:product, :ProductStatus_ID => -12 )
        object.should_not be_valid
    end

    it "should not allow the product to be created with max+1 ProductStatus_ID" do
        object = Factory.build(:product, :ProductStatus_ID => 4 )
        object.should_not be_valid
    end

    ###############################
    ## ShipmentType Validations
    ###############################
    it "should not allow the product to be created without a ShipmentType" do
        object = Factory.build(:product, :ShipmentType => nil)
        object.save.should be_false
    end

    it "should not allow the product to be created with non-numeric ShipmentType" do
        object = Factory.build(:product, :ShipmentType => "a" )
        object.save.should be_false
    end

    it "should not allow the product to be created with negative ShipmentType" do
        object = Factory.build(:product, :ShipmentType => -12 )
        object.save.should be_false
    end
    
    it "should not allow the product to be created with min - 1 ShipmentType " do
        object = Factory.build(:product, :ShipmentType => 0 )
        object.save.should be_false
    end
    
    it "should not allow the product to be created with max + 1 ShipmentType " do
        object = Factory.build(:product, :ShipmentType => 4 )
        object.save.should be_false
    end

    ###############################
    ## ShipmentCategory_ID Validations
    ###############################
    it "should not allow the product to be created without a ShipmentCategory_ID  when ShipmentType = STANDARD" do
        object = Factory.build(:product, :ShipmentCategory_ID => nil, :ShipmentType => Product::STANDARD)
        object.should_not be_valid
    end

    it "should not allow the product to be created with non-numeric ShipmentCategory_ID  when ShipmentType is STANDARD" do
        object = Factory.build(:product, :ShipmentCategory_ID => "a", :ShipmentType => Product::STANDARD )
        object.should_not be_valid
    end

    it "should not allow the product to be created with negative ShipmentCategory_ID  when ShipmentType is STANDARD" do
        object = Factory.build(:product, :ShipmentCategory_ID => -12, :ShipmentType => Product::STANDARD )
        object.should_not be_valid
    end

    it "should allow the product to be created without a ShipmentCategory_ID when ShipmentType = CUSTOM" do
        object = Factory.build(:product, :ShipmentCategory_ID => nil, :ShipmentCost => 12, :ShipmentType => Product::CUSTOM)
        object.should be_valid
    end

    ###############################
    ## Brand_ID Validations
    ###############################
    it "should allow the product to be created without a Brand_ID" do
        object = Factory.build(:product, :Brand_ID => nil)
        object.should be_valid
    end

    it "should not allow the product to be created with non-numeric Brand_ID" do
        object = Factory.build(:product, :Brand_ID => "a" )
        object.should_not be_valid
    end

    it "should not allow the product to be created with negative Brand_ID" do
        object = Factory.build(:product, :Brand_ID => -12 )
        object.should_not be_valid
    end

    ###############################
    ## Description Validations
    ###############################
    it "should not allow the product to be created without an Description " do
      object = Factory.build(:product, :Description => nil)
      object.should_not be_valid
    end

    it "should allow the product to be created with an empty Description " do
      object = Factory.build(:product, :Description => "")
      object.should be_valid
    end

    it "should allow the product to be created with max length Description" do
      expect {
        object = Factory.build(:product, :Description => ("a" * 900))
        object.save!()
      }.to change { Product.count }.by(1)
    end

    it "should not allow the product to be created with max length +1 Description" do
      object = Factory.build(:product, :Description => ("a" * 901))
      object.should_not be_valid
    end

    ###############################
    ## Priority Validations
    ###############################
    it "should not allow the product to be created without a priority" do
        object = Factory.build(:product, :priority => nil)
        object.should_not be_valid
    end

    it "should not allow the product to be created with non-numeric priority" do
        object = Factory.build(:product, :priority => "a" )
        object.should_not be_valid
    end

    it "should not allow the product to be created with negative priority" do
        object = Factory.build(:product, :priority => -12 )
        object.should_not be_valid
    end

    ###############################
    ## ShipmentCost Validations
    ###############################
    it "should allow the product to be created without ShipmentCost in case not 'Add My Own Gift'" do
        object = Factory.build(:cash_product, :ShipmentCost => nil)
        object.should be_valid
    end

    it "should allow the product to be created with not valid ShipmentCost in case not 'Add My Own Gift'" do
        object = Factory.build(:cash_product, :ShipmentCost => -1)
        object.should be_valid
    end

    it "should not allow the product to be created without ShipmentCost when ShipmentType = custom" do
        object = Factory.build(:product, :Registrant_ID => nil, :ShipmentCost => nil, :ShipmentType => Product::CUSTOM)
        object.should_not be_valid
    end

    it "should not allow the product to be created with not valid ShipmentCost when ShipmentType = custom" do
        object = Factory.build(:product, :Registrant_ID => nil, :ShipmentCost => -1, :ShipmentType => Product::CUSTOM)
        object.should_not be_valid
    end

    it "should allow the product to be created with ShipmentCost when ShipmentType = custom" do
        object = Factory.build(:product, :Registrant_ID => nil, :ShipmentCost => 1.1, :ShipmentType => Product::CUSTOM)
        object.should be_valid
    end

    it "should allow the product to be created with not valid ShipmentCost in case 'Add My Own Gift when not use tax'" do
        registrant = Factory.create(:registrant)
        category = Factory.create(:category)
        object = Factory.build(:product, :ShipmentType => Product::CUSTOM, :Registrant_ID => registrant.id, :ShipmentCost => -1 )
        object.should_not be_valid
    end

    it "should not allow the product to be created with not ShipmentCost sales_tax in case 'Add My Own Gift when use tax'" do
        registrant = Factory.create(:registrant)
        category = Factory.create(:category)
        object = Factory.build(:product, :ShipmentType => Product::CUSTOM, :Registrant_ID => registrant.id, :ShipmentCost => -1 )
        object.should_not be_valid
    end

    it "should allow the product to be created with ShipmentCost in case 'Add My Own Gift when use tax'" do
        registrant = Factory.create(:registrant)
        category = Factory.create(:category)
        object = Factory.build(:product, :ShipmentType => Product::CUSTOM, :Registrant_ID => registrant.id, :ShipmentCost => 1 )
        object.should be_valid
    end

    ###############################
    ## source name
    ###############################
    it "should allow a product not to have a source name" do
      object = Factory.build(:product, :source_name => nil)
      object.should be_valid
    end

    it "should allow a product to have a source name up to 50 characters" do
      object = Factory.build(:product, :source_name => ("n"*50))
      object.should be_valid
    end

    it "should not allow a product to have a source name over 50 characters" do
      object = Factory.build(:product, :source_name => ("n"*51))
      object.save.should be_false
    end

    ###############################
    ## source url
    ###############################
    it "should allow a product not to have a source url" do
      object = Factory.build(:product, :source_url => nil)
      object.should be_valid
    end

    it "should allow a product to have a source url up to 1024 characters" do
      object = Factory.build(:product, :source_url => ("n"*1024))
      object.should be_valid
    end

    it "should not allow a product to have a source url over 1024 characters" do
      object = Factory.build(:product, :source_url => ("n"*1025))
      object.should_not be_valid
    end

  end

  ###############################
  ## TYPE
  ###############################
  describe "type" do

    it "should correctly indicate if a product is a cash gift" do
      registrant = Factory.create(:registrant)
      category = Factory.create(:category)
      product1 = Factory.create(:product, :Registrant_ID => registrant.id)
      product1.cash?.should be_true
    end

    it "should correctly indicate if a product is not a cash gift" do
      product1 = Factory.create(:product)
      product1.cash?.should be_false
    end

    it "should correctly indicate if a product is a unique gift" do
      product1 = Factory.create(:product, :IsKind => true)
      product1.unique?.should be_true
    end

    it "should correctly indicate if a product is not a unique gift" do
      product1 = Factory.create(:product, :IsKind => false)
      product1.unique?.should be_false
    end

  end

  ###############################
  ## SALES
  ###############################
  it "should the product not sale" do
    object = Factory.create(:product, :SalesPrice => nil)
    object.is_sales?.should == false
  end

  it "should the product sale" do
    object = Factory.create(:product, :SalesPrice => 10.10)
    object.is_sales?.should == true
  end

  ###############################
  ## PRICE
  ###############################
  it "should the product Price == Master Price" do
    object = Factory.create(:product, :SalesPrice => nil, :MasterPrice => 15.01)
    object.Price.should == 15.01
  end

  it "should the product Price == Sales Price" do
    object = Factory.create(:product, :SalesPrice => 10.10, :MasterPrice => 15.01)
    object.Price.should == 10.10
  end

  ###############################
  ## SHIPMENT
  ###############################
  it "should the product Shipment == Shipment Category" do
    object = Factory.create(:product_standard_shipping, :per_shipment => 11.01)
    object.Shipment.should == 11.01
  end

  it "should the product Shipment == Shipment Cost" do
    object = Factory.create(:product, :ShipmentType => Product::CUSTOM, :ShipmentCost => 15.01)
    object.Shipment.should == 15.01
  end

  it "should the product Shipment == 0" do
    object = Factory.create(:product, :ShipmentType => Product::FREE)
    object.Shipment.should == 0
  end

  ###############################
  ## PARTNER
  ###############################
  it "partner should the nil for product when no stores" do
    object = Factory.create(:cash_product)
    object.get_partner_id.should == nil
  end

  it "should the partner id for product " do
    partner = Factory.create(:partner)
    store = Factory.create(:store, :partner => partner)

    object = Factory.create(:product, :stores => [store])
    object.get_partner_id.should == partner.id
  end

  ###############################
  ## Product status
  ###############################
  it "should the product status name == Available" do
    object = Factory.create(:product, :ProductStatus_ID => 1)
    object.product_status.Name.should == "Available"
  end

  it "should the product status name == Not Available" do
    object = Factory.create(:product, :ProductStatus_ID => 2)
    object.product_status.Name.should == "Not approved"
  end

  it "should the product status name == Pending" do
    object = Factory.create(:product, :ProductStatus_ID => 3)
    object.product_status.Name.should == "Pending"
  end

  ###############################
  ## available?
  ###############################
  it "product is available if it is not deleted and status is available" do
    object = Factory.build(:product, :IsDeleted => false, :ProductStatus_ID => ProductStatus::AVAILABLE)
    object.available?.should be_true
  end

  it "product is not available if it is deleted" do
    object = Factory.build(:product, :IsDeleted => true, :ProductStatus_ID => ProductStatus::AVAILABLE)
    object.available?.should be_false
  end

  it "product is not available if its' status is pending" do
    object = Factory.build(:product, :IsDeleted => false, :ProductStatus_ID => ProductStatus::PENDING)
    object.available?.should be_false
  end

  it "product is not available if its' status is Not Approved" do
    object = Factory.build(:product, :IsDeleted => false, :ProductStatus_ID => ProductStatus::NOT_APPROVED)
    object.available?.should be_false
  end

  it "unique product is available if it has not been added to another registry" do
    object = Factory.build(:product, :IsKind => true, :IsKindView => true, :IsDeleted => false, :ProductStatus_ID => ProductStatus::AVAILABLE)
    object.available?.should be_true
  end

  it "unique product is not available if it has been order or added to another registry" do
    object = Factory.build(:product, :IsKind => true, :IsKindView => false, :IsDeleted => false, :ProductStatus_ID => ProductStatus::AVAILABLE)
    object.available?.should be_false
  end

  ###############################
  ## Cash
  ###############################
  it "should the product Cash true" do
    registrant = Factory.create(:registrant)
    category = Factory.create(:category)
    object = Factory.create(:product, :Registrant_ID => registrant.id)
    object.cash?.should == true
  end

  it "should the product Cash false" do
    object = Factory.create(:product, :Registrant_ID => nil)
    object.cash?.should == false
  end

  ###############################
  ## Unique
  ###############################
  it "should the product unique true" do
    object = Factory.create(:product, :IsKind => true)
    object.unique?.should == true
  end

  it "should the product unique false" do
    object = Factory.create(:product, :IsKind => false)
    object.unique?.should == false
  end

  ###############################
  ## Get category
  ###############################
  it "should be the shipment category for product " do
    category = Factory.create(:category)
    object = Factory.create(:product, :ShipmentType => 1, :ShipmentCategory_ID => category.id)
    object.get_category.should == category
  end

  it "should be the first category for product if no shipping category set." do
    category1 = Factory.create(:category)
    category2 = Factory.create(:category)
    product = Factory.create(:product, :ShipmentType => 3, :categories => [category1, category2])
    product.get_category.should == category1
  end

  it "should be nil for product wth free shipping" do
    object = Factory.create(:cash_product, :ShipmentType => Product::FREE)
    object.get_category.should == nil
  end

  ###############################
  ## Get name for url
  ###############################
  it "should the product correct name for url " do
    object = Factory.create(:product, :Name => 'Test product.test sfdfd')
    object.name_url.should == 'Test+product.test+sfdfd'
  end

  ###############################
  ## Selected
  ###############################
  it 'should count Selected for product' do
    product = Factory.create(:product)
    product.Selected.should == 0
    index = 5
    1.upto(index) { |i|
      Factory.create(:registry_item, :product => product, :Purchased_ID => RegistryItem::AVAILABLE)
    }
    product.Selected.should == index
  end

  ###############################
  ## Purchased
  ###############################
  it 'should count Purchased for product' do
    product = Factory.create(:product)
    product.Purchased.should == 0
    index = 5
    1.upto(index) { |i|
      Factory.create(:registry_item, :product => product, :Purchased_ID => RegistryItem::PURCHASED)
    }
    product.Purchased.should == index
  end

  ###############################
  ## Ordered
  ###############################
  it 'should count Ordered for product' do
    product = Factory.create(:product)
    product1 = Factory.create(:product)
    index = 5
    1.upto(index) { |i|
      Factory.create(:orders2product, :product => product)
      registry_item = Factory.create(:registry_item, :product => product, :Purchased_ID => RegistryItem::PURCHASED)
      Factory.create(:registry_item, :product => product1, :Purchased_ID => RegistryItem::PURCHASED)
      Factory.create(:orders2registry_item, :registry_item => registry_item, :Contribute_ID => nil, :IsGetMoney => 0)
    }
    product.Ordered.should == index*2
  end

  ###############################
  ## PROPERTIES
  ###############################
  describe "Properties" do
    before(:each) do
      @product_params = FindProductParams.new(1, 9999999)
      @brand = Factory.create(:brand)
      @partner = Factory.create(:partner)
      @store = Factory.create(:store, :partner => @partner)
      @state = State.first
      @category = Factory.create(:category)
      @category1 = Factory.create(:category, :parent_id => @category.id)
      @products = Array.new
      10.times do |i|
        index = i + 1
        sales_price = index % 2 == 0 ? index*10 - 5 : nil
        product = Factory.create(:product, :stores => [@store], :categories => [@category, @category1], :Brand_ID => @brand.id, :MasterPrice => index*10, :SalesPrice => sales_price)
        @products << product
      end
    end

    ###############################
    ## STORE
    ###############################
    it "should the nil store for product" do
      object = Factory.create(:product)
      object.get_default_store.should == nil
    end

    it "should the default store for product" do
      store_default = Factory.create(:store, :partner => @partner, :IsDefault => true)
      object = Factory.create(:product, :stores => [store_default])
      object.get_default_store.should == store_default
    end

    ###############################
    ## tax price
    ###############################
    it "Tax should be zero if the product is not in the state" do
      store_default = Factory.create(:store, :partner => @partner, :state => @state, :IsDefault => true)
      product = Factory.create(:product, :MasterPrice => 20, :SalesPrice => nil, :stores => [store_default])
      product.tax(@state.id+1).should == 0
    end

    it "should set the product tax == the tax rate for the state of the default store." do
      store_default = Factory.create(:store, :partner => @partner, :state => @state, :IsDefault => true)
      product = Factory.create(:product, :MasterPrice => 20, :SalesPrice => nil, :stores => [store_default])

      product.tax(@state.id).should == @state.GeneralTax
    end

    ###############################
    ## Is Local
    ###############################
    it "should the local product for the registrant " do
      registrant = Factory.create(:registrant, :State_ID => @state.id)
      store_default = Factory.create(:store, :partner => @partner, :IsDefault => true, :state => @state)
      object = Factory.create(:product, :stores => [store_default])
      object.local?(registrant).should == true
    end

    it "should the not local product for the registrant " do
      state = State.last
      registrant = Factory.create(:registrant, :State_ID => state.id)
      store_default = Factory.create(:store, :partner => @partner, :IsDefault => true, :state => @state)
      object = Factory.create(:product, :stores => [@store])
      object.local?(registrant).should == false
    end

    it "should the not local product when registrant_id not specified " do
      object = Factory.create(:product)
      object.local?.should == false
    end

    ###############################
    ## Knack Fee
    ###############################
    it "should the product knack fee price == Price * 0.15" do
      object = Factory.create(:product, :IsKind => true, :MasterPrice => 15, :SalesPrice => nil)
      object.knack_fee.should == 2.25
    end

    it "should the product knack fee price == Price * 0.1" do
      object = Factory.create(:product, :IsKind => false, :MasterPrice => 15, :SalesPrice => nil)
      object.knack_fee.should == 1.5
    end

    ###############################
    ## Get Total Amount
    ###############################
    it "should the product total amount " do
      @state.update_attribute(:GeneralTax, 11.01)
      store_default = Factory.create(:store, :partner => @partner, :state => @state, :IsDefault => true)
      object = Factory.create(:product, :MasterPrice => 20, :SalesPrice => nil, :ShipmentType => 2, :ShipmentCost => 20, :stores => [store_default])
      object.total(1, @state.id).should == 42.21
      object.total(2, @state.id).should == 84.41
      object.total(2, @state.id+1).should == 80
    end

    it 'should products visible in the catalog with pager' do
      Product.find_all_view_catalog('', @product_params).should == @products
      @product_params.per_page = 5
      Product.find_all_view_catalog('', @product_params).should == @products.take(5)
    end

    it 'should products visible in the catalog by stores' do
      @product_params.param = 's'
      @product_params.param_value = @store.id
      Product.find_all_view_catalog('', @product_params).should =~ @products
      @product_params.param_value = @store.id+1
      Product.find_all_view_catalog('', @product_params).should == []
    end

    it 'should products visible in the catalog by brand' do
      @product_params.param = 'b'
      @product_params.param_value = @brand.id
      (Product.find_all_view_catalog('', @product_params) - @products).should == []
      @product_params.param_value = @brand.id+1
      Product.find_all_view_catalog('', @product_params).should == []
    end

    it 'should products visible in the catalog by range prices' do
      @product_params.min_price = 0
      @product_params.max_price = 999999
      Product.find_all_view_catalog('', @product_params).should == @products
      @product_params.min_price = 999999
      @product_params.max_price = 999999
      Product.find_all_view_catalog('', @product_params).should == []
      @product_params.min_price = 15
      @product_params.max_price = 35
      Product.find_all_view_catalog('', @product_params).should == @products.find_all {|x|
        x.Price >= @product_params.min_price && x.Price <= @product_params.max_price}
    end

    ###############################
    ## Get count products
    ###############################
    it 'should count products visible in the catalog' do
      Product.get_count_products.should == @products.count
    end

    it 'should count products visible in the catalog by entry name (Test)' => true do
      Product.should_receive(:get_count_products).with('Test').any_number_of_times.and_return(@products.count)
    end

    it 'should count products visible in the catalog by entry name (1) ' => true do
      Product.should_receive(:get_count_products).with('1').any_number_of_times.and_return(@products.count { |p| p.Name.include? '1' })
    end

    it 'should 0 products visible in the catalog' do
      Product.should_receive(:get_count_products).with('sdfdfsfs').any_number_of_times.and_return(0)
    end

    it 'should count products visible in the catalog with pager' do
      Product.get_count_products('', @product_params).should == @products.count
      @product_params.per_page = 5
      Product.get_count_products('', @product_params).should == @products.count
    end

    it 'should count products visible in the catalog by stores' do
      @product_params.param = 's'
      @product_params.param_value = @store.id
      Product.get_count_products('', @product_params).should == @products.count
      @product_params.param_value = @store.id+1
      Product.get_count_products('', @product_params).should == 0
    end

    it 'should count products visible in the catalog by brand' do
      @product_params.param = 'b'
      @product_params.param_value = @brand.id
      Product.get_count_products('', @product_params).should == @products.count
      @product_params.param_value = @brand.id+1
      Product.get_count_products('', @product_params).should == 0
    end

    it 'should count products visible in the catalog by range prices' do
      @product_params.min_price = 0
      @product_params.max_price = 999999
      Product.get_count_products('', @product_params).should == @products.count
      @product_params.min_price = 999999
      @product_params.max_price = 999999
      Product.get_count_products('', @product_params).should == 0
      @product_params.min_price = 15
      @product_params.max_price = 35
      Product.get_count_products('', @product_params).should == @products.count {|x|
        x.Price >= @product_params.min_price && x.Price <= @product_params.max_price}
    end

    ###############################
    ## Get count view catalog
    ###############################
    it 'should count all products visible in the catalog' do
      Product.get_count_view_catalog.should == @products.count
    end

  end
end