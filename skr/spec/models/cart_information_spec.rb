require "spec_helper"

describe CartInformation do
  subject { CartInformation.new(:list_registry_items => []) }

  it "indicates that the cart has a single registrant" do
    registrant = Factory.create(:registrant)
    subject.list_registry_items << Factory.create(:registry_item, :registrant => registrant)
    subject.list_registry_items << Factory.create(:registry_item, :registrant => registrant)
    subject.should be_single_registrant
  end

  it "indicates when the cart has more than one registrant" do
    subject.list_registry_items << Factory.create(:registry_item, :registrant => Factory.create(:registrant))
    subject.list_registry_items << Factory.create(:registry_item, :registrant => Factory.create(:registrant))
    subject.should_not be_single_registrant
  end

  it "groups by registrant" do
    registry_item1 = BuyRegistryItem.new(item: Factory.create(:registry_item, :registrant => (registrant1 = Factory.create(:registrant))))
    registry_item2 = BuyRegistryItem.new(item: Factory.create(:registry_item, :registrant => (registrant2 = Factory.create(:registrant))))
    subject.list_registry_items << registry_item1
    subject.list_registry_items << registry_item2
    subject.registry_items_by_registrant.should have(2).things
    subject.registry_items_by_registrant[registrant1].should == [registry_item1]
    subject.registry_items_by_registrant[registrant2].should == [registry_item2]
  end

  it "lists registry item of a particular registrant" do
    registry_item1 = BuyRegistryItem.new(item: Factory.create(:registry_item, :registrant => (registrant1 = Factory.create(:registrant))))
    registry_item2 = BuyRegistryItem.new(item: Factory.create(:registry_item, :registrant => (registrant2 = Factory.create(:registrant))))
    subject.list_registry_items << registry_item1
    subject.list_registry_items << registry_item2
    subject.registry_items_for(registrant1).should == [registry_item1]
  end
end
