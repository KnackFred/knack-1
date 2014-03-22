require 'spec_helper'

describe ContributeObserver do
  describe "add_contribution" do
    before(:each) do
    end
    it "should add amount to the items credit if not external" do
      item = Factory.build(:registry_item, :Quantity => 2, :Price => 50, :Contributed => 30)
      cont = Factory.build(:contribute, :Contribute => 10, :external => false)
      item.contributes << cont
      item.save
      item.Contributed.should == 40
    end

    it "should not add amount to the items credit if external" do
      item = Factory.build(:registry_item, :Quantity => 2, :Price => 50, :Contributed => 30)
      cont = Factory.build(:contribute, :Contribute => 10, :external => true)
      item.contributes << cont
      item.save
      item.Contributed.should == 30
    end

    it "should mark item as purchased if total contributions are equal to total value" do
      item = Factory.build(:registry_item_with_contributions, :Quantity => 2, :Price => 50, :Contributed => 50, :contributed => 50, :Shipment => 0, :Tax => 0)
      cont = Factory.build(:contribute, :Contribute => 50, :external => false)
      item.contributes << cont
      item.save
      item.Purchased_ID.should == RegistryItem::PURCHASED
    end

    it "should not mark item as purchased if total contributions are less then total value" do
      item = Factory.build(:registry_item_with_contributions, :Quantity => 2, :Price => 50, :Contributed => 50, :contributed => 50, :Shipment => 0, :Tax => 0)
      cont = Factory.build(:contribute, :Contribute => 40, :external => false)
      item.contributes << cont
      item.save
      item.Purchased_ID.should == RegistryItem::AVAILABLE
    end
  end

  describe "remove_contribution" do
    before(:each) do
    end
    it "should add amount to the items credit if not external" do
      item = Factory.build(:registry_item, :Quantity => 2, :Price => 50, :Contributed => 30)
      cont = Factory.build(:contribute, :Contribute => 10, :external => false)
      item.contributes << cont
      item.save
      item.Contributed.should == 40
      item.contributes.destroy(cont)
      item.save
      item.Contributed.should == 30
    end

    it "should not add amount to the items credit if external" do
      item = Factory.build(:registry_item, :Quantity => 2, :Price => 50, :Contributed => 30)
      cont = Factory.build(:contribute, :Contribute => 10, :external => true)
      item.contributes << cont
      item.save
      item.Contributed.should == 30
      item.contributes.destroy(cont)
      cont.destroy
      item.Contributed.should == 30
    end

    it "should mark item as purchased if total contributions is now less then total value" do
      item = Factory.build(:registry_item_with_contributions, :Quantity => 2, :Price => 50, :Contributed => 50, :contributed => 50, :Shipment => 0, :Tax => 0)
      cont = Factory.build(:contribute, :Contribute => 50, :external => false)
      item.contributes << cont
      item.save
      item.Purchased_ID.should == RegistryItem::PURCHASED
      cont.destroy
      item.save
      item.Purchased_ID.should == RegistryItem::AVAILABLE
    end

    it "should not mark item as available if total contributions are still less then total value" do
      item = Factory.build(:registry_item_with_contributions, :Quantity => 2, :Price => 50, :Contributed => 50, :contributed => 50, :Shipment => 0, :Tax => 0)
      cont = Factory.build(:contribute, :Contribute => 40, :external => false)
      item.contributes << cont
      item.save
      item.Purchased_ID.should == RegistryItem::AVAILABLE
      cont.destroy
      item.save
      item.Purchased_ID.should == RegistryItem::AVAILABLE
    end
  end

  describe "update_contribution" do
    before(:each) do
      @item = Factory.build(:registry_item_with_contributions, :Quantity => 2, :Price => 50, :contributed => 50, :Shipment => 0, :Tax => 0)
      @item.contributes[0].external = true
      @item.save
    end

    context "External Item" do
      before(:each) do
        @item.contributes[0].external = true
        @item.save
      end

      it "should mark item as purchased if total contributions are now equal to total value" do
        @cont = @item.contributes[0]
        @cont.Contribute = 100
        @cont.save
        @item.Purchased_ID.should == RegistryItem::PURCHASED
      end

      it "should not mark item as purchased if total contributions are less then total value" do
        @cont = @item.contributes[0]
        @cont.Contribute = 90
        @cont.save
        @item.Purchased_ID.should == RegistryItem::AVAILABLE
      end

      it "should mark item as no longer purchased if total contributions are now less then total value" do
        @cont = @item.contributes[0]
        @cont.Contribute = 100
        @cont.save
        @item.Purchased_ID.should == RegistryItem::PURCHASED
        @cont.Contribute = 50
        @cont.save
        @item.Purchased_ID.should == RegistryItem::AVAILABLE
      end

    end

    context "Not External Item" do
      before(:each) do
        @cont = Factory.build(:contribute, :Contribute => 10, :external => false)
        @item.contributes << @cont
        @item.save
      end

      it "should throw an exception if not external" do
        lambda {
          @cont.Contribute = 30
          @cont.save
        }.should raise_error
      end

      it "should not throw an exception if not external but contributed was not changed." do
        lambda {
          @cont.From = "Hello"
          @cont.save
        }.should_not raise_error
      end
    end
  end
end
