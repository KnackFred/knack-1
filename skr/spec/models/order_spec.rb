require 'spec_helper'

describe Order do
  let(:registry_item) { FactoryGirl.create(:registry_item) }
  let(:registrant) { FactoryGirl.create(:registrant) }

  it "creats an empty order" do
    order = Order.create_order(registrant, [])
    order.registrant.should == registrant
  end

  it "creates an order with a buy registry item" do
    order = Order.create_order(registrant, [BuyRegistryItem.new(:item => registry_item, :contribute => 100, :from => 'Foo', :notes => 'Congrats')])
    order.order_line_items.should have(1).thing
    order.order_line_items[0].registry_item.should == registry_item
    order.order_line_items[0].amount.should == 100
    order.order_line_items[0].from.should == 'Foo'
    order.order_line_items[0].notes.should == 'Congrats'
  end
end
