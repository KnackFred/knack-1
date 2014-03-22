require "spec_helper"

describe AdministrativeController do
  before(:each) do
    @administrator = Factory.create(:partner)
    session[:knack] = @administrator.id
  end

#####################################################################################
  describe "toggle partner deleted" do
    before(:each) do
      @category_root = Category.root
      @partner = Factory.build(:partner)
    end

    it "should redirect to the partner login page, when not authenticated administrator" do
      session[:knack] = nil
      post :toggle_partner_deleted, {:id => "12"}
      response.should redirect_to :controller => :partner, :action => :partnerslogin
    end

    it "should find the partner" do
      Partner.should_receive(:find).ordered.with(@administrator.id).and_return(@administrator)
      Partner.should_receive(:find).ordered.with("12").and_return(@partner)
      post :toggle_partner_deleted, {:id => "12"}
    end

    it "should change active partner to deleted and return new status" do
      @partner.IsDeleted = false
      Partner.stub(:find).and_return(@administrator, @partner)
      @partner.should_receive(:update_attribute).with(:IsDeleted, true)
      post :toggle_partner_deleted, {:id => "12"}
      #response.body.should == "Deleted"
    end

    it "should change deleted partner to active and return new status" do
      @partner.IsDeleted = true
      Partner.stub(:find).and_return(@administrator, @partner)
      @partner.should_receive(:update_attribute).with(:IsDeleted, false)
      post :toggle_partner_deleted, {:id => "12"}
      #response.body.should == "Active"
    end
  end

  #####################################################################################
  describe "toggle partner activated" do
    before(:each) do
      @category_root = Category.root
      @partner = Factory.build(:partner)
    end

    it "should redirect to the partner login page, when not authenticated administrator" do
      session[:knack] = nil
      post :toggle_partner_activated, {:id => "12"}
      response.should redirect_to :controller => :partner, :action => :partnerslogin
    end

    it "should find the partner" do
      Partner.should_receive(:find).ordered.with(@administrator.id).and_return(@administrator)
      Partner.should_receive(:find).ordered.with("12").and_return(@partner)
      post :toggle_partner_activated, {:id => "12"}
    end

    it "should change not-activated partner to activated and return new status" do
      @partner.IsActivated = false
      Partner.stub(:find).and_return(@administrator, @partner)
      @partner.should_receive(:update_attribute).with(:IsActivated, true)
      post :toggle_partner_activated, {:id => "12"}
      #response.body.should == "Activated"
    end

    it "should change activated partner to not-activated and return new status" do
      @partner.IsActivated = true
      Partner.stub(:find).and_return(@administrator, @partner)
      @partner.should_receive(:update_attribute).with(:IsActivated, false)
      post :toggle_partner_activated, {:id => "12"}
      #response.body.should == "Not Activated"
    end
  end

end