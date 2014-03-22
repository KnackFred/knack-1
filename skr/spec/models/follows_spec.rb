require "spec_helper"

describe "Follows" do
  ###############################
  ## VALIDATIONS
  ###############################
  describe "Validations" do

    before(:each) do
      @registrant = Factory.create(:registrant)
      @registrant2 = Factory.create(:registrant)
    end

    it "should allow a follow to be created" do
      object = Follow.new(:registrant => @registrant, :followed => @registrant2)
      object.valid?().should be_true
    end

    it "should not allow a follow to be created without a source" do
      object = Follow.new(:registrant => nil, :followed => @registrant2)
      object.valid?().should be_false
    end

    it "should not allow a follow to be created without a destination" do
      object = Follow.new(:registrant => @registrant, :followed => nil)
      object.valid?().should be_false
    end

    it "should not allow a self referencing follow." do
      object = Follow.new(:registrant => @registrant, :followed => @registrant)
      object.valid?().should be_false
    end

    it "should not allow a duplicate follow." do
      object = Follow.new(:registrant => @registrant, :followed => @registrant)
      object2 = Follow.new(:registrant => @registrant, :followed => @registrant)
      object2.valid?().should be_false
    end
  end
end

