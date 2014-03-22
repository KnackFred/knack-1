require 'spec_helper'

describe Admin::PartnerAdministratorsController do

  def valid_session
    {
        :partner => @partner_id
    }
  end

  def valid_attributes
    Factory.attributes_for(:partner_administrator).merge({:partner_id => [@partner_id]})
  end

  before(:each) do
    @partner_id = double("Partner ID")
    @partner = Factory.create(:partner)
    Partner.stub(:find).and_return(@partner)
  end

  describe "GET index" do

    it "Should retrieve all administrators for the partner and assign it to the param" do
      result = double("result")
      paged_result = double("paginated result")
      result.stub(:paginate).and_return(paged_result)

      @partner.should_receive(:partner_administrators).and_return(result)

      get :index, {}, valid_session

      assigns(:administrators).should eq(paged_result)
    end
  end

  describe "GET new" do
    it "assigns a new admin as @administrator" do
      @admin = double("admin")

      PartnerAdministrator.should_receive(:new).and_return(@admin)

      get :new, {}, valid_session

      assigns(:administrator).should == @admin
    end
  end

  describe "GET edit" do
    before(:each) do
      @admin_id = double("admin id")
      @admin = double("admin")
    end

    it "find the specified admin (only on the partner and assigns the requested admin as @administrator" do
      @partners_admins = double("partners_admins")
      @partner.stub(:partner_administrators).and_return(@partners_admins)
      @partners_admins.should_receive(:find).and_return(@admin)

      get :edit, {:id => @admin_id}, valid_session

      assigns(:administrator).should eq(@admin)
    end

  end

  describe "POST create" do

    describe "with valid params" do
      it "creates a new admin" do
        expect {
          post :create, {:partner_administrator => valid_attributes}, valid_session
        }.to change(PartnerAdministrator, :count).by(1)
      end

      it "should create a new admin and assign it to @administrator" do
        post :create, {:partner_administrator => valid_attributes}, valid_session
        assigns(:administrator).should be_a(PartnerAdministrator)
        assigns(:administrator).should be_persisted
      end

      it "redirects to the admin index page" do
        post :create, {:partner_administrator => valid_attributes}, valid_session
        response.should redirect_to(admin_partner_administrators_path)
      end

    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved admin as @administrator" do
        PartnerAdministrator.any_instance.stub(:save).and_return(false)
        post :create, {:partner_administrator => valid_attributes}, valid_session
        assigns(:administrator).should be_a_new(PartnerAdministrator)
      end

      it "re-renders the 'new' template" do
        PartnerAdministrator.any_instance.stub(:save).and_return(false)
        post :create, {:partner_administrator => valid_attributes}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do

    before (:each) do
      @admin = Factory.build(:partner_administrator, :partner => @partner)

      @partners_admins = double("partners_admins")
      @partner.stub(:partner_administrators).and_return(@partners_admins)
      @partners_admins.should_receive(:find).and_return(@admin)

      @admin.stub(:update_attributes).and_return(true)

    end

    describe "with valid params" do
      it "updates the requested admin" do
        @admin.should_receive(:update_attributes).with(hash_including({'these' => 'params'}))
        put :update, {:id => 1, :partner_administrator => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested adminstrator as @administrator" do
        put :update, {:id => 1, :partner_administrator => valid_attributes}, valid_session
        assigns(:administrator).should eq(@admin)
      end

      it "redirects to the administrators index page." do
        put :update, {:id => 1, :partner_administrator => valid_attributes}, valid_session
        response.should redirect_to(admin_partner_administrators_path)
      end

    end

    describe "with invalid params" do
      before(:each) do
        @admin.stub(:update_attributes).and_return(false)
      end
      it "assigns the admin as @administrators" do
        put :update, {:id => 1, :partner_administrator => valid_attributes}, valid_session
        assigns(:administrator).should eq(@admin)
      end

      it "re-renders the 'edit' template" do
        put :update, {:id => 1, :partner_administrator => valid_attributes}, valid_session
        response.should render_template("edit")
      end
    end
  end
end
