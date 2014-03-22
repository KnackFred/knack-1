require 'spec_helper'

describe FollowsController do

  # This should return the minimal set of attributes required to create a valid
  # Follow. As you add validations to Follow, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end
  
  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # FollowsController. Be sure to keep this updated too.
  def valid_session
    {
        :registrant => @registrant.id
    }
  end

  def valid_attributes
    {
        :id => @registrant2.id,
        :format => :json
    }
  end

  before(:each) do
    @registrant = Factory.create(:registrant)
    @registrant2 = Factory.create(:registrant)
    Registrant.stub(:find).and_return(@registrant)
  end


  describe "GET index" do
    it "assigns all followed registrants as @followed" do
      follows = double("Follows Array")
      @registrant.should_receive(:followed_registrants).and_return(follows)

      get :index, {}, valid_session

      assigns(:registrant).should eq(@registrant)
      assigns(:followed).should eq(follows)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "creates a new Follow" do
        expect {
          post :create, valid_attributes, valid_session
        }.to change(Follow, :count).by(1)
      end

      it "return success and a JSON object" do
        post :create, valid_attributes, valid_session
        response.should be_success
      end

    end

    describe "with invalid params" do
      it "returns an error" do
        # Trigger the behavior that occurs when invalid params are submitted
        Follow.any_instance.stub(:save).and_return(false)
        expect {
          post :create, valid_attributes, valid_session
        }.to change(Follow, :count).by(0)
        response.should_not be_success
      end

    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @registrant.followed_registrants << @registrant2

    end

    it "destroys the requested follow" do
      expect {
        delete :destroy, {:id => @registrant2.id, :format => :json}, valid_session
      }.to change(Follow, :count).by(-1)
    end

    it "return success and a JSON object" do
      delete :destroy, {:id => @registrant2.id, :format => :json}, valid_session
      response.should be_success
    end
  end

  describe "follow_fb_friends" do
    it "Should call the model method" do
      friends = double("ID's")

      @registrant.should_receive(:follow_fb_friends).with(friends)

      post :follow_fb_friends, {:friends => friends, :format => :json}, valid_session
    end
  end

end
