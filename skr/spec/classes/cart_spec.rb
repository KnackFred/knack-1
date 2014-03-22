require "spec_helper"
###############################
## METHODS Cart class
###############################
describe Cart do
  before(:each) do
    @registrant = Factory.create(:registrant)
    Registrant.stub(:find).and_return(@registrant)
    @category_root = Category.root
    @category1 = Factory.create(:category, :parent_id => @category_root.id)
    @product1 = Factory.create(:product, :categories => [@category1], :Name => 'Table', :MasterPrice => 100, :SalesPrice => nil, :ShipmentType => Product::CUSTOM, :ShipmentCost => 15)
    @product2 = Factory.create(:product, :categories => [@category1], :Name => 'Apple', :MasterPrice => 200, :SalesPrice => 100, :ShipmentType => Product::CUSTOM, :ShipmentCost => 20)
    @product3 = Factory.create(:product, :categories => [@category1], :Name => 'Nokia', :MasterPrice => 300, :SalesPrice => 200, :ShipmentType => Product::CUSTOM, :ShipmentCost => 25)
    @registry_item1 = Factory.create(:registry_item, :registrant => @registrant, :product => @product1,
                                      :Purchased_ID => RegistryItem::AVAILABLE,
                                      :Price => 100, :Tax => 100, :Shipment => 100)
    Factory.create(:contribute, :registry_item => @registry_item1, :Contribute => 150)
    @purchased_registry_item1 = Factory.create(:registry_item, :registrant => @registrant, :product => @product2,
                                      :Purchased_ID => RegistryItem::PURCHASED,
                                      :Price => 100, :Tax => 100, :Shipment => 100, :Contributed => 150)                                      
    @purchased_registry_item2 = Factory.create(:registry_item, :registrant => @registrant, :product => @product3, 
                                      :Purchased_ID => RegistryItem::PURCHASED,
                                      :Price => 100, :Tax => 100, :Shipment => 100, :Contributed => 200)                                      
    Factory.create(:contribute, :registry_item => @purchased_registry_item2, :Contribute => 300)
    @cart = Cart.new
    @session = Hash.new
  end

###################################################################################################################
  describe "is registrant?" do
    it "should false if not authenticated user" do
      @session[:giver] = @cart
      Cart.is_registrant?(@session).should be_false
    end
  
    it "should true if authorized user" do
      @session[:cart] = @cart
      @session[:registrant] = @registrant.id
      Cart.is_registrant?(@session).should be_true
    end
  end
###################################################################################################################
  describe "get cart" do
    it "should get empty cart for not authenticated user" do
      @session[:giver] = @cart
      Cart.get_cart(@session).should == @cart
      Cart.get_cart(@session).should == @session[:giver]
      Cart.get_cart(@session).should_not == @session[:cart]
    end
  
    it "should get empty cart for authenticated user" do
      @session[:cart] = @cart
      @session[:registrant] = @registrant.id
      Cart.get_cart(@session).should == @cart
      Cart.get_cart(@session).should_not == @session[:giver]
      Cart.get_cart(@session).should == @session[:cart]
    end
  end
###################################################################################################################
  describe "set cart" do
    it "should update cart in session for not authenticated user" do
      @session[:giver] = @cart
      cart = Cart.get_cart(@session)
      Cart.set_cart(@session, cart)
      Cart.get_cart(@session).should == cart
      Cart.get_cart(@session).should == @session[:giver]
      Cart.get_cart(@session).should_not == @session[:cart]
    end

    it "should update cart in session for authenticated user" do
      @session[:cart] = @cart
      @session[:registrant] = @registrant.id
      cart = Cart.get_cart(@session)
      Cart.set_cart(@session, cart)
      Cart.get_cart(@session).should == cart
      Cart.get_cart(@session).should_not == @session[:giver]
      Cart.get_cart(@session).should == @session[:cart]
    end
  end
###################################################################################################################
  describe "is buy?" do
    it "should false for empty cart" do
      Cart.is_buy?(@cart).should be_false
    end

    it "should true, when in cart exists item for buy himself" do
      @session[:giver] = @cart
      @session[:giver].products = [BuyProduct.new(:product => @product1)]
      cart = Cart.get_cart(@session)
      Cart.is_buy?(cart).should be_true
    end

    it "should false, when in cart exists item for contribute to someone" do
      @session[:giver] = @cart
      @session[:giver].registry_items = [BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::CONTRIBUTE)]
      cart = Cart.get_cart(@session)
      Cart.is_buy?(cart).should be_false
    end

    it "should true, when in cart exists item for buy from registry" do
      @session[:cart] = @cart
      @session[:cart].registry_items = [BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::BUY_REGISTRANT_FROM_REGISTRY)]
      @session[:registrant] = @registrant.id
      cart = Cart.get_cart(@session)
      Cart.is_buy?(cart).should be_true
    end

    it "should true, when in cart exists item for order" do
      @session[:cart] = @cart
      @session[:cart].registry_items = [BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::ORDER)]
      @session[:registrant] = @registrant.id
      cart = Cart.get_cart(@session)
      Cart.is_buy?(cart).should be_true
    end

    it "should false, when in cart exists item for exchange" do
      @session[:cart] = @cart
      @session[:cart].withdraw_amount = 12
      @session[:cart].withdraw_ids = [1]
      @session[:registrant] = @registrant.id
      cart = Cart.get_cart(@session)
      Cart.is_buy?(cart).should be_false
    end
  end
###################################################################################################################
  describe "is contribute?" do
    it "should false for empty cart" do
      Cart.is_contribute?(@cart).should be_false
    end

    it "should false, when in cart exists item for buy himself" do
      @session[:giver] = @cart
      @session[:giver].products = [BuyProduct.new(:product => @product1)]
      cart = Cart.get_cart(@session)
      Cart.is_contribute?(cart).should be_false
    end

    it "should true, when in cart exists item for contribute to someone" do
      @session[:giver] = @cart
      @session[:giver].registry_items = [BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::CONTRIBUTE)]
      cart = Cart.get_cart(@session)
      Cart.is_contribute?(cart).should be_true
    end

    it "should false, when in cart exists item for buy from registry" do
      @session[:cart] = @cart
      @session[:cart].registry_items = [BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::BUY_REGISTRANT_FROM_REGISTRY)]
      @session[:registrant] = @registrant.id
      cart = Cart.get_cart(@session)
      Cart.is_contribute?(cart).should be_false
    end

    it "should false, when in cart exists item for order" do
      @session[:cart] = @cart
      @session[:cart].registry_items = [BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::ORDER)]
      @session[:registrant] = @registrant.id
      cart = Cart.get_cart(@session)
      Cart.is_contribute?(cart).should be_false
    end

    it "should false, when in cart exists item for exchange" do
      @session[:cart] = @cart
      @session[:cart].withdraw_amount = 12
      @session[:cart].withdraw_ids = [1]
      @session[:registrant] = @registrant.id
      cart = Cart.get_cart(@session)
      Cart.is_contribute?(cart).should be_false
    end
  end
###################################################################################################################
  describe "is withdraw?" do
    it "should false for empty cart" do
      Cart.is_withdraw?(@cart).should be_false
    end

    it "should false, when in cart exists item for buy himself" do
      @session[:giver] = @cart
      @session[:giver].products = [BuyProduct.new(:product => @product1)]
      cart = Cart.get_cart(@session)
      Cart.is_withdraw?(cart).should be_false
    end

    it "should false, when in cart exists item for contribute to someone" do
      @session[:giver] = @cart
      @session[:giver].registry_items = [BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::CONTRIBUTE)]
      cart = Cart.get_cart(@session)
      Cart.is_withdraw?(cart).should be_false
    end

    it "should false, when in cart exists item for buy from registry" do
      @session[:cart] = @cart
      @session[:cart].registry_items = [BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::BUY_REGISTRANT_FROM_REGISTRY)]
      @session[:registrant] = @registrant.id
      cart = Cart.get_cart(@session)
      Cart.is_withdraw?(cart).should be_false
    end

    it "should false, when in cart exists item for order" do
      @session[:cart] = @cart
      @session[:cart].registry_items = [BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::ORDER)]
      @session[:registrant] = @registrant.id
      cart = Cart.get_cart(@session)
      Cart.is_withdraw?(cart).should be_false
    end

    it "should true, when in cart exists item for exchange" do
      @session[:cart] = @cart
      @session[:cart].withdraw_amount = 12
      @session[:cart].withdraw_ids = [1]
      @session[:registrant] = @registrant.id
      cart = Cart.get_cart(@session)
      Cart.is_withdraw?(cart).should be_true
    end
  end 
###################################################################################################################
  describe "is empty cart?" do
    it "should true (empty cart)" do
      @session[:giver] = @cart
      Cart.is_empty_cart?(@session).should be_true
    end

    it "should false, when in cart exists item for buy himself" do
      @session[:giver] = @cart
      @session[:giver].products = [BuyProduct.new(:product => @product1)]

      Cart.is_empty_cart?(@session).should be_false
    end

    it "should false, when in cart exists item for contribute to someone" do
      @session[:giver] = @cart
      @session[:giver].registry_items = [BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::CONTRIBUTE)]
                                              
      Cart.is_empty_cart?(@session).should be_false
    end
    
    it "should false, when in cart exists item for buy from registry" do
      @session[:cart] = @cart
      @session[:cart].registry_items = [BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::BUY_REGISTRANT_FROM_REGISTRY)]
      @session[:registrant] = @registrant.id
                                              
      Cart.is_empty_cart?(@session).should be_false
    end
  
    it "should false, when in cart exists item for order" do
      @session[:cart] = @cart
      @session[:cart].registry_items = [BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::ORDER)]
      @session[:registrant] = @registrant.id
                                              
      Cart.is_empty_cart?(@session).should be_false
    end
  
    it "should false, when in cart exists item for exchange" do
      @session[:cart] = @cart
      @session[:cart].withdraw_amount = 12
      @session[:cart].withdraw_ids = [1]
      @session[:registrant] = @registrant.id
                                              
      Cart.is_empty_cart?(@session).should be_false
    end
  end
###################################################################################################################
  describe "empty cart" do
    it "should update cart in session for not authenticated user" do
      @session[:giver] = @cart
      cart = Cart.get_cart(@session)
      cart.products = [BuyProduct.new(:product => @product1)]
      Cart.set_cart(@session, cart)
      Cart.is_empty_cart?(@session).should be_false
      Cart.empty_cart(@session)
      Cart.is_empty_cart?(@session).should be_true
    end

    it "should update cart in session for not authenticated user" do
      @session[:cart] = @cart
      @session[:registrant] = @registrant.id
      cart = Cart.get_cart(@session)
      cart.products = [BuyProduct.new(:product => @product1)]
      Cart.set_cart(@session, cart)
      Cart.is_empty_cart?(@session).should be_false
      Cart.empty_cart(@session)
      Cart.is_empty_cart?(@session).should be_true
    end
  end
###################################################################################################################
  describe "valid cart for contribute?" do
    it "should true for empty cart" do
      Cart.valid_cart_for_contribute?(@session).should be_true
    end

    it "should false, when in cart exists item for buy himself" do
      @session[:giver] = @cart
      @session[:giver].products = [BuyProduct.new(:product => @product1)]
      Cart.valid_cart_for_contribute?(@session).should be_false
    end

    it "should true, when in cart exists item for contribute to someone" do
      @session[:giver] = @cart
      @session[:giver].registry_items = [BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::CONTRIBUTE)]
      Cart.valid_cart_for_contribute?(@session).should be_true
    end

    it "should false, when in cart exists item for buy from registry" do
      @session[:cart] = @cart
      @session[:cart].registry_items = [BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::BUY_REGISTRANT_FROM_REGISTRY)]
      @session[:registrant] = @registrant.id
      Cart.valid_cart_for_contribute?(@session).should be_false
    end

    it "should false, when in cart exists item for order" do
      @session[:cart] = @cart
      @session[:cart].registry_items = [BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::ORDER)]
      @session[:registrant] = @registrant.id
      Cart.valid_cart_for_contribute?(@session).should be_false
    end

    it "should false, when in cart exists item for exchange" do
      @session[:cart] = @cart
      @session[:cart].withdraw_amount = 12
      @session[:cart].withdraw_ids = [1]
      @session[:registrant] = @registrant.id
      Cart.valid_cart_for_contribute?(@session).should be_false
    end
  end
###################################################################################################################
  describe "valid cart for buy?" do
    it "should true for empty cart" do
      Cart.valid_cart_for_buy?(@session).should be_true
    end

    it "should true, when in cart exists item for buy himself" do
      @session[:giver] = @cart
      @session[:giver].products = [BuyProduct.new(:product => @product1)]
      Cart.valid_cart_for_buy?(@session).should be_true
    end

    it "should false, when in cart exists item for contribute to someone" do
      @session[:giver] = @cart
      @session[:giver].registry_items = [BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::CONTRIBUTE)]
      Cart.valid_cart_for_buy?(@session).should be_false
    end

    it "should true, when in cart exists item for buy from registry" do
      @session[:cart] = @cart
      @session[:cart].registry_items = [BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::BUY_REGISTRANT_FROM_REGISTRY)]
      @session[:registrant] = @registrant.id
      Cart.valid_cart_for_buy?(@session).should be_true
    end

    it "should true, when in cart exists item for order" do
      @session[:cart] = @cart
      @session[:cart].registry_items = [BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::ORDER)]
      @session[:registrant] = @registrant.id
      Cart.valid_cart_for_buy?(@session).should be_true
    end

    it "should false, when in cart exists item for exchange" do
      @session[:cart] = @cart
      @session[:cart].withdraw_amount = 12
      @session[:cart].withdraw_ids = [1]
      @session[:registrant] = @registrant.id
      Cart.valid_cart_for_buy?(@session).should be_false
    end
  end
###################################################################################################################
  describe "valid cart for withdraw?" do
    it "should true for empty cart" do
      @session[:registrant] = @registrant.id
      Cart.valid_cart_for_withdraw?(@session).should be_true
    end

    it "should false, when in cart exists item for buy himself" do
      @session[:cart] = @cart
      @session[:cart].products = [BuyProduct.new(:product => @product1)]
      @session[:registrant] = @registrant.id
      Cart.valid_cart_for_withdraw?(@session).should be_false
    end

    it "should false, when in cart exists item for contribute to someone" do
      @session[:cart] = @cart
      @session[:cart].registry_items = [BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::CONTRIBUTE)]
      @session[:registrant] = @registrant.id
      Cart.valid_cart_for_withdraw?(@session).should be_false
    end

    it "should false, when in cart exists item for buy from registry" do
      @session[:cart] = @cart
      @session[:cart].registry_items = [BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::BUY_REGISTRANT_FROM_REGISTRY)]
      @session[:registrant] = @registrant.id
      Cart.valid_cart_for_withdraw?(@session).should be_false
    end

    it "should false, when in cart exists item for order" do
      @session[:cart] = @cart
      @session[:cart].registry_items = [BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::ORDER)]
      @session[:registrant] = @registrant.id
      Cart.valid_cart_for_withdraw?(@session).should be_false
    end

    it "should true, when in cart exists item for exchange" do
      @session[:cart] = @cart
      @session[:cart].withdraw_amount = 12
      @session[:cart].withdraw_ids = [1]
      @session[:registrant] = @registrant.id
      Cart.valid_cart_for_withdraw?(@session).should be_true
    end
  end

###################################################################################################################
  describe "registry item in cart?" do
    it "should false for empty cart" do
      @session[:registrant] = @registrant.id
      Cart.registry_item_in_cart?(@session, @registry_item1.id).should be_false
    end

    it "should true, when item is in cart for exchange" do
      @session[:registrant] = @registrant.id
      Cart.add_item_for_withdrawal(@session, @registry_item1)
      Cart.add_item_for_withdrawal(@session, @purchased_registry_item1)

      Cart.registry_item_in_cart?(@session, @registry_item1.id).should be_true
    end

    it "should false, when only other items are in the cart for exchange" do
      @session[:registrant] = @registrant.id
      Cart.add_item_for_withdrawal(@session, @registry_item1)
      Cart.add_item_for_withdrawal(@session, @purchased_registry_item1)

      Cart.registry_item_in_cart?(@session, @purchased_registry_item2.id).should be_false
    end
    
    it "should true, when item is in cart for any other reason" do
      @session[:registrant] = @registrant.id
      Cart.add_registry_item_to_cart(@session, @registry_item1)
      Cart.add_registry_item_to_cart(@session, @purchased_registry_item1)

      Cart.registry_item_in_cart?(@session, @registry_item1.id).should be_true
    end

    it "should be false, when only other item is in cart for any other reason" do
      @session[:registrant] = @registrant.id
      Cart.add_registry_item_to_cart(@session, @registry_item1)
      Cart.add_registry_item_to_cart(@session, @purchased_registry_item1)
      Cart.registry_item_in_cart?(@session, @purchased_registry_item2.id).should be_false
    end
    
    it "should be true, when item is in cart (not authenticated user)" do
        Cart.add_registry_item_to_cart(@session, @registry_item1)
        Cart.add_registry_item_to_cart(@session, @purchased_registry_item1)
        Cart.registry_item_in_cart?(@session, @registry_item1.id).should be_true
    end

    it "should false, when in cart exists other items for exchange how not authenticated user" do
      Cart.add_registry_item_to_cart(@session, @registry_item1)
      Cart.add_registry_item_to_cart(@session, @purchased_registry_item1)
      Cart.registry_item_in_cart?(@session, @purchased_registry_item2.id).should be_false
    end
  end
###################################################################################################################
  describe "add registry item to cart" do
    it "should true for empty cart how not authenticated user" do
      buy_registry_item = BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::CONTRIBUTE)
      Cart.add_registry_item_to_cart(@session, buy_registry_item, 'buy').should be_true
      Cart.registry_item_in_cart?(@session, buy_registry_item.id).should be_true
    end
    
    it "should true for empty cart how authorized user" do
      @session[:registrant] = @registrant.id
      buy_registry_item = BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::CONTRIBUTE)
      Cart.add_registry_item_to_cart(@session, buy_registry_item, 'buy').should be_true
      @session[:cart].registry_items.should == [buy_registry_item]
    end
    
    it "should two items in cart, when exists other item in cart how not authenticated user" do
      buy_registry_item1 = BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::CONTRIBUTE)
      buy_registry_item2 = BuyRegistryItem.new(:item => @purchased_registry_item1, :type => BuyRegistryItem::CONTRIBUTE)
      Cart.add_registry_item_to_cart(@session, buy_registry_item1, 'buy').should be_true
      Cart.add_registry_item_to_cart(@session, buy_registry_item2, 'buy').should be_true
      @session[:giver].registry_items.should == [buy_registry_item1, buy_registry_item2]
    end
    
    it "should two items in cart, when exists other item in cart how authorized user" do
      @session[:registrant] = @registrant.id
      buy_registry_item1 = BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::CONTRIBUTE)
      buy_registry_item2 = BuyRegistryItem.new(:item => @purchased_registry_item1, :type => BuyRegistryItem::CONTRIBUTE)
      Cart.add_registry_item_to_cart(@session, buy_registry_item1, 'buy').should be_true
      Cart.add_registry_item_to_cart(@session, buy_registry_item2, 'buy').should be_true
      @session[:cart].registry_items.should == [buy_registry_item1, buy_registry_item2]
    end
    
    it "should one items in cart, when exists the same item in cart how not authenticated user" do
      buy_registry_item1 = BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::CONTRIBUTE)
      Cart.add_registry_item_to_cart(@session, buy_registry_item1, 'buy').should be_true
      Cart.add_registry_item_to_cart(@session, buy_registry_item1, 'buy').should be_false
      @session[:giver].registry_items.should == [buy_registry_item1]
    end
    
    it "should one items in cart, when exists the same item in cart how authorized user" do
      @session[:registrant] = @registrant.id
      buy_registry_item1 = BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::CONTRIBUTE)
      Cart.add_registry_item_to_cart(@session, buy_registry_item1, 'buy').should be_true
      Cart.add_registry_item_to_cart(@session, buy_registry_item1, 'buy').should be_false
      @session[:cart].registry_items.should == [buy_registry_item1]
    end
  end
###################################################################################################################
  describe "add product to cart" do
    it "should true for empty cart how not authenticated user" do
      buy_product = BuyProduct.new(:product => @product1)
      Cart.add_product_to_cart(@session, buy_product).should be_true
      @session[:giver].products.should == [buy_product]
    end

    it "should true for empty cart how authorized user" do
      @session[:registrant] = @registrant.id
      buy_product = BuyProduct.new(:product => @product1)
      Cart.add_product_to_cart(@session, buy_product).should be_true
      @session[:cart].products.should == [buy_product]
    end

    it "should two products in cart, when exists other item in cart how not authenticated user" do
      buy_product1 = BuyProduct.new(:product => @product1)
      buy_product2 = BuyProduct.new(:product => @product2)
      Cart.add_product_to_cart(@session, buy_product1).should be_true
      Cart.add_product_to_cart(@session, buy_product2).should be_true
      @session[:giver].products.should == [buy_product1, buy_product2]
    end

    it "should two products in cart, when exists other item in cart how authorized user" do
      @session[:registrant] = @registrant.id
      buy_product1 = BuyProduct.new(:product => @product1)
      buy_product2 = BuyProduct.new(:product => @product2)
      Cart.add_product_to_cart(@session, buy_product1).should be_true
      Cart.add_product_to_cart(@session, buy_product2).should be_true
      @session[:cart].products.should == [buy_product1, buy_product2]
    end
    
    it "should two products in cart, when exists the same item in cart how not authenticated user" do
      buy_product1 = BuyProduct.new(:product => @product1)
      Cart.add_product_to_cart(@session, buy_product1).should be_true
      Cart.add_product_to_cart(@session, buy_product1).should be_true
      @session[:giver].products.should == [buy_product1, buy_product1]
    end

    it "should two products in cart, when exists the same item in cart how authorized user" do
      @session[:registrant] = @registrant.id
      buy_product1 = BuyProduct.new(:product => @product1)
      Cart.add_product_to_cart(@session, buy_product1).should be_true
      Cart.add_product_to_cart(@session, buy_product1).should be_true
      @session[:cart].products.should == [buy_product1, buy_product1]
    end
  end
###################################################################################################################
  describe "add item to cart for withdrawal" do
    it "should return true for empty cart" do
      @session[:registrant] = @registrant.id
      Cart.add_item_for_withdrawal(@session, @purchased_registry_item2).should be_true
    end

    it "should return true is another withdraw is in the cart other item in cart" do
      @session[:registrant] = @registrant.id
      Cart.add_item_for_withdrawal(@session, @purchased_registry_item1).should be_true
      Cart.add_item_for_withdrawal(@session, @purchased_registry_item2).should be_true
    end

    it "should return false if the item is already in the cart for withdrawal." do
      @session[:registrant] = @registrant.id
      Cart.add_item_for_withdrawal(@session, @purchased_registry_item1).should be_true
      Cart.add_item_for_withdrawal(@session, @purchased_registry_item1).should be_false
    end
  end
###################################################################################################################
  describe "update quantity item" do
    it "should false when item not exists in cart" do
      Cart.update_quantity_item(@session, 100, 1).should be_false
    end
    
    it "should quantity changed to 2" do
      buy_product = BuyProduct.new(:product => @product1, :quantity => 1)
      Cart.add_product_to_cart(@session, buy_product).should be_true
      Cart.update_quantity_item(@session, buy_product.id, 2).should be_true
      @session[:giver].products[0].quantity.should == 2
    end

    it "should return false if quantity is invalid" do
      buy_product = BuyProduct.new(:product => @product1, :quantity => 1)
      Cart.add_product_to_cart(@session, buy_product).should be_true
      Cart.update_quantity_item(@session, buy_product.id, -2).should be_false
    end
  end
###################################################################################################################
  describe "delete product from cart" do
    it "cart should be empty if only product removed." do
      buy_product = BuyProduct.new(:product => @product1)
      Cart.add_product_to_cart(@session, buy_product).should be_true
      Cart.delete_product_from_cart(@session, buy_product.id)
      @session[:giver].products.should == []
    end


    it "should delete one item, when exists other item in cart how not authenticated user" do
      buy_product1 = BuyProduct.new(:product => @product1)
      buy_product2 = BuyProduct.new(:product => @product2)
      Cart.add_product_to_cart(@session, buy_product1).should be_true
      Cart.add_product_to_cart(@session, buy_product2).should be_true
      Cart.delete_product_from_cart(@session, buy_product1.id)
      @session[:giver].products.should == [buy_product2]
    end

  end
###################################################################################################################
  describe "delete registry item from cart" do
    it "should empty array for empty cart how not authenticated user" do
      buy_registry_item = BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::CONTRIBUTE)
      Cart.add_registry_item_to_cart(@session, buy_registry_item).should be_true
      Cart.delete_registry_item_from_cart(@session, buy_registry_item.id)
      @session[:giver].registry_items.should == []
    end


    it "should delete one item, when exists other item in cart" do
      buy_registry_item1 = BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::CONTRIBUTE)
      buy_registry_item2 = BuyRegistryItem.new(:item => @purchased_registry_item1, :type => BuyRegistryItem::CONTRIBUTE)
      Cart.add_registry_item_to_cart(@session, buy_registry_item1, 'buy').should be_true
      Cart.add_registry_item_to_cart(@session, buy_registry_item2, 'buy').should be_true
      Cart.delete_registry_item_from_cart(@session, buy_registry_item1.id)
      @session[:giver].registry_items.should == [buy_registry_item2]
    end

  end
###################################################################################################################
  describe "delete cash" do
    it "should remove cash" do
      @session[:registrant] = @registrant.id
      Cart.add_item_for_withdrawal(@session, @registry_item1)
      Cart.delete_cash(@session)
      Cart.get_full_information(@session).cash.should be_nil
    end

    it "should delete one item, when exists other item in cart how authorized user" do
      @session[:registrant] = @registrant.id
      Cart.add_item_for_withdrawal(@session, @registry_item1)
      Cart.add_item_for_withdrawal(@session, @purchased_registry_item1)
      Cart.delete_cash(@session)
      Cart.get_full_information(@session).cash.should be_nil
    end
  end

###################################################################################################################
  describe "get full information" do
    before(:each) do
      @buy_product1 = BuyProduct.new(:product => @product1)
      @buy_product2 = BuyProduct.new(:product => @product2)

      @buy_product1.quantity = 1
      @buy_product1.price = 50
      @buy_product1.tax = 10
      @buy_product1.shipment = 1
      # total = 56

      @buy_product2.quantity = 2
      @buy_product2.price = 50
      @buy_product2.tax = 10
      @buy_product2.shipment = 2
      # total = 114

      @buy_registry_item1 = BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::CONTRIBUTE)
      @buy_registry_item2 = BuyRegistryItem.new(:item => @registry_item2, :type => BuyRegistryItem::CONTRIBUTE)

      @buy_registry_item1.quantity = 1
      @buy_registry_item1.price = 50
      @buy_registry_item1.tax = 10
      @buy_registry_item1.shipment = 1
      # total = 56

      @buy_registry_item2.quantity = 0.5
      @buy_registry_item2.price = 400
      @buy_registry_item2.tax = 10
      @buy_registry_item2.shipment = 10
      # total = 225

    end
    it "should default value for empty cart" do
      cart_information = Cart.get_full_information(@session)
      cart_information.subtotal.should == 0
      cart_information.tax_total.should == 0
      cart_information.shipment_total.should == 0
      cart_information.total.should == 0
      cart_information.list_registry_items.should == []
      cart_information.list_products.should == []
    end

    it "should calculate correct values when products are in the cart to buy" do

      Cart.add_product_to_cart(@session, @buy_product1)
      Cart.add_product_to_cart(@session, @buy_product2)

      cart_information = Cart.get_full_information(@session)

      cart_information.subtotal.should == 150
      cart_information.tax_total.should == 15
      cart_information.shipment_total.should == 5
      cart_information.total.should == 170
      cart_information.list_registry_items.should == []
      cart_information.list_products.should == [@buy_product1, @buy_product2]
      cart_information.list_registry_items.should == []
    end
    
    it "should calculate correct values, when registry items are in the cart" do

      Cart.add_registry_item_to_cart(@session, @buy_registry_item1).should be_true
      Cart.add_registry_item_to_cart(@session, @buy_registry_item2).should be_true

      cart_information = Cart.get_full_information(@session)

      cart_information.subtotal.should == 250
      cart_information.tax_total.should == 25
      cart_information.shipment_total.should == 6
      cart_information.total.should == 281
      cart_information.list_products.should == []
      cart_information.list_registry_items.should == [@buy_registry_item1, @buy_registry_item2]
    end

    it "should calculate correct values, when a mix of registry items and products are in the cart" do

      Cart.add_registry_item_to_cart(@session, @buy_registry_item1).should be_true
      Cart.add_registry_item_to_cart(@session, @buy_registry_item2).should be_true
      Cart.add_product_to_cart(@session, @buy_product1)
      Cart.add_product_to_cart(@session, @buy_product2)

      cart_information = Cart.get_full_information(@session)

      cart_information.subtotal.should == 400
      cart_information.tax_total.should == 40
      cart_information.shipment_total.should == 11
      cart_information.total.should == 451
      cart_information.list_products.should == [@buy_product1, @buy_product2]
      cart_information.list_registry_items.should == [@buy_registry_item1, @buy_registry_item2]
    end

    it "should calculate correct values when cart is a withdrawal" do
      @session[:registrant] = @registrant.id

      @purchased_registry_item1.Contributed = 1000
      @purchased_registry_item2.Contributed = 100

      Cart.add_item_for_withdrawal(@session, @purchased_registry_item1)
      Cart.add_item_for_withdrawal(@session, @purchased_registry_item2)

      cart_information = Cart.get_full_information(@session)

      cart_information.withdraw_total.should == 1100
      cart_information.commission.should == 55
      cart_information.total.should == 1045
    end

    it "if user is logged in include queue information and amount remaining." do
      @session[:registrant] = @registrant.id
      Cart.add_registry_item_to_cart(@session, @buy_registry_item1).should be_true
      Registrant.stub(:find).and_return(@registrant)
      @registrant.should_receive(:get_queue_for_payment).and_return(100)

      cart_information = Cart.get_full_information(@session)

      cart_information.queue.should == 100
      cart_information.total.should == 56
      cart_information.missing_amount.should == 44
    end

    it "if user is logged in include queue information and amount remaining." do
      @session[:registrant] = @registrant.id
      Cart.add_registry_item_to_cart(@session, @buy_registry_item1).should be_true
      Cart.add_registry_item_to_cart(@session, @buy_registry_item2).should be_true
      Registrant.stub(:find).and_return(@registrant)
      @registrant.should_receive(:get_queue_for_payment).and_return(100)

      cart_information = Cart.get_full_information(@session)

      cart_information.queue.should == 100
      cart_information.total.should == 281
      cart_information.missing_amount.should == -181
    end

    it "if user is not logged in do not include  queue information and amount remaining." do
      Cart.add_registry_item_to_cart(@session, @buy_registry_item1).should be_true

      cart_information = Cart.get_full_information(@session)

      cart_information.queue.should be_nil
      cart_information.total.should == 56
      cart_information.missing_amount.should == 0
    end

    it "should set status to withdrawal for withdrawal" do
      @session[:registrant] = @registrant.id

      Cart.add_item_for_withdrawal(@session, @purchased_registry_item1)

      cart_information = Cart.get_full_information(@session)

      cart_information.type.should == CartInformation::TYPE_WITHDRAW

    end

    it "should set status to buy_contribute when buy/contribute items in cart" do

      Cart.add_registry_item_to_cart(@session, @buy_registry_item1).should be_true

      cart_information = Cart.get_full_information(@session)

      cart_information.type.should == CartInformation::TYPE_BUY_CONTRIBUTE
    end

    it "should set use_cash status from the cart" do

      Cart.add_registry_item_to_cart(@session, @buy_registry_item1).should be_true
      Cart.get_cart(@session).use_cash = true

      cart_information = Cart.get_full_information(@session)

      cart_information.use_cash.should == true

      Cart.get_cart(@session).use_cash = false

      cart_information = Cart.get_full_information(@session)

      cart_information.use_cash.should == false
    end


      #cart_information.take.should == 715
  end

  describe "update_for_one_state" do
    it "should set tax on products in the cart." do
      state_id = 10
      @buy_product1 = BuyProduct.new(:product => @product1, :quantity => 1)
      @buy_product2 = BuyProduct.new(:product => @product2, :quantity => 1)
      Cart.add_product_to_cart(@session, @buy_product2).should be_true
      Cart.add_product_to_cart(@session, @buy_product1).should be_true

      Product.should_receive(:find).with(@product1.id).and_return(@product1)
      Product.should_receive(:find).with(@product2.id).and_return(@product2)
      @product1.should_receive(:tax).with(state_id).and_return(12)
      @product2.should_receive(:tax).with(state_id).and_return(13)

      @buy_product1.should_receive(:tax=).with(12)
      @buy_product2.should_receive(:tax=).with(13)

      cart_information = Cart.update_for_one_state(@session, state_id)
    end

    describe "set tax on registry items"  do
      before(:each) do
        @state_id = 10

        @registry_item1 = Factory.create(:registry_item)
        @registry_item2 = Factory.create(:registry_item)

        @buy_registry_item1 = BuyRegistryItem.new(:item => @registry_item1, :type => BuyRegistryItem::CONTRIBUTE)
        @buy_registry_item2 = BuyRegistryItem.new(:item => @registry_item2, :type => BuyRegistryItem::CONTRIBUTE)

        Cart.add_registry_item_to_cart(@session, @buy_registry_item1).should be_true
        Cart.add_registry_item_to_cart(@session, @buy_registry_item2).should be_true

        RegistryItem.should_receive(:find).with(@registry_item1.id).and_return(@registry_item1)
        RegistryItem.should_receive(:find).with(@registry_item2.id).and_return(@registry_item2)

        @registry_item1.stub_chain(:product, :tax).with(@state_id).and_return(12)
        @registry_item2.stub_chain(:product, :tax).with(@state_id).and_return(13)
      end
      it "should set tax on catalog items in the cart." do

        @registry_item1.stub_chain(:product, :cash?).and_return(false)
        @registry_item2.stub_chain(:product, :cash?).and_return(false)

        @buy_registry_item1.should_receive(:tax=).with(12)
        @buy_registry_item2.should_receive(:tax=).with(13)

        Cart.update_for_one_state(@session, @state_id)
      end

      it "should not set tax on cash items in the cart." do

        @registry_item1.stub_chain(:product, :cash?).and_return(true)
        @registry_item2.stub_chain(:product, :cash?).and_return(false)

        @buy_registry_item1.should_not_receive(:tax=).with(12)
        @buy_registry_item2.should_receive(:tax=).with(13)

        Cart.update_for_one_state(@session, @state_id)
      end
    end
  end

  describe "update_quantity_item" do
    it "should update the quantity of the specified item"  do
      @buy_product1 = BuyProduct.new(:product => @product1, :quantity => 1)

      Cart.add_product_to_cart(@session, @buy_product1).should be_true

      cart_information = Cart.get_full_information(@session)

      subtotal = cart_information.subtotal
      tax_total = cart_information.tax_total
      shipment_total = cart_information.shipment_total
      total = cart_information.total

      Cart.update_quantity_item(@session, @buy_product1.id, 2).should be_true
      cart_information2 = Cart.get_full_information(@session)

      cart_information2.subtotal.should == subtotal * 2
      cart_information2.tax_total.should == tax_total * 2
      cart_information2.shipment_total.should == shipment_total * 2
      cart_information2.total.should == total * 2
      cart_information2.list_products[0].quantity.should == 2
    end
  end
end