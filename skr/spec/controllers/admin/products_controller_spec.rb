require 'spec_helper'


describe Admin::ProductsController do

  def valid_session
    {
        :partner => @partner_id
    }
  end

  def valid_attributes
    Factory.attributes_for(:product).merge({:store_ids => [@partner.stores.first.id], :category_ids => [Category.root.children[0].id]})
  end

  before(:each) do
    @partner_id = double("Partner ID")
    @partner = Factory.create(:partner)
    Partner.stub(:find).and_return(@partner)
  end

  describe "GET index" do

    before(:each) do
      @products = double("products")
      @filter = double("filter")
      @filter.stub(:partner_id=)
      FilterProduct.stub(:new).and_return(@filter)
      Product.stub(:get_query_find_products_for_partner).and_return(@products)
    end

    it "Should create new params if params were not specified" do
      FilterProduct.should_receive(:new).and_return(@filter)
      get :index, {}, valid_session
      assigns(:filter).should eq(@filter)
    end

    it "Should create new params using params that were specified" do
      params = double("params")
      FilterProduct.should_receive(:new).with(params).and_return(@filter)
      get :index, {:filter => params}, valid_session
      assigns(:filter).should eq(@filter)
    end

    it "Should set the partner id to limit the scope" do
      partner_id = double("partner id")
      @partner.stub(:id).and_return(partner_id)
      @filter.should_receive(:partner_id=).with(partner_id)

      get :index, {}, valid_session
    end

    it "assigns all products matching params" do
      Product.should_receive(:get_query_find_products_for_partner).and_return(@products)
      get :index, {}, valid_session
      assigns(:products).should eq(@products)
    end
  end

  describe "GET new" do
    it "assigns a new product as @product, and a new product_param" do
      @product = Factory.build(:product)
      @product_params = double("ProductParams")

      Product.should_receive(:new).and_return(@product)
      ProductParams.should_receive(:new).and_return(@product_params)

      get :new, {}, valid_session

      assigns(:product).should == @product
      assigns(:product_params).should == @product_params
    end
  end

  describe "GET edit" do
    before(:each) do
      @product_id = double("product id")
      @product = Factory.build(:product, :stores => [@partner.stores.first])
      @product_params = double("ProductParams")

      Product.stub(:find).and_return(@product)
    end

    it "assigns the requested product as @product, and creates the product_params" do
      Product.should_receive(:find).and_return(@product)
      ProductParams.should_receive(:new).and_return(@product_params)

      get :edit, {:id => @product_id}, valid_session

      assigns(:product).should eq(@product)
      assigns(:product_params).should_not eq(nil)
    end

    it "should raise an exception if products does not belong to partner" do
      @product.stores = [Factory.build(:store)]
      lambda {
        get :edit, {:id => @product_id}, valid_session
      }.should raise_exception Exceptions::AccessDenied
    end

  end

  describe "POST create" do

    before(:each) do
      Brand.stub(:get_brand_id_from_product_params)
    end

    it "should check for the existence of or create the brand" do
      Brand.should_receive(:get_brand_id_from_product_params)
      post :create, {:product => valid_attributes}, valid_session
    end

    describe "with valid params" do
      it "creates a new Product" do
        expect {
        post :create, {:product => valid_attributes}, valid_session
        }.to change(Product, :count).by(1)
      end

      it "should create a new product and assign it to a @product" do
        post :create, {:product => valid_attributes}, valid_session
        assigns(:product).should be_a(Product)
        assigns(:product).should be_persisted
      end

      it "redirects to the crop image page" do
        post :create, {:product => valid_attributes}, valid_session
        response.should redirect_to({:controller => :products, :action => :image, :id => Product.last.id})
      end

      it "should expire caching of brand information " do
        controller.should_receive(:expire_brands_cache)
        post :create, {:product => valid_attributes}, valid_session
      end

    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved product as @product" do
        Product.any_instance.stub(:save).and_return(false)
        post :create, {:product => valid_attributes}, valid_session
        assigns(:product).should be_a_new(Product)
      end

      it "re-renders the 'new' template" do
        Product.any_instance.stub(:save).and_return(false)
        post :create, {:product => valid_attributes}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do

    before(:each) do
      Brand.stub(:get_brand_id_from_product_params)
    end

    it "should raise an exception if product does not belong to partner" do
      product = Factory.create(:product)
      Product.stub(:find).and_return(product)
      lambda {
        put :update, {:id => product.to_param, :product => valid_attributes}, valid_session
      }.should raise_exception Exceptions::AccessDenied
    end

    it "should check for the existence of or create the brand" do
      product = Factory.create(:product, :stores => [@partner.stores.first])

      Brand.should_receive(:get_brand_id_from_product_params)

      put :update, {:id => product.to_param, :product => valid_attributes}, valid_session
    end

    describe "with valid params" do
      it "updates the requested product" do
        product = Factory.create(:product, :stores => [@partner.stores.first])
        Product.any_instance.should_receive(:update_attributes).with(hash_including({'these' => 'params'}))
        put :update, {:id => product.to_param, :product => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested product as @product" do
        product = Factory.create(:product, :stores => [@partner.stores.first])
        put :update, {:id => product.to_param, :product => valid_attributes}, valid_session
        assigns(:product).should eq(product)
      end

      it "redirects to the crop image page if no image specified" do
        product = Factory.create(:product, :stores => [@partner.stores.first])
        put :update, {:id => product.to_param, :product => valid_attributes}, valid_session
        response.should redirect_to({:controller => :products, :action => :image, :id => product})
      end

      it "redirects to the product if no image specified" do
        product = Factory.create(:product, :stores => [@partner.stores.first])
        attributes = valid_attributes
        attributes.delete(:main_product_image)
        put :update, {:id => product.to_param, :product => attributes}, valid_session
        response.should redirect_to({:controller => :products, :action => :edit, :id => product})
      end

    end

    describe "with invalid params" do
      it "assigns the product as @product" do
        product = Factory.create(:product, :stores => [@partner.stores.first])
        Product.any_instance.stub(:save).and_return(false)
        put :update, {:id => product.to_param, :product => valid_attributes}, valid_session
        assigns(:product).should eq(product)
      end

      it "re-renders the 'edit' template" do
        product = Factory.create(:product, :stores => [@partner.stores.first])
        Product.any_instance.stub(:save).and_return(false)
        put :update, {:id => product.to_param, :product => valid_attributes}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "GET image" do
    before(:each) do
      @product_id = double("product id")
      @product = Factory.build(:product, :stores => [@partner.stores.first])

      Product.stub(:find).and_return(@product)
    end

    it "assigns the requested product as @product" do
      Product.should_receive(:find).and_return(@product)

      get :image, {:id => @product_id}, valid_session

      assigns(:product).should eq(@product)
    end

    it "should raise an exception if products does not belong to partner" do
      @product.stores = [Factory.build(:store)]
      lambda {
        get :image, {:id => @product_id}, valid_session
      }.should raise_exception Exceptions::AccessDenied
    end

    it "should render the crop template" do
      get :image, {:id => @product_id}, valid_session
      response.should render_template("shared/crop_image")
    end
  end

  describe "PUT image" do

    it "should raise an exception if products does not belong to partner" do
      product = Factory.create(:product)
      Product.stub(:find).and_return(product)
      lambda {
        put :image, {:id => product.to_param, :product => valid_attributes}, valid_session
      }.should raise_exception Exceptions::AccessDenied
    end

    describe "with valid params" do
      it "updates the requested product" do
        product = Factory.create(:product, :stores => [@partner.stores.first])
        Product.any_instance.should_receive(:update_attributes).with(hash_including({'these' => 'params'}))
        put :image, {:id => product.to_param, :product => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested product as @product" do
        product = Factory.create(:product, :stores => [@partner.stores.first])
        put :image, {:id => product.to_param, :product => valid_attributes}, valid_session
        assigns(:product).should eq(product)
      end

      it "redirects to the edit page for the product" do
        product = Factory.create(:product, :stores => [@partner.stores.first])
        put :image, {:id => product.to_param, :product => valid_attributes}, valid_session
        response.should redirect_to({:controller => :products, :action => :edit, :id => product})
      end

    end

    describe "with invalid params" do
      it "assigns the product as @product" do
        product = Factory.create(:product, :stores => [@partner.stores.first])
        Product.any_instance.stub(:save).and_return(false)
        put :image, {:id => product.to_param, :product => valid_attributes}, valid_session
        assigns(:product).should eq(product)
      end

      it "re-renders the 'image' template" do
        product = Factory.create(:product, :stores => [@partner.stores.first])
        Product.any_instance.stub(:save).and_return(false)
        put :image, {:id => product.to_param, :product => valid_attributes}, valid_session
        response.should render_template("image")
      end
    end
  end

end
