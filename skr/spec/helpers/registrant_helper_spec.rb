require "spec_helper"

describe RegistrantHelper do
  include RegistrantHelper

  describe "contributor names" do
    let(:item) { Factory.create(:registry_item) }

    it "when there are none" do
      contributor_names(item).should == ""
    end

    it "when there is only one" do
      Factory.create(:contribute, :From => "Clark Kent", :registry_item => item)
      contributor_names(item.reload).should == "Clark Kent"
    end

    it "when there are two" do
      Factory.create(:contribute, :From => "Clark Kent", :registry_item => item)
      Factory.create(:contribute, :From => "Peter Parker", :registry_item => item)
      contributor_names(item.reload).should == "Clark Kent and Peter Parker"
    end

    it "when there are more than two" do
      Factory.create(:contribute, :From => "Clark Kent", :registry_item => item)
      Factory.create(:contribute, :From => "Peter Parker", :registry_item => item)
      Factory.create(:contribute, :From => "J'onn J'onzz", :registry_item => item)
      contributor_names(item.reload).should == "Clark Kent, Peter Parker and J'onn J'onzz"
    end
  end
end
