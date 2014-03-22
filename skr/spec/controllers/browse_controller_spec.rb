require "spec_helper"

describe BrowseController do
  describe "stores" do
    before(:each) do
      @category1 = Factory.create(:category)
      @category2 = Factory.create(:category)
      @category3 = Factory.create(:category)
      @category4 = Factory.create(:category)

      @store1 = Factory.create(:store, :category => @category1)
      @store2 = Factory.create(:store, :category => @category2)
      @store3 = Factory.create(:store, :category => @category3)

      3.times {
        product = Factory.create(:product)
        Factory.create(:products2store, :store => @store1, :product => product)
        Factory.create(:products2category, :category => @category1, :product => product)
      }
      2.times {
        product = Factory.create(:product)
        Factory.create(:products2store, :store => @store2, :product => product)
        Factory.create(:products2category, :category => @category2, :product => product)
      }
    end

    it "Should render the stores page" do
      Category.stub_chain(:with_stores, :includes).and_return([@category1, @category2])
      post :stores
      response.should render_template("stores")
    end
    
    it "should get the categories that have stores" do
      dbl = double("tmp double")
      Category.should_receive(:with_stores).and_return(dbl)
      dbl.should_receive(:includes).and_return([@category1, @category2])
      get :stores
      assigns[:categories].should == [@category1, @category2]
    end
  end

  ##############################################################
  describe "brands" do
    before(:each) do
      @brand1 = Factory.create(:brand)
      @brand2 = Factory.create(:brand)
      @brand3 = Factory.create(:brand)
      @category1 = Factory.create(:category)
      3.times {
        product = Factory.create(:product, :Brand_ID => @brand1.id)
        Factory.create(:products2category, :category => @category1, :product => product)
      }

      2.times {
        product = Factory.create(:product, :Brand_ID => @brand2.id)
        Factory.create(:products2category, :category => @category1, :product => product)
      }
    end

    it "Should render the brands page" do
      post :brands
      response.should render_template("brands")
    end

    it "should assign @array" do
      get :brands
      assigns[:array].should == [@brand1, @brand2]
    end

  end

  ##############################################################
  describe "catalog" do
    before(:each) do
      product_params = FindProductParams.new(2,1)
      product_params.value_left = 1
      product_params.value_right = 2
      product_params.max_price = 30.0
      product_params.min_price = 20.0
      session[:product_params] = product_params
      @category_root = Category.root
      @category1 = Factory.create(:category, :parent_id => @category_root.id)
      @category2 = Factory.create(:category, :parent_id => @category_root.id)
      @category3 = Factory.create(:category, :parent_id => @category_root.id)
      @product1 = Factory.create(:product, :categories => [@category1], :Name => 'Table', :MasterPrice => 10, :SalesPrice => nil, :priority => 50)
      @product2 = Factory.create(:product, :categories => [@category1], :Name => 'Apple', :MasterPrice => 20, :SalesPrice => 10, :priority => 49)
      @product3 = Factory.create(:product, :categories => [@category2], :Name => 'Nokia', :MasterPrice => 30, :SalesPrice => 20, :priority => 48)
      @product4 = Factory.create(:product, :categories => [@category2], :Name => 'HTC', :Description => "table", :MasterPrice => 30, :SalesPrice => nil, :priority => 47)
      @product5 = Factory.create(:product, :categories => [@category3], :Name => 'LG', :MasterPrice => 40, :SalesPrice => nil, :priority => 46)
      @store = Factory.create(:store)
    end
    
    it "Should render the catalog page" do
      post :catalog
      response.should render_template("catalog")
    end

    it "Should assign default params" do
      post :catalog
      assigns[:category].should == @category_root
      assigns[:valleft].should == 0
      assigns[:valright].should == 3
      assigns[:values].should == "10.0,20.0,30.0,40.0"
      assigns[:count_gifts].should == 5
      assigns[:products].should =~ [@product1, @product2, @product3, @product4, @product5]
      assigns[:findtext].should == 'Type gift name'
    end

    it "Should assigns params for category" do
      post :catalog, :id => @category1.id
      assigns[:category].should == @category1
      assigns[:valleft].should == 0
      assigns[:valright].should == 0
      assigns[:values].should == "10.0"
      assigns[:count_gifts].should == 2
      assigns[:products].should =~ [@product1, @product2]
    end

    it "Should assigns params for find text" do
      product_params = FindProductParams.new(1, 32, '', '')
      FindProductParams.stub(:new).with(1, 32, '', '').and_return(product_params)
      product_params.find_text = 'Table'
      product_params.value_left = 0
      product_params.value_right = 0
      ids = @category_root.get_ids_with_children
      Product.stub(:get_count_products).with('Table', product_params, ids).any_number_of_times.and_return(2)
      Product.stub(:get_product_prices).with('Table', product_params, ids).any_number_of_times.and_return([10.0, 30.0])
      Product.stub(:find_all_view_catalog).with('Table', product_params, ids).any_number_of_times.and_return([@product1, @product4])
      post :catalog, :findtext => 'Table'
      assigns[:category].should == @category_root
      assigns[:valleft].should == 0
      assigns[:valright].should == 1
      assigns[:values].should == "10.0,30.0"
      assigns[:count_gifts].should == 2
      assigns[:products].should == [@product1, @product4]
    end

    it "Should assigns params for price range" do
      post :catalog, {:valleft => 1, :valright => 2}
      assigns[:category].should == @category_root
      assigns[:valleft].should == 1
      assigns[:valright].should == 2
      assigns[:values].should == "10.0,20.0,30.0,40.0"
      assigns[:count_gifts].should == 2
      assigns[:products].should =~ [@product3, @product4]
    end

    it "Should assigns params with paging" do
      post :catalog, {:page => 2, :per_page => 2}
      assigns[:category].should == @category_root
      assigns[:valleft].should == 0
      assigns[:valright].should == 3
      assigns[:values].should == "10.0,20.0,30.0,40.0"
      assigns[:count_gifts].should == 5
      assigns[:products].should =~ [@product3, @product4]
    end

    it "Should assigns @store if request was for a store" do
      post :catalog, :param => 's', :valparam => @store.id
      assigns[:store].should == @store
    end

    it "Should not assign @store if request is not for a store" do
      post :catalog
      assigns[:store].should be_nil
    end

  end

  ##############################################################
  describe("search") do
    before(:each) do
#      `rake ts:start RAILS_ENV=test` if !ThinkingSphinx.sphinx_running?
      @json_search = Json_search.new
      @category1 = Factory.create(:category)
      @category2 = Factory.create(:category)
      @category3 = Factory.create(:category)
      @product1 = Factory.create(:product, :categories => [@category1], :Name => 'Table')
      @product2 = Factory.create(:product, :categories => [@category1], :Name => 'Apple')
      @product3 = Factory.create(:product, :categories => [@category2], :Name => 'Nokia')
      @product4 = Factory.create(:product, :categories => [@category2], :Name => 'HTC')
      @product5 = Factory.create(:product, :categories => [@category3], :Name => 'LG')
    end

    it 'should render json empty' do
      @json_search.query = 'sdasdfsdf'
      Product.stub(:search_by_name_and_brand).any_number_of_times.and_return([])
      get :search, {:cid => @category1.id, :query => @json_search.query}
      response.body.should == @json_search.to_json
    end

    it 'should render json with 1 product' do
      @json_search.query = 'htc'
      Product.stub(:search_by_name_and_brand).with('htc').any_number_of_times.and_return([@product4])
      get :search, {:cid => @category1.id, :query => @json_search.query}
      @json_search.suggestions << "#{@product4.categories.first.name} > #{@product4.Name}"
      @json_search.data << from_catalog_path(@category1.id, @product4.id, @product4.name_url)
      response.body.should == @json_search.to_json
    end

    it 'should render json with 2 product' do
      @json_search.query = 'Table'
      Product.stub(:search_by_name_and_brand).with('Table').any_number_of_times.and_return([@product1, @product4])
      get :search, {:cid => @category1.id, :query => @json_search.query}
      @json_search.suggestions << "#{@product1.categories.first.name} > #{@product1.Name}"
      @json_search.suggestions << "#{@product4.categories.first.name} > #{@product4.Name}"
      @json_search.data << from_catalog_path(@category1.id, @product1.id, @product1.name_url)
      @json_search.data << from_catalog_path(@category1.id, @product4.id, @product4.name_url)
      response.body.should == @json_search.to_json
    end
  end

  describe("suggest_products") do
    before(:each) do
      @text = "foo"
      @products = double("products")

      @products.stub(:each)
      @products.stub(:to_json).and_return("JSON")
      Product.stub(:search_by_name_and_brand).and_return(@products)

    end
    it 'should search for products using supplied text and with a limit of 4 and provide the result to the view' do

      Product.should_receive(:search_by_name_and_brand).with(@text, 4).and_return(@products)

      get :suggest_products, {:query => @text}
    end

    it 'should render JSONP response with the found items id, Name, Imageurl and Price,  ' do

      @products.should_receive(:to_json).with(hash_including(:only => [:id, :Name], :methods => [:Price, :small_thumb_url])).and_return("JSON")

      get :suggest_products, {:query => @text}

      response.body.should == 'knackLoadSuggestions(JSON);'
    end

  end

  ##############################################################
  describe("item") do
    before(:each) do
      @registrant = Factory.create(:registrant)
      @category_root = Category.root

      # Mocks, everything above is required for full stack testing and should be removed once the test are improved
      @cat_id = double("Category ID")
      @category = double("Category")
      Category.stub(:find).and_return(@category)
      @store = double("Store")
      @partner = double("Partner")
      @store.stub(:partner).and_return(@partner)

      @product_id = double("Product ID")

      @product = double("Product")

      Product.stub(:find).and_return @product

      @product.stub(:available?).and_return(true)
      @product.stub(:increment!)
      @product.stub(:write_all_image)
      @product.stub(:productimage).and_return([])
      @product.stub(:get_default_store).and_return(@store)


    end

    it "should set registrant if the registrant is logged in" do
      Registrant.stub(:find).and_return(@registrant)
      get :item, {:c => @cat_id, :id => @product_id}, {'registrant' => @registrant.id}
      assigns[:registrant].should == @registrant
    end

    it "Should find the product" do
      Product.should_receive(:find).and_return @product
      get :item, {:c => @cat_id, :id => @product_id}
    end

    it "Should raise a record not found exception if product not found" do
      Product.stub(:find).and_raise(ActiveRecord::RecordNotFound)
      lambda {
        get :item, {:c => @cat_id, :id => @product_id}
      }.should raise_exception ActiveRecord::RecordNotFound
    end

    context "Product Found" do
      before(:each) do
        Product.should_receive(:find).and_return(@product)
        Product.stub(:available?).and_return(true)
      end

      it "Should increment the view count on the product" do
        @product.should_receive(:increment!).with(:count_view)
        get :item, {:c => @cat_id, :id => @product_id}
      end

      it "Should assign param product" do
        get :item, {:c => @cat_id, :id => @product_id}
        assigns[:product].should == @product
      end

      it "Should render the item template" do
        get :item, {:c => @cat_id, :id => @product_id}
        response.should render_template("item")
      end

      it "Should set brand if the item is navigated to from a brand page" do
        brand_id = double("brand ID")
        brand = double("Brand")

        Brand.should_receive(:find).with(brand_id).and_return(brand)

        get :item, {:b => brand_id, :id => @product_id}

        assigns[:brand].should == brand
      end

      it "Should set store and partner if the item is navigated to from a store page" do
        store_id = double("Store ID")
        store = double("Store")
        partner = double("Partner")

        Store.should_receive(:find).with(store_id).and_return(store)
        store.should_receive(:partner).and_return(partner)

        get :item, {:s => store_id, :id => @product_id}

        assigns[:store].should == store
        assigns[:partner].should == partner
      end

      it "Should set partner for item if the item was not navigated to from a store page" do

        @product.should_receive(:get_default_store).and_return(@store)
        @store.should_receive(:partner).and_return(@partner)

        get :item, {:c => @cat_id, :id => @product_id}

        assigns[:store].should be_nil
        assigns[:partner].should == @partner
      end

      it "Should raise a record not found exception if product is no longer available (And it's not being visited from a registry)'" do
        @product.should_receive(:available?).and_return(false)
        lambda {
          get :item, {:c => @cat_id, :id => @product_id}
        }.should raise_exception ActiveRecord::RecordNotFound
      end

      context "Item is from a registry" do

        before (:each) do
          @registry_item_id = 47
          @registry_item = double("Registry Item")
          RegistryItem.stub(:find).and_return @registry_item
          @registry_item.stub(:IsDeleted?).and_return(false)
          @registry_item.stub(:id).and_return(@registry_item_id)

          @registry_id = 4747
          @registry = double("Registry")
          Registrant.stub(:find).and_return @registry
          @registry.stub(:write_image)
          @registry.stub(:IsDeleted?).and_return(false)
        end

        it "Should find the registry" do
          Registrant.should_receive(:find).with(@registry_id).and_return(@registry)

          get :item, {:c => @cat_id, :id => @product_id, :r => @registry_id, :r2p => @registry_item_id}

          assigns[:registry].should == @registry
        end

        it "Should find the registry item" do
          RegistryItem.should_receive(:find).with(@registry_item_id).and_return(@registry_item)

          get :item, {:c => @cat_id, :id => @product_id, :r => @registry_id, :r2p => @registry_item_id}

          assigns[:registry].should == @registry
        end

        it "Should check if the item is already in the cart." do
          Cart.should_receive(:registry_item_in_cart?).and_return(true)
          get :item, {:c => @cat_id, :id => @product_id, :r => @registry_id, :r2p => @registry_item_id}
          assigns[:in_cart].should == true
        end

        it "Should render the item template" do
          get :item, {:c => @cat_id, :id => @product_id}
          response.should render_template("item")
        end

        context "Registry Error Conditions" do
          it "Should raise a record not found exception if registry not found" do
            Registrant.stub(:find).and_raise ActiveRecord::RecordNotFound
            lambda {
              get :item, {:c => @cat_id, :id => @product_id, :r => @registry_id, :r2p => @registry_item_id}
            }.should raise_exception ActiveRecord::RecordNotFound
          end

          it "Should raise a record not found exception for a deleted registry" do
            Registrant.stub(:find).and_return @registry
            @registry.stub(:IsDeleted?).and_return(true)
            lambda {
              get :item, {:c => @cat_id, :id => @product_id, :r => @registry_id, :r2p => @registry_item_id}
            }.should raise_exception ActiveRecord::RecordNotFound
          end

          it "Should raise a record not found exception if the registry_item is not found" do
            RegistryItem.stub(:find).and_raise ActiveRecord::RecordNotFound
            lambda {
              get :item, {:c => @cat_id, :id => @product_id, :r => @registry_id, :r2p => @registry_item_id}
            }.should raise_exception ActiveRecord::RecordNotFound
          end

          it "Should raise a record not found exception if the registry_item is deleted" do
            RegistryItem.stub(:find).and_return @registry_item
            @registry_item.stub(:IsDeleted?).and_return(true)
            lambda {
              get :item, {:c => @cat_id, :id => @product_id, :r => @registry_id, :r2p => @registry_item_id}
            }.should raise_exception ActiveRecord::RecordNotFound
          end

          it "Should not raise a record not found exception for registry item where product is no longer available" do
            @product.stub(:available?).and_return(false)
            lambda {
              get :item, {:c => @cat_id, :id => @product_id, :r => @registry_id, :r2p => @registry_item_id}
            }.should_not raise_exception ActiveRecord::RecordNotFound
          end
        end
      end
    end
  end

  describe "feed" do
    before (:each) do
      @reg = double("registrant")
      @reg_id = double("registrant ID")
      Registrant.stub(:find).and_return(@reg)
      @reg.stub(:id).and_return(@reg_id)

      @results = double("registry item results")
      @results.stub(:paginate).and_return(@results)

      RegistryItem.stub(:get_feed_items).and_return(@results)
    end

    it "should look up feed items" do
      RegistryItem.should_receive(:get_feed_items).and_return(@results)

      get :feed, {}, {:registrant => @reg_id}

      assigns[:registry_items].should == @results
    end

    it "should pass registrant to query and assign @registrant " do
      RegistryItem.should_receive(:get_feed_items).with(anything, @reg, anything).and_return(@results)

      get :feed, {}, {:registrant => @reg_id}

      assigns[:registrant].should == @reg
    end

    it "should assign a category to the hot category" do
      get :feed, {}, {:registrant => @reg_id}

      assigns[:category].should == Category.hot
    end

    it "should accept a filter, and pass it to the model" do
      filter = double("filter")
      RegistryItem.should_receive(:get_feed_items).with(filter, anything, anything).and_return(@results)

      get :feed, {:filter => filter}, {:registrant => @reg_id}
    end

    it "should accept a site, pass it to the model, and set it as a param" do
      site = double("site")
      RegistryItem.should_receive(:get_feed_items).with(anything, anything, site).and_return(@results)

      get :feed, {:site => site}, {:registrant => @reg_id}

      assigns[:site].should == site
    end

  end
end

