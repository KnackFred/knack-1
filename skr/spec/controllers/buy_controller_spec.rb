require "spec_helper"

describe BuyController do
  describe "add to cart for order" do
    before(:each) do
      @registrant = Factory.create(:registrant)
      Registrant.stub(:find).and_return(@registrant)

      @registry_item = Factory.create(:registry_item, :registrant => @registrant, :Purchased_ID => RegistryItem::PURCHASED)

      @cart = Cart.new
      @buy_registry_item = BuyRegistryItem.new(@registry_item)
    end

    it "should redirect to signin if user not logged in" do
      get :buy_order, {:id => @registry_item.id}
      response.should redirect_to signin_path
    end

    it "should throw an exception if item not found" do
      RegistryItem.stub(:find).and_raise(ActiveRecord::RecordNotFound)
      lambda {
        get :buy_order, {:id => @registry_item.id}, {:cart => @cart, :registrant => @registrant.id}
      }.should raise_exception ActiveRecord::RecordNotFound
    end

    it "should throw an exception if item is deleted" do
      @registry_item.IsDeleted = true
      RegistryItem.stub(:find).and_return(@registry_item)
      lambda {
        get :buy_order, {:id => @registry_item.id}, {:cart => @cart, :registrant => @registrant.id}
      }.should raise_exception ActiveRecord::RecordNotFound
    end

    it "should throw an exception if item does not belong to this user" do
      @registry_item.registrant = Factory.create(:registrant)
      RegistryItem.stub(:find).and_return(@registry_item)
      lambda {
        get :buy_order, {:id => @registry_item.id}, {:cart => @cart, :registrant => @registrant.id}
      }.should raise_exception ActiveRecord::RecordNotFound
    end

    it "should route to an error page if the cart already has conflicting items in it." do
      Cart.should_receive(:valid_cart_for_buy?).and_return(false)

      get :buy_order, {:id => @registry_item.id}, {:cart => @cart, :registrant => @registrant.id}

      response.should redirect_to("/buy/errorpage/" + ErrorMessages::MIXED_CART.to_s)
    end

    context "post" do
      before(:each) do
        RegistryItem.stub(:find).and_return(@registry_item)
      end

      it "should create a new buy registry item with the supplied parameters and the registry item" do
        BuyRegistryItem.should_receive(:new).with(:type => BuyRegistryItem::ORDER, :item => @registry_item).and_return(@buy_registry_item)
        @buy_registry_item.stub(:valid?).and_return(true)
        post :buy_order, {:id => @registry_item.id}, {:registrant => @registrant.id, :cart => @cart}
      end

      it "if the item is valid, add it to the cart " do
        BuyRegistryItem.stub(:new).and_return(@buy_registry_item)
        @registry_item.stub(:update_attributes).and_return(true)
        @buy_registry_item.stub(:valid?).and_return(true)
        Cart.should_receive(:add_registry_item_to_cart).and_return true

        post :buy_order, {:id => @registry_item.id}, {:registrant => @registrant.id, :cart => @cart}

        assigns[:status].should == 2
        assigns[:param].should == @registry_item.id
        response.should render_template("shared/close_modal")
      end

      it "if the item is invalid, throw an exception" do
        BuyRegistryItem.stub(:new).and_return(@buy_registry_item)
        @registry_item.stub(:update_attributes).and_return(true)
        @buy_registry_item.stub(:valid?).and_return(false)

        lambda {
          post :buy_order, {:id => @registry_item.id}, {:registrant => @registrant.id, :cart => @cart}
        }.should raise_exception
      end

      it "if there is an error adding the item to the cart render an error page " do
        BuyRegistryItem.stub(:new).and_return(@buy_registry_item)
        @registry_item.stub(:update_attributes).and_return(true)
        @buy_registry_item.stub(:valid?).and_return(true)
        Cart.should_receive(:add_registry_item_to_cart).and_return false

        post :buy_order, {:id => @registry_item.id}, {:registrant => @registrant.id, :cart => @cart}

        response.should redirect_to("/buy/errorpage/" + ErrorMessages::ALREADY_IN_CART.to_s)
      end

    end
  end

###################################################################################################################

  describe "add to cart for exchange" do
    before(:each) do
      @registrant = Factory.create(:registrant)
      Registrant.stub(:find).and_return(@registrant)

      @registry_item = Factory.create(:registry_item_purchased, :registrant => @registrant)

      @cart = Cart.new
      #@cash = Cash.new(@registry_item)
    end

    it "should redirect to signin if user not logged in" do
      get :exchange, {:id => @registry_item.id}, {:cart => @cart}
      response.should redirect_to signin_path
    end

    it "should throw an exception if item not found" do
      RegistryItem.stub(:find).and_raise(ActiveRecord::RecordNotFound)
      lambda {
        get :exchange, {:id => @registry_item.id}, {:registrant => @registrant.id, :cart => @cart}
      }.should raise_exception ActiveRecord::RecordNotFound
    end

    it "should throw an exception if item is deleted" do
      @registry_item.IsDeleted = true
      RegistryItem.stub(:find).and_return(@registry_item)
      lambda {
        get :exchange, {:id => @registry_item.id}, {:registrant => @registrant.id, :cart => @cart}
      }.should raise_exception ActiveRecord::RecordNotFound
    end

    it "should throw an exception if item does not belong to this user" do
      @registry_item.registrant = Factory.create(:registrant)
      RegistryItem.stub(:find).and_return(@registry_item)
      lambda {
        get :exchange, {:id => @registry_item.id}, {:registrant => @registrant.id, :cart => @cart}
      }.should raise_exception ActiveRecord::RecordNotFound
    end

    it "should route to an error page if the cart already has conflicting items in it." do
      Cart.should_receive(:valid_cart_for_withdraw?).and_return(false)
      get :exchange, {:id => @registry_item.id}, {:registrant => @registrant.id, :cart => @cart}
      response.should redirect_to("/buy/errorpage/" + ErrorMessages::MIXED_CART.to_s)
    end

    context "registry item found" do
      before(:each) do
        RegistryItem.stub(:find).and_return(@registry_item)
      end

      it "should add the item to the cart for withdrawal" do
        Cart.should_receive(:add_item_for_withdrawal).and_return true

        get :exchange, {:id => @registry_item.id}, {:registrant => @registrant.id, :cart => @cart}
      end

      it "if successfully added to cart render close modal" do
        Cart.stub(:add_item_for_withdrawal).and_return true

        get :exchange, {:id => @registry_item.id}, {:registrant => @registrant.id, :cart => @cart}

        assigns[:status].should == 3
        assigns[:param].should == @registry_item.id
        response.should render_template("shared/close_modal")
      end

      it "if not successful added to cart render error" do
        Cart.stub(:add_item_for_withdrawal).and_return false

        get :exchange, {:id => @registry_item.id}, {:registrant => @registrant.id, :cart => @cart}

        response.should redirect_to("/buy/errorpage/" + ErrorMessages::ALREADY_IN_CART.to_s)
      end

    end

  end

###################################################################################################################
  describe "add to cart for buy from registry" do
    before(:each) do
      @registrant = Factory.create(:registrant)
      Registrant.stub(:find).and_return(@registrant)

      @registry_item = Factory.create(:registry_item, :registrant => @registrant)

      @cart = Cart.new
      @buy_registry_item = BuyRegistryItem.new(@registry_item)
    end

    it "should redirect to signin if user not logged in" do
      get :buy_available, {:id => @registry_item.id}
      response.should redirect_to signin_path
    end

    it "should throw an exception if item not found" do
      RegistryItem.stub(:find).and_raise(ActiveRecord::RecordNotFound)
      lambda {
        get :buy_available, {:id => @registry_item.id}, {:cart => @cart, :registrant => @registrant.id}
      }.should raise_exception ActiveRecord::RecordNotFound
    end

    it "should throw an exception if item is deleted" do
      @registry_item.IsDeleted = true
      RegistryItem.stub(:find).and_return(@registry_item)
      lambda {
        get :buy_available, {:id => @registry_item.id}, {:cart => @cart, :registrant => @registrant.id}
      }.should raise_exception ActiveRecord::RecordNotFound
    end

    it "should throw an exception if item does not belong to this user" do
      @registry_item.registrant = Factory.create(:registrant)
      RegistryItem.stub(:find).and_return(@registry_item)
      lambda {
        get :buy_available, {:id => @registry_item.id}, {:cart => @cart, :registrant => @registrant.id}
      }.should raise_exception ActiveRecord::RecordNotFound
    end

    it "should route to an error page if the cart already has conflicting items in it." do
      Cart.should_receive(:valid_cart_for_buy?).and_return(false)

      get :buy_available, {:id => @registry_item.id}, {:cart => @cart, :registrant => @registrant.id}

      response.should redirect_to("/buy/errorpage/" + ErrorMessages::MIXED_CART.to_s)
    end

    context "get" do

      it "should look up the registry and set it " do
        RegistryItem.should_receive(:find).with(@registry_item.id).and_return(@registry_item)
        get :buy_available, {:id => @registry_item.id}, {:cart => @cart, :registrant => @registrant.id}
        assigns[:registry_item].should == @registry_item
      end

      it "should render the contribute page " do
        RegistryItem.stub(:find).and_return(@registry_item)
        get :buy_available, {:id => @registry_item.id}, {:cart => @cart, :registrant => @registrant.id}
        response.should render_template("buy_available")
      end

    end

    context "post" do
      before(:each) do
        RegistryItem.stub(:find).and_return(@registry_item)
      end

      it "should create a new buy registry item with the supplied parameters and the registry item" do
        BuyRegistryItem.should_receive(:new).with(:type => BuyRegistryItem::BUY_REGISTRANT_FROM_REGISTRY, :item => @registry_item).and_return(@buy_registry_item)
        @buy_registry_item.stub(:valid?).and_return(true)
        post :buy_available, {:id => @registry_item.id, :registry_item => {:Quantity => 1}}, {:registrant => @registrant.id, :cart => @cart}
      end

      it "should set the quantity to match the value specified" do
        BuyRegistryItem.stub(:new).and_return(@buy_registry_item)
        @buy_registry_item.stub(:valid?).and_return(true)

        @registry_item.should_receive(:update_attributes).with(:Quantity => 5).and_return(true)

        post :buy_available, {:id => @registry_item.id, :registry_item => {:Quantity => 5}}, {:registrant => @registrant.id, :cart => @cart}
      end

      it "if quantity is invalid then re-render the page" do
        BuyRegistryItem.stub(:new).and_return(@buy_registry_item)
        @buy_registry_item.stub(:valid?).and_return(true)
        @registry_item.stub(:update_attributes).and_return(false)

        post :buy_available, {:id => @registry_item.id, :registry_item => {:Quantity => 5}}, {:registrant => @registrant.id, :cart => @cart}

        response.should render_template("buy_available")
      end


      it "if the item is valid, add it to the cart " do
        BuyRegistryItem.stub(:new).and_return(@buy_registry_item)
        @registry_item.stub(:update_attributes).and_return(true)
        @buy_registry_item.stub(:valid?).and_return(true)
        Cart.should_receive(:add_registry_item_to_cart).and_return true

        post :buy_available, {:id => @registry_item.id, :registry_item => {:Quantity => 1}}, {:registrant => @registrant.id, :cart => @cart}

        assigns[:status].should == 1
        assigns[:param].should == @registry_item.id
        response.should render_template("shared/close_modal")
      end

      it "if the item is invalid, raise an exception" do
        BuyRegistryItem.stub(:new).and_return(@buy_registry_item)
        @registry_item.stub(:update_attributes).and_return(true)
        @buy_registry_item.stub(:valid?).and_return(false)

        lambda {
          post :buy_available, {:id => @registry_item.id, :registry_item => {:Quantity => 1}}, {:registrant => @registrant.id, :cart => @cart}
        }.should raise_exception
      end

      it "if there is an error adding the item to the cart render an error page " do
        BuyRegistryItem.stub(:new).and_return(@buy_registry_item)
        @registry_item.stub(:update_attributes).and_return(true)
        @buy_registry_item.stub(:valid?).and_return(true)
        Cart.should_receive(:add_registry_item_to_cart).and_return false

        post :buy_available, {:id => @registry_item.id, :registry_item => {:Quantity => 1}}, {:registrant => @registrant.id, :cart => @cart}

        response.should redirect_to("/buy/errorpage/" + ErrorMessages::ALREADY_IN_CART.to_s)
      end

    end
  end

###################################################################################################################
  describe "add to cart for buy to himself" do
    before(:each) do
      @registrant = Factory.create(:registrant)
      Registrant.stub(:find).and_return(@registrant)

      @product = Factory.create(:product)

      @cart = Cart.new
      @buy_product = BuyProduct.new(:product => @product, :quantity => 1)
    end


    it "should route to an error page if the cart already has conflicting items in it." do
      Cart.should_receive(:valid_cart_for_buy?).and_return(false)

      post :buy_himself, {:product => @product.id}, {:cart => @cart, :registrant => @registrant.id}

      response.body.should == ErrorMessages::MIXED_CART.to_s
    end

    it "should throw a not found exception if product not found" do
      Product.stub(:find).and_raise(ActiveRecord::RecordNotFound)
      lambda {
        post :buy_himself, {:product => @product.id}, {:cart => @cart, :registrant => @registrant.id}
      }.should raise_exception ActiveRecord::RecordNotFound
    end

    it "should throw a not found exception if product is Deleted" do
      @product.IsDeleted = true
      Product.stub(:find).and_return(@product)
      lambda {
        post :buy_himself, {:product => @product.id}, {:cart => @cart, :registrant => @registrant.id}
      }.should raise_exception ActiveRecord::RecordNotFound
    end

    describe "create buy_product" do

      it "should create a new buy_product based on the product and quantity" do
        Product.should_receive(:find).and_return(@product)

        BuyProduct.should_receive(:new).with(:product => @product, :quantity => 12, :color_id => nil, :params => nil).and_return(@buy_product)

        post :buy_himself, {:product => @product.id, :quantity => 12}, {:cart => @cart}
      end

      it "should include color" do
        Product.stub(:find).and_return(@product)

        BuyProduct.should_receive(:new).with(:color_id => 4, :product => @product, :quantity => 12, :params => nil).and_return(@buy_product)

        post :buy_himself, {:product => @product.id, :quantity => 12, :color_id => 4}, {:cart => @cart}
      end

      it "should include product_params" do
        Product.stub(:find).and_return(@product)

        BuyProduct.should_receive(:new).with(:color_id => nil, :product => @product, :quantity => 12, :params => "['foo']").and_return(@buy_product)

        post :buy_himself, {:product_params => "['foo']",:product => @product.id, :quantity => 12}, {:cart => @cart}
      end
    end

    describe "place buy_product in cart" do
      before(:each) do
        Product.stub(:find).and_return(@product)
        BuyProduct.should_receive(:new).and_return(@buy_product)
      end

      it "if buy_product is invalid render a validation error message" do
        @buy_product.should_receive(:valid?).and_return(false)

        post :buy_himself, {:product => @product.id}, {:cart => @cart}
        response.body.should == ErrorMessages::VALIDATION.to_s
      end

      it "if buy_product is valid add it to the cart and return nothing (Which signifies success)" do
        @buy_product.should_receive(:valid?).and_return(true)
        Cart.should_receive(:add_product_to_cart).and_return(true)

        post :buy_himself, {:product => @product.id}, {:cart => @cart}
        response.body.should == " "
      end

      it "if there is an issue when adding it to the cart return an error)" do
        @buy_product.stub(:valid?).and_return(true)
        Cart.stub(:add_product_to_cart).and_return(false)

        post :buy_himself, {:product => @product.id}, {:cart => @cart}
        response.body.should == ErrorMessages::CUSTOM.to_s
      end

    end
  end

###################################################################################################################

  describe "add to cart for contribute" do
    before(:each) do
      @registrant = Factory.create(:registrant)
      Registrant.stub(:find).and_return(@registrant)

      @registry = Factory.create(:registrant)
      @registry_item = Factory.create(:registry_item, :registrant => @registry)

      @cart = Cart.new
      @buy_registry_item = BuyRegistryItem.new(@registry_item)
    end

    it "should throw an exception if item not found" do
      RegistryItem.stub(:find).and_raise(ActiveRecord::RecordNotFound)
      lambda {
        get :contribute, {:id => @registry_item.id}, {:giver => @cart}
      }.should raise_exception ActiveRecord::RecordNotFound
    end

    it "should throw an exception if item is deleted" do
      @registry_item.IsDeleted = true
      RegistryItem.stub(:find).and_return(@registry_item)
      lambda {
        get :contribute, {:id => @registry_item.id}, {:giver => @cart}
      }.should raise_exception ActiveRecord::RecordNotFound
    end

    it "should route to an error page if the cart already has conflicting items in it." do
      Cart.should_receive(:valid_cart_for_contribute?).and_return(false)

      get :contribute, {:id => @registry_item.id}, {:giver => @cart}

      response.should redirect_to("/buy/errorpage/" + ErrorMessages::MIXED_CART.to_s)
    end

    context "get" do
      before(:each) do
        RegistryItem.stub(:find).and_return(@registry_item)
      end

      it "should create a new buy_registry_item and set it" do
        BuyRegistryItem.should_receive(:new).with(:item => @registry_item, :type => BuyRegistryItem::CONTRIBUTE).and_return(@buy_registry_item)
        get :contribute, {:id => @registry_item.id}, {:giver => @cart}

        assigns[:registry_item].should == @registry_item
        assigns[:buy_registry_item].should == @buy_registry_item
      end

      it "should render the contribute page " do
        BuyRegistryItem.stub(:new).and_return(@buy_registry_item)
        get :contribute, {:id => @registry_item.id}, {:giver => @cart}
        response.should render_template("buy/contribute")
      end
    end

    context "post" do
      before(:each) do
        RegistryItem.stub(:find).and_return(@registry_item)
      end

      it "should create a new registry item with the supplied parameters and the registry item" do
        BuyRegistryItem.should_receive(:new).with(:type => BuyRegistryItem::CONTRIBUTE, :from => "from", :notes => "notes", :quantity => 1, :contribute => 10, :item => @registry_item).and_return(@buy_registry_item)
        @buy_registry_item.stub(:valid?).and_return(true)
        post :contribute, {:id => @registry_item.id, :buy_registry_item => {:from => "from", :notes => "notes", :contribute => 10, :quantity => 1}}, {:giver => Cart.new}
      end

      it "if the item is valid, add it to the cart " do
        BuyRegistryItem.stub(:new).and_return(@buy_registry_item)
        @buy_registry_item.stub(:valid?).and_return(true)
        Cart.should_receive(:add_registry_item_to_cart).and_return true

        post :contribute, {:id => @registry_item.id, :buy_registry_item => {:from => "from", :notes => "notes", :contribute => 10, :quantity => 1}}, {:giver => Cart.new}

        assigns[:status].should == 1
        assigns[:param].should == 0
        response.should render_template("shared/close_modal")
      end

      it "if the item is invalid, do not add the page and render the form again" do
        BuyRegistryItem.stub(:new).and_return(@buy_registry_item)
        @buy_registry_item.stub(:valid?).and_return(false)

        post :contribute, {:id => @registry_item.id, :buy_registry_item => {:from => "from", :notes => "notes", :contribute => 10, :quantity => 1}}, {:giver => Cart.new}

        response.should render_template("buy/contribute")
      end

      it "if there is an error adding the item to the cart render an error page " do
        BuyRegistryItem.stub(:new).and_return(@buy_registry_item)
        @buy_registry_item.stub(:valid?).and_return(true)
        Cart.should_receive(:add_registry_item_to_cart).and_return false

        post :contribute, {:id => @registry_item.id, :buy_registry_item => {:from => "from", :notes => "notes", :contribute => 10, :quantity => 1}}, {:giver => Cart.new}

        response.should redirect_to("/buy/errorpage/" + ErrorMessages::ALREADY_IN_CART.to_s)
      end

    end
  end

  ###################################################################################################################

  describe "buy an external item" do
    before(:each) do
      @params = {:quantity => "1", :from => "from", :notes => "Note", :email => "j@a.com"}

      @id = double("registry item id")
      @reg_item = double("registry_item")
      RegistryItem.stub(:find).and_return(@reg_item)

      @buy_reg_item = double("buy_registry_item")
      BuyRegistryItem.stub(:new).and_return(@buy_reg_item)
      @buy_reg_item.stub(:valid?).and_return(true)

      @order = double("order")
      Order.stub(:new).and_return(@order)
      @order.stub(:save).and_return(true)
      @order.stub(:buy_item_external).and_return(true)
    end

    it "if should get the registry item" do
      RegistryItem.should_receive(:find).with(@id).and_return(@reg_item)

      get :buy_ext, {:id => @id}

      assigns[:registry_item].should == @reg_item
    end

    context "GET" do

      it "if should create a new buy registry item with type external" do
        BuyRegistryItem.should_receive(:new).with(:item => @reg_item, :type => BuyRegistryItem::EXTERNAL).and_return(@reg_item)

        get :buy_ext, {:id => @id}

        assigns[:buy_registry_item].should == @reg_item
      end

      it "if should render the buy_ext template" do
        get :buy_ext, {:id => @id}

        response.should render_template("buy/buy_ext")
      end
    end

    context "POST" do

      it "if should create a new buy registry item with supplied data" do
        post :buy_ext, {:id => @id, :buy_registry_item => @params}

        assigns[:buy_registry_item].should == @buy_reg_item
      end

      it "if should validate the buy registry item" do
        @buy_reg_item.should_receive(:valid?)

        post :buy_ext, {:id => @id, :buy_registry_item => @params}
      end

      it "if should render the buy_ext template if there was a validation error" do
        @buy_reg_item.stub(:valid?).and_return(false)

        post :buy_ext, {:id => @id, :buy_registry_item => @params}

        response.should render_template("buy/buy_ext")
      end

      it "it should create an order" do
        Order.should_receive(:new).and_return(@order)

        post :buy_ext, {:id => @id, :buy_registry_item => @params}
      end

      it "it should execute the order" do
        @order.should_receive(:save).and_return(true)
        @order.should_receive(:buy_item_external).with(@buy_reg_item).and_return(true)

        post :buy_ext, {:id => @id, :buy_registry_item => @params}
      end

      it "it should the buy_ext template if there was an issue executing the error" do
        @order.should_receive(:save).and_return(true)

        post :buy_ext, {:id => @id, :buy_registry_item => @params}
      end

      it "if should render buy_ext_success if the purchase was successful " do
        post :buy_ext, {:id => @id, :buy_registry_item => @params}

        response.should render_template("buy/buy_ext_success")
      end

    end
  end
end