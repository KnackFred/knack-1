require "spec_helper"

describe RegistrantController do

  describe "home" do
    it "Should render the home page" do
      post :home
      response.should render_template("home")
    end

  end

  ##################################################################################################################

  describe "activation" do
    before (:each) do
      @registrant = Factory.build(:registrant)
      Registrant.stub(:activate).and_return(@registrant)
    end

    it "should activate the user" do
      Registrant.should_receive(:activate).and_return(@registrant)
      post :activation, :id => 321343
    end

    it "should send an email message" do
      MailUtilities.should_receive(:send_activated).with(@registrant.Email, @registrant.Email)
      post :activation, :id => 321343
    end

    it "should render the activation template" do
      post :activation, :id => 321343
      response.should render_template("activation")
    end
  end

  ##################################################################################################################

  describe "confirm" do
    before(:each) do
      @registrant = Factory.build(:registrant)
      Registrant.stub(:find).and_return(@registrant)
    end

    it "should set @email" do
      get :confirm, {"email" => @registrant.Email}
      assigns[:email].should == @registrant.Email
    end

    it "should render the confirm template" do
      get :confirm, {}, {'registrant' => @registrant.id}
      response.should render_template("confirm")
    end
  end

  ##################################################################################################################

  describe "give" do
    context "when request is get" do
      it "should render the gives template" do
        get :give
        response.should render_template("give")
      end

      it "should not set @IsPost" do
        get :give
        assigns[:IsPost].should be_false
      end
    end

    context "when request is post" do
      before(:each) do
        @search_string = "foo bar"
        @registrant = Factory.build(:registrant)
        Registrant.stub(:search).and_return([@registrant])
      end

      it "should search for registry" do
        Registrant.should_receive(:search).and_return([@registrant])
        post :give, {"find" => @search_string}
        assigns[:registrants].should == [@registrant]
      end

      it "should set @IsPost" do
        post :give, {"find" => @search_string}
        assigns[:isPost].should == 1
      end

    end
  end

  ###################################################################################################################

  describe "manageregistry" do
    before(:each) do
      @registrant = Factory.create(:registrant)
      Registrant.stub(:find).and_return(@registrant)
      product1 = Factory.build(:product)
      product2 = Factory.build(:product)
      product3 = Factory.build(:product)
      product4 = Factory.build(:product)
      product5 = Factory.build(:product)
      product6 = Factory.build(:product)
      registry_item1 = Factory.build(:registry_item, :registrant => @registrant, :product => product1, :Purchased_ID => RegistryItem::AVAILABLE)
      registry_item2 = Factory.build(:registry_item, :registrant => @registrant, :product => product2, :Purchased_ID => RegistryItem::AVAILABLE)
      registry_item3 = Factory.build(:registry_item, :registrant => @registrant, :product => product3, :Purchased_ID => RegistryItem::PURCHASED)
      registry_item4 = Factory.build(:registry_item, :registrant => @registrant, :product => product4, :Purchased_ID => RegistryItem::PURCHASED)
      registry_item5 = Factory.build(:registry_item, :registrant => @registrant, :product => product5, :Purchased_ID => RegistryItem::ORDERED)
      registry_item6 = Factory.build(:registry_item, :registrant => @registrant, :product => product6, :Purchased_ID => RegistryItem::ORDERED)
      @r2p_array = [registry_item1, registry_item2, registry_item3, registry_item4, registry_item5, registry_item6]
      @registrant.stub(:gifts).and_return(@r2p_array)

    end

    it "should redirect to signin if user not logged in" do
      get :manage_registry
      response.should redirect_to signin_path
    end

    it "should render the manage_registry template" do
      get :manage_registry, {}, {'registrant' => @registrant.id}
      response.should render_template("manage_registry")
    end

    it "should assign @registrant" do
      get :manage_registry, {}, {'registrant' => @registrant.id}
      assigns[:registrant].should_not be_nil
    end

    it "should assign @registrant2products for the registrant" do
      @registrant.should_receive(:gifts).and_return(@r2p_array)
      get :manage_registry, {}, {'registrant' => @registrant.id}
      assigns[:registrant2products].should == @r2p_array
    end

    it "pass sort to the model (1)" do
      @registrant.should_receive(:gifts).with(0, nil, nil, 0).and_return(@r2p_array)
      get :manage_registry, {:sort => 0}, {'registrant' => @registrant.id}
      assigns[:registrant2products].should == @r2p_array
    end

    it "pass sort to the model (2)" do
      @registrant.should_receive(:gifts).with(0, nil, nil, 1).and_return(@r2p_array)
      get :manage_registry, {:sort => 1}, {'registrant' => @registrant.id}
      assigns[:registrant2products].should == @r2p_array
    end

    it "pass sort to the model (3)" do
      @registrant.should_receive(:gifts).with(0, nil, nil, 1).and_return(@r2p_array)
      get :manage_registry, {:sort => 1}, {'registrant' => @registrant.id}
      assigns[:registrant2products].should == @r2p_array
    end

    it "pass filter to the model (1)" do
      @registrant.should_receive(:gifts).with(1, nil, nil, 0).and_return(@r2p_array)
      get :manage_registry, {:filter => 1}, {'registrant' => @registrant.id}
      assigns[:registrant2products].should == @r2p_array
    end

    it "pass filter to the model (2)" do
      @registrant.should_receive(:gifts).with(2, nil, nil, 0).and_return(@r2p_array)
      get :manage_registry, {:filter => 2}, {'registrant' => @registrant.id}
      assigns[:registrant2products].should == @r2p_array
    end

    it "should default to not filter and to sort by price descending " do
      @registrant.should_receive(:gifts).with(0, nil, nil, 0).and_return(@r2p_array)
      get :manage_registry, {}, {'registrant' => @registrant.id}
      assigns[:registrant2products].should == @r2p_array
    end

    it "should pass page number to model" do
      @registrant.should_receive(:gifts).with(0, 2, nil, 0).and_return(@r2p_array)
      get :manage_registry, {:page =>2 }, {'registrant' => @registrant.id}
      assigns[:registrant2products].should == @r2p_array
    end

  end

  ##################################################################################################################

  describe "links" do
    before(:each) do
      @registrant = Factory.build(:registrant)
      @registrant_id = 12
      Registrant.stub(:find).and_return(@registrant)
    end

    it "should render the links template" do
      post :links, {}, {'registrant' => @registrant_id}
      response.should render_template("links")
    end

    it "should assign @registrant" do
      post :links, {}, {'registrant' => @registrant_id}
      assigns[:registrant].should_not be_nil
    end

    it "should redirect to signin if user not logged in" do
      post :links
      response.should redirect_to signin_path
    end

    it "should assign @banners" do
      post :links, {}, {'registrant' => @registrant_id}
      assigns[:banners].length().should == 4
    end

    it "should assign @banners_src" do
      post :links, {}, {'registrant' => @registrant_id}
      assigns[:banners_src].length().should == 4
    end

    it "should get gift count" do
      @registrant.should_receive(:gifts_count).and_return(5)
      post :links, {}, {'registrant' => @registrant_id}
    end

    it "gift count should be based on the number of un-purchased gifts" do
      @registrant.should_receive(:gifts_count).with(RegistryItem::AVAILABLE)
      post :links, {}, {'registrant' => @registrant_id }
    end
  end

  ##################################################################################################################

  describe "get_banner" do
    before(:each) do
      @registrant = Factory.create(:registrant)
      @registrant_id = 47
      Registrant.stub(:find).and_return(@registrant)

    end

    it "should get gift count" do
      @registrant.should_receive(:gifts_count).exactly(4).times.and_return(5)
      post :getbanner, {"r" => @registrant_id, "n" => 0}
      post :getbanner, {"r" => @registrant_id, "n" => 1}
      post :getbanner, {"r" => @registrant_id, "n" => 2}
      post :getbanner, {"r" => @registrant_id, "n" => 3}
    end

    it "gift count should be based on the number of un-purchased gifts" do
      @registrant.should_receive(:gifts_count).with(RegistryItem::AVAILABLE)
      post :getbanner, {"r" => @registrant_id, "n" => 1}
    end

    it "should get banner if n is not specified" do
      lambda {
        post :getbanner, {"r" => @registrant_id, "n" => 0}
      }.should_not raise_exception
    end

    it "should throw an exception if params not specified or regsirtant not found" do
      Registrant.stub(:find).and_raise ActiveRecord::RecordNotFound
      lambda { post :getbanner }.should raise_exception
    end

  end

  ##################################################################################################################

  describe "login" do
    it "should render login view if not a post" do
      get :login
      response.should render_template("login")
    end

    it "should call model to see if registrant is valid." do
      registrant = Factory.build(:registrant)
      Registrant.should_receive(:sign_in).and_return(registrant)
      post :login, {"registrant" => {"Email" => registrant.Email, "Password" => registrant.new_password}}
    end

    context "user credential are valid" do
      before(:each) do
        @registrant = Factory.build(:registrant)
        @registrant.id = 47
        Registrant.stub(:sign_in).and_return(@registrant)
      end

      it "should set session for valid user" do
        Cart.should_receive(:new)
        post :login, {"registrant" => {"Email" => @registrant.Email, "Password" => @registrant.new_password}}
        session['registrant'].should == @registrant.id
      end

      it "should create a new cart for valid user" do
        cart = Cart.new
        Cart.should_receive(:new).and_return(cart)
        post :login, {"registrant" => {"Email" => @registrant.Email, "Password" => @registrant.new_password}}
        session['cart'].should == cart
      end

      it "should redirect user to manage registry" do
        post :login, {"registrant" => {"Email" => @registrant.Email, "Password" => @registrant.new_password}}
        response.should redirect_to(:action => 'manage_registry')
      end

      it "should redirect user to invite_friends if they have not seen it" do
        @registrant.invite_friends_shown = false
        post :login, {"registrant" => {"Email" => @registrant.Email, "Password" => @registrant.new_password}}
        response.should redirect_to invite_friends_path
      end

      it "should redirect to target page if access was denied on a page" do
        post :login, {"registrant" => {"Email" => @registrant.Email, "Password" => @registrant.new_password}}, {"intended_path" => '/profile'}
        response.should redirect_to(:action => 'profile')
      end

      it "should clear target page on login" do
        post :login, {"registrant" => {"Email" => @registrant.Email, "Password" => @registrant.new_password}}, {"intended_path" => '/profile'}
        session['intended_path'].should be_blank

      end
    end

    it "should alert on incorrect credentials" do
      registrant = Factory.build(:registrant)
      Registrant.should_receive(:sign_in).and_raise("ERROR MESSAGE")
      post :login, {"registrant" => {"Email" => registrant.Email, "Password" => "WRONG"}}
      response.should render_template(:login)
      assigns[:err_general].should eq("ERROR MESSAGE")
    end

    it "should alert on empty credentials" do
      registrant = Factory.build(:registrant)
      post :login, {"registrant" => {"Email" => "", "Password" => ""}}
      response.should render_template 'login'
      assigns[:err_email].should_not be_nil
      assigns[:err_pass].should_not be_nil
    end

    context "remember me" do
      before(:each) do
        @registrant = Factory.build(:registrant)
        @registrant.id = 47
        Registrant.stub(:sign_in_remember_me).and_return(@registrant)
      end

      it "should login if correct remember me credentials are set" do
        Registrant.should_receive(:sign_in_remember_me).and_return(@registrant)
        request.cookies["remember_me_id"] = 2
        request.cookies["remember_me_code"] = 23232
        post :login
        response.should redirect_to(:action => 'manage_registry')
      end

      it "should clear session and redirect to manage_registry if remember me credential are invalid" do
        Registrant.stub(:sign_in_remember_me).and_return(@nil)
        request.cookies["remember_me_id"] = 2
        request.cookies["remember_me_code"] = 23232
        post :login
        response.should redirect_to(:action => 'home')
        response.cookies["remember_me_id"].should be_nil
        response.cookies["remember_me_code"].should be_nil
      end

      it "should set remember me cookies when remember me is set." do
        Registrant.stub(:sign_in).and_return(@registrant)
        post :login, {"registrant" => {"Email" => @registrant.Email, "Password" => @registrant.new_password}, "rememberMe" => 1}
        response.cookies["remember_me_id"].should == @registrant.id.to_s
        response.cookies["remember_me_code"].should_not be_nil
      end
    end
  end

  ##################################################################################################################

  describe "logout" do
    before(:each) do
      @registrant = Factory.build(:registrant)
      @registrant.id = 47
      Registrant.stub(:find).and_return(@registrant)
    end

    it "should clear the session info for the user" do
      get :logout, {}, {'registrant' => @registrant.id}
      session['registrant'].should be_nil
      session['registrantName'].should be_nil
    end

    it "should clear the cart from the session" do
      get :logout, {}, {'registrant' => @registrant.id}
      session['cart'].should be_nil

    end

    it "should clear the remember me info from the cookies" do
      request.cookies["remember_me_id"] = 2
      request.cookies["remember_me_code"] = 23232
      get :logout, {}, {'registrant' => @registrant.id}
      response.cookies["remember_me_id"].should be_nil
      response.cookies["remember_me_code"].should be_nil
    end

    it "should re-redirect the user to home" do
      get :logout, {}, {'registrant' => @registrant.id}
      response.should redirect_to(:action => 'home')
    end
  end

  ##################################################################################################################

  describe "register" do
    before(:each) do
      @registrant = Factory.create(:registrant)
      @registrant.id = 47

      Registrant.stub(:new).and_return(@registrant)
      @registrant.stub(:save).and_return(@registrant)
      MailUtilities.stub(:send_activation)
    end

    it "should render register view if not a post" do
      get :register
      response.should render_template("register")
    end

    it "should create a new user and save it" do
      @registrant = Factory.build(:registrant)
      Registrant.should_receive(:new).and_return(@registrant)
      @registrant.should_receive(:save).and_return(@registrant)

      post :register, {"registrant" => @registrant}
    end

    it "should send an email" do
      MailUtilities.should_receive(:send_welcome).with(@registrant.Email)

      post :register, {"registrant" => @registrant}
    end

    it "should redirect to the add_item page with the new user param set." do
      post :register, {"registrant" => @registrant}
      response.should redirect_to :action => :addgift, :new_user => @registrant.Email
    end

    it "should set session for valid user" do
      Cart.should_receive(:new)

      post :register, {"registrant" => {"Email" => @registrant.Email, "Password" => @registrant.new_password}}
      session['registrant'].should == @registrant.id
    end

  end

  ##################################################################################################################

  describe "registerfb" do
    context "User is already registered" do
      before(:each) do
        @fbuid = 123456
        @registrant = Factory.build(:registrant)
        @cart = Cart.new
        Registrant.stub(:fb_exists).with(@fbuid).and_return(@registrant)
        Registrant.stub(:sign_in_fb).with(@fbuid).and_return(@registrant)
        # @registrant.should_receive(:display_name).and_return("foo")
        Cart.stub(:new).and_return(@cart)
      end

      it "should log-in the user" do
        @registrant.should_not_receive(:new)
        Registrant.should_receive(:sign_in_fb).with(@fbuid).and_return(@registrant)

        post :registerfb, {"fbuid" => @fbuid, "Email" => @registrant.Email}
        response.body.should == "{\"url\":\"/manage_registry\"}"
      end

      it "should set the session for the user" do
        post :registerfb, {"fbuid" => @fbuid, "Email" => @registrant.Email}
        session['registrant'].should == @registrant.id
        # session['registrantName'].should == "foo"
      end

      it "should create a new cart for the user" do
        post :registerfb, {"fbuid" => @fbuid, "Email" => @registrant.Email}
        session['cart'].should == @cart
      end
    end

    context "User is already registered as a regular user" do
      before(:each) do
        @fbuid = 123456
        @registrant = Factory.build(:registrant)
        @cart = Cart.new
        Registrant.should_receive(:fb_exists).with(@fbuid).and_return(false)
        Registrant.should_receive(:email_exists).with(@registrant.Email).and_return(@registrant)
        Registrant.stub_chain(:where, :first).and_return(@registrant)
        @registrant.should_receive(:update_attribute).with(:fbuid, @fbuid).and_return(@registrant)
        Registrant.should_receive(:sign_in_fb).and_return(@registrant)
      end

      it "should log-in the user and convert them to a facebook user" do
        @registrant.should_not_receive(:new)
        post :registerfb, {"fbuid" => @fbuid, "Email" => @registrant.Email}
        response.body.should == "{\"url\":\"/manage_registry\"}"
      end

      it "should set the session for the user" do
        post :registerfb, {"fbuid" => @fbuid, "Email" => @registrant.Email}
        session['registrant'].should == @registrant.id
      end

      it "should create a new cart for the user" do
        Cart.should_receive(:new).and_return(@cart)
        post :registerfb, {"fbuid" => @fbuid, "Email" => @registrant.Email}
        session['cart'].should == @cart
      end

    end

    context "User is not registered as any kind of user" do
      before(:each) do
        @fbuid = 123456
        @registrant = Factory.build(:registrant)
        @cart = Cart.new
        Registrant.should_receive(:fb_exists).with(@fbuid).and_return(false)
        Registrant.stub(:create).and_return(@registrant)
        Registrant.should_receive(:email_exists).with(@registrant.Email).and_return(false)
        Registrant.should_receive(:sign_in_fb).and_return(@registrant)
      end

      it "should look up the state and set it if it exists" do
        state_double = double("State")
        state_double.stub(:id).and_return(1)

        State.should_receive(:find_by_Name).with("New York").and_return(state_double)
        Registrant.should_receive(:create!).with(hash_including(:State_ID => 1)).and_return(@registrant)

        post :registerfb, {"fbuid" => @fbuid, "Email" => @registrant.Email, "Location" => "New York, New York"}

      end

      it "should look up the state and set it to California if it does not exist." do
        state_double = double("State")
        state_double.stub(:id).and_return(2)

        State.stub(:find_by_Name).and_return(nil)
        State.should_receive(:find_by_Name).with("California").and_return(state_double)

        Registrant.should_receive(:create!).with(hash_including(:State_ID => 2)).and_return(@registrant)

        post :registerfb, {"fbuid" => @fbuid, "Email" => @registrant.Email, "Location" => "Toronto, Ontario"}
      end

      it "should create the user and log them in" do
        Registrant.should_receive(:create!).and_return(@registrant)
        post :registerfb, {"fbuid" => @fbuid, "Email" => @registrant.Email, "Location" => "New York, New York", :FirstName => "John", :LastName => "Smith"}
        response.body.should == "{\"url\":\"/addgift?new_user=facebook\"}"
      end

      it "should set the session for the user" do
        post :registerfb, {"fbuid" => @fbuid, "Email" => @registrant.Email, "Location" => "New York, New York", :FirstName => "John", :LastName => "Smith"}
        session['registrant'].should == @registrant.id
      end

      it "should create a new cart for the user" do
        Cart.should_receive(:new).and_return(@cart)
        post :registerfb, {"fbuid" => @fbuid, "Email" => @registrant.Email, "Location" => "New York, New York", :FirstName => "John", :LastName => "Smith"}
        session['cart'].should == @cart
      end

      it "should send an email" do

        MailUtilities.should_receive(:send_welcome).with(@registrant.Email)

        post :registerfb, {"fbuid" => @fbuid, "Email" => @registrant.Email, "Location" => "New York, New York", :FirstName => "John", :LastName => "Smith"}
      end
    end

    it "return error if a facebook id is not specified." do
      post :registerfb
      response.body.should == 'User Not Found'
    end

  end

  ##################################################################################################################

  describe "forgot password" do

    before(:each) do
      @registrant = Factory.build(:registrant)
      @registrant_id = 47
      Registrant.stub(:find).and_return(@registrant)
    end

    it "should render forgot password view if not a post" do
      get :forgotpassword, {}, {}

      response.should render_template("registrant/forgotpassword")
    end

    context "First Time Through - send the reset email" do
      before(:each) do
        @registrant = Factory.build(:registrant)
      end

      it "if valid email: should send an email and display a message if email is valid" do
        Registrant.should_receive(:email_exists).with(@registrant.Email).and_return(@registrant)
        MailUtilities.should_receive(:send_reset_password).with(@registrant)

        post :forgotpassword, {"registrant" => {:Email => @registrant.Email}}

        assigns[:email_sent].should == 2
        assigns[:err_email].should be_nil
        response.should render_template("registrant/forgotpassword")
      end

      it "if blank email: should not send an email and should display an error message" do
        MailUtilities.should_not_receive(:send_reset_password).with(@registrant)

        post :forgotpassword, {"registrant" => {:Email => ""}}

        assigns[:email_sent].should be_nil
        assigns[:err_email].should_not be_nil
        response.should render_template("registrant/forgotpassword")
      end

      it "if invalid email: should not send an email and should display an error message" do
        Registrant.should_receive(:email_exists).and_return(nil)
        MailUtilities.should_not_receive(:send_reset_password).with(@registrant)

        post :forgotpassword, {"registrant" => {:Email => "foo"}}

        assigns[:email_sent].should be_nil
        assigns[:err_email].should_not be_nil
        response.should render_template("registrant/forgotpassword")
      end

      it "if facebook email: should not send an email and should display an error message" do
        @registrant.fbuid = 12;
        Registrant.should_receive(:email_exists).with(@registrant.Email).and_return(@registrant)
        MailUtilities.should_not_receive(:send_reset_password).with(@registrant)

        post :forgotpassword, {"registrant" => {:Email => @registrant.Email}}

        assigns[:email_sent].should be_nil
        assigns[:err_email].should_not be_nil
        response.should render_template("registrant/forgotpassword")
      end
    end

    context "Second Time Through = Reset the password" do
      before(:each) do
        @registrant = Factory.build(:registrant)
      end

      it "if GUID valid: should reset the password and send it in an email." do
        Registrant.stub_chain(:where, :first).and_return(@registrant)
        @registrant.should_receive(:reset_password).and_return("NewPassword")
        MailUtilities.should_receive(:send_forgot_password).with(@registrant, "NewPassword")

        get :forgotpassword, {:id => @registrant.ImageGUID}

        assigns[:email_sent].should == 1
        response.should render_template("registrant/forgotpassword")
      end

      it "if GUID is invalid: should show an error message" do
        Registrant.stub_chain(:where, :first).and_return(nil)
        MailUtilities.should_not_receive(:send_forgot_password).with(@registrant, "NewPassword")

        get :forgotpassword, {:id => "FAKE"}

        assigns[:err_email].should_not be_nil
        response.should render_template("registrant/forgotpassword")
      end
    end
  end

  ##################################################################################################################

  describe "addgift" do
    before(:each) do
      @registrant = Factory.build(:registrant)
      @registrant_id = 47
      Registrant.stub(:find).and_return(@registrant)
    end

    it "should render profile view" do
      get :addgift, {}, {'registrant' => @registrant_id}
      response.should render_template("addgift")
    end

    it "should redirect to signin if user not logged in" do
      get :addgift, {}, {}
      response.should redirect_to signin_path
    end

    it "should set the registrant" do
      get :addgift, {}, {'registrant' => @registrant_id}
      assigns[:registrant].should == @registrant
    end

    it "should set that registrant is not new" do
      get :addgift, {}, {'registrant' => @registrant_id}
      assigns[:is_new].should == false
    end

    it "should set that registrant is new" do
      get :addgift, {:new_user => "facebook"}, {'registrant' => @registrant_id}
      assigns[:is_new].should == true
    end



  end
  ##################################################################################################################

  describe "profile" do

    before(:each) do
      @registrant = Factory.build(:registrant)
      @registrant_id = 47
      Registrant.stub(:find).and_return(@registrant)
    end

    context "Get" do
      it "should render profile view" do
        get :profile, {}, {'registrant' => @registrant_id}
        response.should render_template("profile")
      end

      it "should set the registrant" do
        get :profile, {}, {'registrant' => @registrant_id}
        assigns[:registrant].should == @registrant
      end

      it "should set states and types" do
        get :profile, {}, {'registrant' => @registrant_id}
        assigns[:states].should_not be_nil
        assigns[:types].should_not be_nil
      end
    end

    context "Post" do
      it "should redirect to the profile view in most cases" do
        post :profile, {:registrant => @registrant}, {'registrant' => @registrant_id}
        response.should redirect_to(:action => "profile")
      end

      it "should set the registrant" do
        post :profile, {:registrant => @registrant}, {'registrant' => @registrant_id}
        assigns[:registrant].should == @registrant
      end

      it "should set states and types" do
        post :profile, {:registrant => @registrant}, {'registrant' => @registrant_id}
        assigns[:states].should_not be_nil
        assigns[:types].should_not be_nil
      end

      it "should attempt to update the registrant" do
        @registrant.should_receive(:update_attributes).and_return(true)
        post :profile, {:registrant => @registrant}, {'registrant' => @registrant_id}
      end

      context "Post Data is Valid" do

        it "should flash a success message" do
          @registrant.should_receive(:update_attributes).and_return(true)
          post :profile, {:registrant => @registrant}, {'registrant' => @registrant_id}
          flash[:success].should eq("Your changes have been saved.")
        end
      end

      context "Post Data is invalid" do

        it "should not flash a success message" do
          @registrant.should_receive(:update_attributes).and_return(false)
          post :profile, {:registrant => @registrant}, {'registrant' => @registrant_id}
          flash[:success].should_not eq("Your changes have been saved.")
        end
      end

    end

  end

  ##################################################################################################################

  describe "delete_registry_item" do

    before(:each) do

      @registrant = Factory.build(:registrant)
      @registrant.id = 47
      @r2p1 = Factory.build(:registry_item, :registrant => @registrant, :Purchased_ID => RegistryItem::AVAILABLE, :Contributed => 0)
      Registrant.stub(:find).and_return(@registrant)
      RegistryItem.stub(:find).and_return(@r2p1)
      request.env["HTTP_REFERER"] = "SOURCE PAGE"
    end

    it "should render close_modal" do
      get :delete_registry_item, {:id => @r2p1.id}, {:registrant => @registrant.id}
      response.should render_template("shared/close_modal")
    end

    it "should delete the item from the registry" do
      RegistryItem.should_receive(:find).with(@r2p1.id).and_return(@r2p1)
      @r2p1.should_receive(:delete_from_registry)
      get :delete_registry_item, {:id => @r2p1.id}, {'registrant' => @registrant.id}
    end

    it "should raise an exception if an invalid ID is specified" do
      RegistryItem.stub(:find).and_return(nil)
      get :delete_registry_item, {:id => @r2p1.id}, {'registrant' => @registrant.id}
      response.should redirect_to "/buy/errorpage/#{ErrorMessages::NOT_FOUND}"
    end

    it "should raise an exception if the item has a contribution" do
      @r2p1.Contributed = 12
      RegistryItem.stub(:find).and_return(@r2p1)
      get :delete_registry_item, {:id => @r2p1.id}, {'registrant' => @registrant.id}
      response.should redirect_to "/buy/errorpage/#{ErrorMessages::CUSTOM}?message=You+can+not+delete+an+item+that+has+been+contributed+to."
    end

  end

  ##################################################################################################################

  describe "add_to_registrant" do

    before(:each) do

      @registrant = Factory.create(:registrant)
      @product = Factory.create(:product_with_params)
      @new_item = Factory.create(:registry_item, :registrant => @registrant, :product => @product, :Purchased_ID => RegistryItem::AVAILABLE)
      Product.stub(:find).and_return(@product)
    end

    it "should redirect to signin if user not logged in" do
      get :add_to_registrant, {:id => @product.id}
      response.should redirect_to signin_path
    end

    it "should calculate tax and shipping" do
      @product.should_receive(:tax).and_return(12)
      @product.should_receive(:Shipment).and_return(12)

      RegistryItem.stub(:new).and_return(@new_item)

      get :add_to_registrant, {:id => @product.id, :product_params => "[]"}, {'registrant' => @registrant.id}
    end

    it "should add the item to the registry" do
      @product.stub(:tax).and_return(12)
      @product.stub(:Shipment).and_return(12)

      RegistryItem.should_receive(:new).and_return(@new_item)

      get :add_to_registrant, {:id => @product.id, :product_params => "[]"}, {'registrant' => @registrant.id}
    end

    it "should set all the attributes" do
      @product.stub(:tax).and_return(12)
      @product.stub(:Shipment).and_return(10)
      quantity = 1
      color_id = 1

      RegistryItem.should_receive(:new).with(:Product_ID => @product.id, :Registrant_ID => @registrant.id,
                                             :Price => @product.Price, :Quantity => quantity, :Purchased_ID => RegistryItem::AVAILABLE,
                                             :Color_ID => color_id, :Tax => 12, :Shipment => 10).and_return(@new_item)

      get :add_to_registrant, {:pid => @product.id, :quantity => quantity, :color_id => color_id, :product_params => "[]"}, {'registrant' => @registrant.id}
    end

    it "should set params" do
      @product.stub(:tax).and_return(12)
      @product.stub(:Shipment).and_return(10)

      pp_name = @product.product_params[0].Name
      pp_value = @product.product_params[0].value_params[0].Value
      pp2o = ProductParams2order.new(:Name => pp_name, :Value => pp_value)
      quantity = 1
      color_id = 1

      RegistryItem.should_receive(:new).with(:Product_ID => @product.id, :Registrant_ID => @registrant.id,
                                             :Price => @product.Price, :Quantity => quantity, :Purchased_ID => RegistryItem::AVAILABLE,
                                             :Color_ID => color_id, :Tax => 12, :Shipment => 10).and_return(@new_item)

      BuyProduct.should_receive(:parse_params).and_return([pp2o])
      pp2o.should_receive(:save)

      get :add_to_registrant, {:pid => @product.id, :quantity => quantity, :color_id => color_id, :product_params => '[{"key":"3","value":"12"}]'}, {'registrant' => @registrant.id}
    end

    it "should mark a one of a kind item as taken" do
      @product.IsKind = true

      @product.stub(:tax).and_return(12)
      @product.stub(:Shipment).and_return(12)
      RegistryItem.stub(:new).and_return(@new_item)

      @product.should_receive(:update_attributes).with(:IsKindView => false)
      get :add_to_registrant, {:id => @product.id, :product_params => "[]"}, {'registrant' => @registrant.id}
    end

    it "should return 2 if successful " do
      @product.stub(:tax).and_return(12)
      @product.stub(:Shipment).and_return(12)

      RegistryItem.should_receive(:new).and_return(@new_item)
      @new_item.should_receive(:save).and_return(true)

      get :add_to_registrant, {:id => @product.id, :product_params => "[]"}, {'registrant' => @registrant.id}
      response.body.should == "2"
    end

    it "should return 1 if not successful " do
      @product.stub(:tax).and_return(12)
      @product.stub(:Shipment).and_return(12)

      RegistryItem.should_receive(:new).and_return(@new_item)
      @new_item.should_receive(:save).and_return(false)

      get :add_to_registrant, {:id => @product.id, :product_params => "[]"}, {'registrant' => @registrant.id}
      response.body.should == "1"
    end

  end

  ##################################################################################################################

  describe "addmyowngift" do

    before(:each) do
      @registrant = Factory.create(:registrant)
      Registrant.stub(:find).and_return(@registrant)

      @new_item = Factory.create(:registry_item_added_myself, :registrant => @registrant)
      @new_product = @new_item.product
      Product.stub(:find).and_return(@product)
    end

    it "should redirect to signin if user not logged in" do
      get :addmyowngift
      response.should redirect_to signin_path
    end

    describe "get" do
      it "should create a new registry_item object and a new product object" do
        RegistryItem.should_receive(:new).and_return(@new_item)
        Product.should_receive(:new).and_return(@new_item.product)

        get :addmyowngift, {}, {:registrant => @registrant.id}

        assigns[:item].should == @new_item
      end

      it "should render the form to create the item" do
        Product.stub(:new).and_return(@new_item.product)

        get :addmyowngift, {}, {:registrant => @registrant.id}

        response.should render_template(:registrant, :add_my_own_gift)

      end
    end

    describe "post" do
      # We should have a test about the image handling.
      before(:each) do

        RegistryItem.stub(:new).and_return(@new_item)

        @params = {"Name"=>"Name", "quantity"=>"5", "sales_tax"=>"3", "category_id"=>"111", "ImageGUID"=>"d4b1d52dfc9ea059b0d53541067bf7d1", "Description"=>"Desc", "use_tax"=>"1", "MasterPrice"=>"10", "ShipmentCost"=>"2"}
      end

      it "should create a new product with the specified params" do

        RegistryItem.should_receive(:new).with(@params).and_return(@new_item)

        post :addmyowngift, {"registry_item"=> @params}, {:registrant => @registrant.id}
      end

      it "should set some additional properties on the new item and product" do

        @new_item.should_receive(:registrant=)
        @new_item.should_receive(:Price=)
        @new_item.should_receive(:Purchased_ID=)

        @new_product.should_receive(:creator=)

        post :addmyowngift, {"registry_item"=> @params}, {:registrant => @registrant.id}
      end

      it "should save the item and re-render page if input were invalid." do

        @new_item.should_receive(:save).and_return(false)

        post :addmyowngift, {"registry_item"=> @params}, {:registrant => @registrant.id}

        response.should render_template(:registrant, :add_my_own_gift)
      end

      it "if item save is successful render the close modal page with the correct params. (Stock Image)" do
        @new_item.stub(:save).and_return(true)
        @new_product.stock_image = 12

        post :addmyowngift, {"registry_item"=> @params}, {:registrant => @registrant.id}

        response.should render_template(:shared, :close_modal)
        assigns[:status].should == true
        assigns[:call].should == "crop_image"
        assigns[:param].should == "/manage_registry"
      end

      it "if item save is successful render the close modal page with the correct params. (Custom Image)" do
        @new_item.stub(:save).and_return(true)

        post :addmyowngift, {"registry_item"=> @params}, {:registrant => @registrant.id}

        response.should render_template(:shared, :close_modal)
        assigns[:status].should == true
        assigns[:call].should == "addmyowngift"
      end
    end
  end

  ##################################################################################################################

  describe "edit_registry_item" do

    before(:each) do
      @registrant = double("Registrant", id: 11)
      Registrant.stub(:find).and_return(@registrant)
      @registry_items = double("Registry items")
      @registrant.stub(:registry_items).and_return(@registry_items)
      @reg_item = mock("Registry_item", id: 22)
      @registry_items.stub(:find).and_return(@reg_item)
      @product1 = double("Product")
      @reg_item.stub(:product).and_return @product
      @reg_item.stub(:IsDeleted?).and_return false
      @reg_item.stub(:update_attributes).and_return(true)

      @attributes = double("attributes")
      @params = double("params")

    end

    context "Get" do
      it "should redirect to signin if user not logged in" do
        get :edit_registry_item, {:id => @reg_item.id}, {}
        response.should redirect_to signin_path
      end

      it "should render edit_registry_item view" do
        @registry_items.should_receive(:find).with(@reg_item.id).and_return(@reg_item)
        get :edit_registry_item, {:id => @reg_item.id}, {'registrant' => @registrant.id}
        response.should render_template("edit_registry_item")
      end

      it "should set the registry_item" do
        reg_item_id = double("Registry_item")
        @registry_items.should_receive(:find).with(reg_item_id).and_return(@reg_item)
        get :edit_registry_item, {:id => reg_item_id}, {'registrant' => @registrant.id}
        assigns[:reg_item].should == @reg_item
      end

      it "should raise an exception if an invalid ID is specified" do
        @registry_items.stub(:find).and_return(nil)
        expect {get :edit_registry_item, {:id => @reg_item.id}, {'registrant' => @registrant.id}}.to raise_exception(StandardError, "Item not found")
      end

      it "should raise an exception if item is deleted" do
        @reg_item.stub(:IsDeleted?).and_return(true)
        expect {get :edit_registry_item, {:id => @reg_item.id}, {'registrant' => @registrant.id}}.to raise_exception(StandardError, "Item not found")
      end
    end

    context "Put" do
      it "should update attributes params" do

        @reg_item.should_receive(:update_attributes).and_return(true)

        put :edit_registry_item, {:id => @reg_item.id, :registry_item => @attributes}, {'registrant' => @registrant.id}

      end

      it "should set params" do
        @reg_item.should_receive(:reset_params).with(@params)

        put :edit_registry_item, {:id => @reg_item.id, :registry_item => @attributes, :product_params => @params}, {'registrant' => @registrant.id}

      end

      it "should render close model for success" do
        put :edit_registry_item, {:id => @reg_item.id, :registry_item => @attributes}, {:registrant => @registrant.id}

        assigns[:status].should == 5
        assigns[:param].should == @reg_item.id
        response.should render_template("shared/close_modal")
      end

      it "should re-render if their was a validation error." do
        put :edit_registry_item, {:id => @reg_item.id, :registry_item => @attributes}, {:registrant => @registrant.id}

        @registry_items.should_receive(:find).with(@reg_item.id).and_return(@reg_item)
        get :edit_registry_item, {:id => @reg_item.id}, {'registrant' => @registrant.id}
        assigns[:reg_item].should == @reg_item
        response.should render_template("edit_registry_item")
      end


      it "should raise an exception if an invalid ID is specified" do
        @registry_items.stub(:find).and_return(nil)
        expect {
          put :edit_registry_item, {:id => @reg_item.id, :registry_item =>@attributes}, {:registrant => @registrant.id}
        }.to raise_exception(StandardError, "Item not found")
      end
    end
  end

  ##################################################################################################################

  describe "registry" do

    before(:each) do
      @registrant = Factory.create(:registrant)
      @registry_owner = Factory.create(:registrant)
      Registrant.stub(:find).and_return(@registrant)
      @product1 = Factory.create(:product)
      @reg_item = Factory.create(:registry_item, :registrant => @registry_owner, :product => @product1, :Purchased_ID => RegistryItem::AVAILABLE)
    end

    it "should redirect to give if no registry is specified" do
      Registrant.stub(:find_by_id_and_IsDeleted).and_return(nil)
      get :registry, {:id => @registry_owner.id}, {}
      response.should redirect_to give_path
    end

    it "should assign @registrant" do
      Registrant.stub(:find_by_id_and_IsDeleted).and_return(@registry_owner)
      get :registry, {:id => @registry_owner.id}, {:registrant => @registrant}
      assigns[:registrant].should == @registrant
    end

    it "should assign @registry" do
      Registrant.should_receive(:find_by_id_and_IsDeleted).with(@registry_owner.id, false).and_return(@registry_owner)
      get :registry, {:id => @registry_owner.id}, {}
      assigns[:registry].should == @registry_owner
    end

    context "when request is put" do
      before(:each) do
        Registrant.stub(:find).and_return(@registry_owner)
      end

      it "should update registry description" do
        Registrant.stub(:find_by_id_and_IsDeleted).and_return(@registry_owner)
        @registry_owner.should_receive(:update_attributes).and_return(true)
        put :registry, {:id => @registry_owner.id, :registrant => {:Description => "foo"}}, {'registrant' => @registry_owner.id}
      end

      it "should redirect back to registry after save" do
        Registrant.stub(:find_by_id_and_IsDeleted).and_return(@registry_owner)
        @registry_owner.stub(:update_attributes).and_return(true)
        put :registry, {:id => @registry_owner.id, :registrant => {:Description => "foo"}}, {'registrant' => @registry_owner.id}
        response.should redirect_to(:registry)
      end
    end

    it "should not modify anything if the registry does not belong to the user" do
      Registrant.stub(:find).and_return(@registrant)
      Registrant.stub(:find_by_id_and_IsDeleted).and_return(@registry_owner)
      @registry_owner.should_not_receive(:update_attributes)
      put :registry, {:id => @registry_owner.id, :registrant => {:Description => "foo"}}, {'registrant' => @registrant.id}
    end

  end

  describe "extaddgift" do
    before(:each) do
      @registrant = double("Registrant")
      Registrant.stub(:find).and_return(@registrant)
      @registrant_id = double("Registrant ID")

      @name = "Name"
      @image_url = double("Image URL")

      @section_id = double("Section ID")
      Section.stub(:exists?).and_return(true)

      @params = {:t => @name, :p => 10, :quantity => 2, :i => @image_url, :d => "Description", :s => "site URL", :n => @registrant_id, :j => 1, :sec => @section_id, :ec => "Red", :es => "Large", :eo => "Please get the one that is monogramed"}
      @item = double("Item")


      URI.stub(:escape).and_return(@image_url)
      URI.stub(:unescape).and_return(@name)
    end

    it "should get the image from the url, scale it and then save it with the item." do
      raw_image = double("raw_image")

      ImageUtilities.should_receive(:get_image_by_url).with(@image_url).and_return(raw_image)

      Product.should_receive(:new).with(hash_including(:main_product_image => raw_image))

      get :extaddgift, @params
    end

    it "should create a new product with supplied info." do
      Product.should_receive(:create!).with(hash_including(:Name => @params[:t], :MasterPrice => @params[:p], :Description => @params[:d]))
      get :extaddgift, @params
    end

    it "should create the new product as an external product." do
      Product.should_receive(:create!).with(hash_including(:external => true))
      get :extaddgift, @params
    end

    it "should create a new product with the supplied store url and name." do
      @params[:s] = "www.macys.com/213213/fdsf-s_dfdsf/3243243?sfdsf=343243&dfsdfdsfdf=dfdsfds"
      @params[:n] = "macys.com"

      Product.should_receive(:create!).with(hash_including(:source_name => @params[:n], :source_url => @params[:s]))
      get :extaddgift, @params
    end

    it "should create a new product with the supplied varients." do

      Product.should_receive(:create!).with(hash_including(:ext_color => @params[:ec],:ext_size => @params[:es],:ext_other => @params[:eo]))

      get :extaddgift, @params
    end

    it "should cut the name to 50 characters and description to 900 characters." do
      @params[:t] = "t" * 55
      @params[:d] = "d" * 955
      URI.stub(:unescape).and_return("t" * 55)

      Product.should_receive(:create!).with(hash_including(:Name => ("t" * 50), :Description => ("d" * 900)))

      get :extaddgift, @params
    end

    it "should return an error is the new product is not valid." do
      Product.should_receive(:create!).with(hash_including(:Name => @params[:t], :MasterPrice => @params[:p], :Description => @params[:d])).and_throw("Exception")

      get :extaddgift, @params

      response.body.should == 'knackGetAddRequest("1");'
    end

    context "product is valid" do
      before(:each) do
        @product = double("product")
        Product.stub(:create!).and_return(@product)
      end

      it "Should create registry item with information supplied by user." do

        @product.stub_chain(:registry_items, :create!).with(hash_including(:Registrant_ID => @params[:r], :Price => @params[:p], :Quantity => @params[:q]))

        get :extaddgift, @params
      end

      it "Should set the item as a toolbar item." do

        @product.stub_chain(:registry_items, :create!).with(hash_including(:IsToolbar => true))

        get :extaddgift, @params
      end

      it "Should check that the supplied section exists and set the registry item to the section if it does." do
        Section.should_receive(:exists?).with(@section_id).and_return(true)
        @product.stub_chain(:registry_items, :create!).with(hash_including(:section_id => @section_id))

        get :extaddgift, @params
      end

      it "Should check that the supplied section exists and set the registry item to the default section if it does not." do
        Section.should_receive(:exists?).with(@section_id).and_return(false)
        @product.stub_chain(:registry_items, :create!).with(hash_including(:section_id => nil))

        get :extaddgift, @params
      end

      it "Should return success message if save was successful." do

        @product.stub_chain(:registry_items, :create!)

        get :extaddgift, @params

        response.body.should == 'knackGetAddRequest("0");'
      end

      it "Should return error message if save was not successful." do

        @product.stub_chain(:registry_items, :create!).and_raise("Exception")

        get :extaddgift, @params

        response.body.should == 'knackGetAddRequest("1");'
      end

    end
  end

  describe "ext_sections" do
    before(:each) do
      @registrant = double("Registrant")
      @registrant_id = 12
      Registrant.stub(:find).and_return(@registrant)
      @section1 = Factory(:section, :title => "section 1 title")
      @section2 = Factory(:section, :title => "section 2 title")
      @registrant.stub(:sections).and_return([@section1, @section2])
    end

    it "should look up the registrant" do
      Registrant.should_receive(:find).with(@registrant_id).and_return(@registrant)
      get :ext_sections, {:id => @registrant_id}
    end

    it "should get the sections" do
      @registrant.should_receive(:sections).and_return(@sections)
      get :ext_sections, {:id => @registrant_id}
    end

    it "should return the id and name of the sections" do
      get :ext_sections, {:id => @registrant_id}
      response.body.should == 'knackLoadSections('+[@section1, @section2].to_json(:only => [:id, :title])+');'
    end

  end

end
