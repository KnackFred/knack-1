require 'spec_helper'

describe OrderLineItem do
  let(:registry_item) { FactoryGirl.create(:registry_item) }

  it "updates Contribute on the registry item on create" do
    registry_item = FactoryGirl.create(:registry_item, :Contributed => 100)
    OrderLineItem.create(:registry_item_id => registry_item.id, :amount => 10)
    registry_item.reload.Contributed.should == 110
  end
end
