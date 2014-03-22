require "spec_helper"

describe PaymentController do
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
    @registry_item2 = Factory.create(:registry_item, :registrant => @registrant, :product => @product2,
                                      :Purchased_ID => RegistryItem::PURCHASED,
                                      :Price => 100, :Tax => 100, :Shipment => 100, :Contributed => 150)
    @registry_item3 = Factory.create(:registry_item, :registrant => @registrant, :product => @product3,
                                      :Purchased_ID => RegistryItem::PURCHASED,
                                      :Price => 100, :Tax => 100, :Shipment => 100, :Contributed => 200)
    Factory.create(:contribute, :registry_item => @registry_item3, :Contribute => 300)
    @cart = Cart.new
  end

###################################################################################################################
  describe "cart" do
    it "should assign cart and render the cart template " do
      cart_information_double = double("cart information double")
      Cart.should_receive(:get_full_information).and_return(cart_information_double)

      get :cart

      assigns[:cart_information].should == cart_information_double
      response.should render_template(cart_path)
    end

    it "should set quantity if a new quantity is posted." do
      id = 3
      value = 4

      Cart.should_receive(:update_quantity_item).with(anything(), id, value)

      post :cart, {:quantityId => id, :quantityValue => value}
    end

    it "should set quantity to 1 if a 0 quantity is specified" do
      id = 3
      value = 0

      Cart.should_receive(:update_quantity_item).with(anything(), id, 1)

      post :cart, {:quantityId => id, :quantityValue => value}
    end

    it "should set quantity to 1 if a negative quantity is specified" do
      id = 3
      value = -3

      Cart.should_receive(:update_quantity_item).with(anything(), id, 1)

      post :cart, {:quantityId => id, :quantityValue => value}
    end

    it "should set quantity to 1 if a string is specified" do
      id = 3
      value = "foo"

      Cart.should_receive(:update_quantity_item).with(anything(), id, 1)

      post :cart, {:quantityId => id, :quantityValue => value}
    end

    it "should round quantity down if it is a decimal" do
      id = 3
      value = 3.7

      Cart.should_receive(:update_quantity_item).with(anything(), id, 3)

      post :cart, {:quantityId => id, :quantityValue => value}
    end


    it "should redirect to step 1 if there is a post with empty paramaters" do
      id = 3
      value = 3.7

      post :cart, {:quantityId => nil, :quantityValue => nil}

      response.should redirect_to(step1_path)

    end

  end
###################################################################################################################
  describe "deletefrombuycart" do
    it "should redirect to the cart path if nothing specified" do
      get :deletefrombuycart
      response.should redirect_to(:action => :cart)
    end

    it "should delete the specified item from the cart" do
      item_id = double("item_id")
      Cart.should_receive(:delete_product_from_cart).with(anything(), item_id)

      get :deletefrombuycart, {:id => item_id}

      response.should redirect_to(:action => :cart)
    end
  end
###################################################################################################################
  describe "deletefromcart" do
    it "should redirect to the cart path if nothing specified" do
      get :deletefromcart
      response.should redirect_to(:action => :cart)
    end

    it "should delete the specified item from the cart" do
      item_id = double("item_id")
      Cart.should_receive(:delete_registry_item_from_cart).with(anything(), item_id)

      get :deletefromcart, {:id => item_id}

      response.should redirect_to(:action => :cart)
    end
  end
###################################################################################################################
  describe "delete cash" do
    it "should delete cash and then redirect back to the cart" do
      session[:registrant] = @registrant.id
      Cart.should_receive(:delete_cash)

      get :deletecash, {}, {:registrant  => @registry_item2.id}

      response.should redirect_to(:action => :cart)
    end
  end

  ###################################################################################################################
  describe "emptycart" do
    it "should empty the cart" do
      Cart.should_receive(:empty_cart)

      get :emptycart

      response.should redirect_to(:action => :cart)
    end
  end
###################################################################################################################
  describe "step1" do
    it "should redirect to cart if cart is empty" do
      Cart.should_receive(:is_empty_cart?).and_return(true)
      get :step1
      response.should redirect_to(:cart)
    end

    context "cart is set" do
      before(:each) do
        @cart = mock("cart")
        Cart.stub(:is_empty_cart?).and_return(false)

        @cart_info_double = double("cart information")
        @cart_info_double.stub(:type).and_return(nil)
        Cart.stub(:get_full_information).and_return(@cart_info_double)
        @cart_info_double.stub(:total).and_return(25)
      end

      it "should get a list of states and set it as a param" do
        states_double = double("states")
        StaticDataUtilities.should_receive(:get_states).and_return(states_double)

        get :step1
        assigns[:states].should == states_double
      end

      it "should get cart summery information and set it as a param" do
        Cart.should_receive(:get_full_information).and_return(@cart_info_double)

        get :step1
        assigns[:cart_information].should == @cart_info_double
      end

      context "get" do
        before(:each) do
          @order_params_double = double("order params")
          @order_double = double("order")

          @registrant_double = double("registrant")
          @registrant_double.stub(:get_queue_for_payment).and_return(25)
          Registrant.stub(:find).and_return(@registrant_double)
        end

      #  There are some special paramaters here.  What are they for?  We do not have test cases for them

        it "should create a new order" do
          Order.should_receive(:new).and_return(@order_double)
          @order_double.stub(:GUID=) # What's this GID for can we drop it?'

          get :step1
        end

        it "should set a validation GUID on the cart" do
          Order.stub(:new).and_return(@order_double)

          guid_double = double("guid")
          ImageUtilities.should_receive(:get_guid).and_return(guid_double)
          @order_double.should_receive(:GUID=).with(guid_double)

          get :step1
        end

        it "should set address info if the user is logged in" do
          @order_double.stub(:GUID=)

          @order_double.should_receive(:use_registrant_address).with(@registrant_double, anything())
          Order.stub(:new).and_return(@order_double)

          get :step1, {}, {:registrant => 1}
        end

        it "should render the step1 form" do

          get :step1

          response.should render_template(step1_path)
        end
      end

      context "post" do
        before(:each) do
          @order_params_double = double("order params")
          @order_double = double("order")

          @order_double.stub(:is_use_bill_address).and_return(false)
          @order_double.stub(:is_use_bill_address=)
          @order_double.stub(:Amount=)
          @order_double.stub(:order_type=)
          @order_double.stub(:order_type)
          @order_double.stub(:valid?)
          @order_double.stub(:ShippingState_ID).and_return(@shipping_state_double)
          Order.stub(:new).with(@order_params_double).and_return(@order_double)
        end

        it "should create a new order with passed params" do

          Order.should_receive(:new).with(@order_params_double).and_return(@order_double)

          post :step1, {:order => @order_params_double}
        end

        it "should use billing address if this was specified" do
          @order_double.stub(:is_use_bill_address).and_return(true)

          @order_double.should_receive(:use_billing_address)

          post :step1, {:order => @order_params_double}
        end

        it "should set order Amount to total if buying items" do
          total_amount = double("total amount")
          @cart_info_double.should_receive(:type).and_return(CartInformation::TYPE_BUY_CONTRIBUTE)
          @cart_info_double.should_receive(:total).and_return(total_amount)
          @order_double.should_receive(:Amount=).with(total_amount)

          post :step1, {:order => @order_params_double}
        end

        it "should set order Amount to total if withdrawing" do
          withdraw_total_amount = double("total amount")
          @cart_info_double.should_receive(:type).and_return(CartInformation::TYPE_WITHDRAW)
          @cart_info_double.should_receive(:withdraw_total).and_return(withdraw_total_amount)
          @order_double.should_receive(:Amount=).with(withdraw_total_amount)

          post :step1, {:order => @order_params_double}
        end

        it "should set the order type to buy if the cart is a buy" do
          Cart.should_receive(:is_buy?).and_return(true)
          @order_double.should_receive(:order_type=).with(Order::BUY)

          post :step1, {:order => @order_params_double}
        end

        it "should set the order type to contribute if the cart is a contribute" do
          Cart.should_receive(:is_buy?).and_return(false)
          Cart.should_receive(:is_contribute?).and_return(true)
          @order_double.should_receive(:order_type=).with(Order::CONTRIBUTE)

          post :step1, {:order => @order_params_double}
        end

        it "should set the order type to withdraw if the cart is a withdraw" do
          Cart.should_receive(:is_buy?).and_return(false)
          Cart.should_receive(:is_contribute?).and_return(false)
          @order_double.should_receive(:order_type=).with(Order::WITHDRAW)

          post :step1, {:order => @order_params_double}
        end

        it "should update the cart with tax for the new billing address if this is a buy order type." do
          Cart.stub(:is_buy?).and_return(true)
          @order_double.stub(:order_type).and_return(Order::BUY)

          Cart.should_receive(:update_for_one_state).with(anything(), @shipping_state_double)
          post :step1, {:order => @order_params_double}
        end

        it "should update cart information and refresh page if there are validation errors" do

          @order_double.should_receive(:valid?).and_return(false)
          Cart.should_receive(:get_full_information).twice

          post :step1, {:order => @order_params_double}

          response.should render_template(step1_path)
        end

        it "should set the order in the session and redirect to step2 if the order is valid" do

          @order_double.should_receive(:valid?).and_return(true)
          Cart.should_receive(:get_full_information)

          post :step1, {:order => @order_params_double}

          response.should redirect_to(step2_path)
          request.session[:order].should == @order_double
        end


      end


    end
  end

  describe 'Paying by Venmo' do
    it "stores the access token if one exists into the session" do
      session[:venmo_access_token] = nil
      get :pay_via_venmo, :access_token => 'foobar'
      response.should be_ok
      assigns(:venmo).should be_authorized
    end

    it "makes a payment via venmo" do
      venmo = mock(Venmo)
      Venmo.stub(:new).and_return(venmo)
      request.env['HTTP_REFERER'] = 'http://example.com'
      registrant = Factory.create(:registrant).reload
      venmo.should_receive(:make_payment).with(1000, registrant.Email)
      post :make_payment_via_venmo, :amount => 1000, :registrant_id => registrant.id
      response.should redirect_to(:back)
    end
  end

#  TODO step2, step3, process-order, process-payment, success_payment, order_payment
end
