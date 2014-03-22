require "spec_helper"

describe RegistryItem do

  describe "scope editable" do
    before(:each) do
      @registrant = Factory(:registrant)
      @product1 = Factory(:product)
    end

    it "should include items that are available and have not been contributed to" do
      Factory(:registry_item, :registrant => @registrant, :product => @product1, :Purchased_ID => RegistryItem::AVAILABLE)
      @registrant.registry_items.editable.length.should == 1
    end

    it "should not include items that are not available" do
      Factory(:registry_item, :registrant => @registrant, :product => @product1, :Purchased_ID => RegistryItem::PURCHASED)
      Factory(:registry_item, :registrant => @registrant, :product => @product1, :Purchased_ID => RegistryItem::ORDERED)
      @registrant.registry_items.editable.length.should == 0
    end

    it "should note include items that have been contributed to" do
      Factory(:registry_item_with_contributions, :registrant => @registrant, :product => @product1, :Purchased_ID => RegistryItem::AVAILABLE)
      @registrant.registry_items.editable.length.should == 0
    end
  end

  describe "scope catalog" do
    before(:each) do
      @registrant = Factory(:registrant)
    end

    it "should include catalog items" do
      Factory(:registry_item, :registrant => @registrant)
      @registrant.registry_items.catalog.length.should == 1
    end
    it "should include unique items" do
      Factory(:registry_item_unique, :registrant => @registrant)
      @registrant.registry_items.catalog.length.should == 1
    end
    it "should not include cash items" do
      Factory(:registry_item_cash, :registrant => @registrant)
      @registrant.registry_items.catalog.length.should == 0
    end
    it "should not include external items" do
      Factory(:registry_item_external, :registrant => @registrant)
      @registrant.registry_items.catalog.length.should == 0
    end
  end

  describe "scope not catalog" do
    before(:each) do
      @registrant = Factory(:registrant)
    end

    it "should not include catalog items" do
      Factory(:registry_item, :registrant => @registrant)
      @registrant.registry_items.not_catalog.length.should == 0
    end
    it "should not include unique items" do
      Factory(:registry_item_unique, :registrant => @registrant)
      @registrant.registry_items.not_catalog.length.should == 0
    end
    it "should include cash items" do
      Factory(:registry_item_cash, :registrant => @registrant)
      @registrant.registry_items.not_catalog.length.should == 1
    end
    it "should include external items" do
      Factory(:registry_item_external, :registrant => @registrant)
      @registrant.registry_items.not_catalog.length.should == 1
    end
  end

  describe "delete_from_registry" do
    before(:each) do
      @registrant = Factory(:registrant)
      @product1 = Factory(:product)
      @r2p1 = Factory(:registry_item, :registrant => @registrant, :product => @product1, :Purchased_ID => RegistryItem::AVAILABLE)
    end

    it "should delete the item " do
      r2p = Factory(:registry_item, :Contributed => 0, :registrant => @registrant, :product => @product1, :Purchased_ID => RegistryItem::AVAILABLE)
      r2p.delete_from_registry
      r2p.IsDeleted.should be_true
    end

    it "should make a unique item available again" do
      unique_product = Factory(:product, :IsKind => true, :IsKindView => false)
      r2p = Factory(:registry_item, :Contributed => 0, :registrant => @registrant, :product => unique_product, :Purchased_ID => RegistryItem::AVAILABLE)
      r2p.delete_from_registry
      Product.find(unique_product.id).IsKindView.should be_true
    end
  end

  describe "reject_product_updates" do
    before(:each) do
      @registrant = Factory(:registrant)
    end

    context "Item is a catalog item" do
      before(:each) do
        @product = Factory(:product)
        @r2p = Factory(:registry_item, :registrant => @registrant, :product => @product, :Purchased_ID => RegistryItem::AVAILABLE)
      end

      it "should return true no matter what the parameters are" do
        @r2p.reject_product_updates({"id" => @product.id}).should be_true
      end

      it "should return true no matter what the parameters are" do
        @r2p.reject_product_updates({"id" => @product.id, "Name" => "name", "Description" => "desc"}).should be_true
      end

    end

    context "Item is a registrant item" do
      before(:each) do
        @product = Factory(:cash_product, :Registrant_ID => @registrant.id)
        @r2p = Factory(:registry_item, :registrant => @registrant, :product => @product, :Purchased_ID => RegistryItem::AVAILABLE)
      end

      it "should not reject if no other params specified" do
        @r2p.reject_product_updates({"id" => @product.id}).should be_false
      end

      it "should not reject if name, desc, price specified" do
        @r2p.reject_product_updates({"id" => @product.id, "Name" => "name", "Description" => "desc", "MasterPrice" => 12}).should be_false
      end

      it "should not reject if external, source_name, source_url  specified" do
        @r2p.reject_product_updates({"id" => @product.id, "external" => true, "source_name" => "www.macys.com", "source_url" => "www.macys.com/item"}).should be_false
      end

      it "should reject if name, desc, price plus something else is specified" do
        @r2p.reject_product_updates({"id" => @product.id, "Name" => "name", "Description" => "desc", "MasterPrice" => 12, 'SalesPrice' => 12 }).should be_true
      end

      it "should reject if item is not a cash product" do
        @product2 = Factory(:product)
        @r2p.product = @product2
        @r2p.reject_product_updates({"id" => @product2.id}).should be_true
      end

    end

  end

  describe "calculate Amount" do
    before(:each) do
      @r2p = Factory.build(:registry_item, :Price => 5, :Quantity => 10, :Tax => 20, :Shipment => 2)
    end

    it "should calculate subtotal" do
      @r2p.subtotal.should == 50
    end
    it "should calculate shipping" do
      @r2p.shipment_total.should == 20
    end
    it "should calculate tax" do
      @r2p.tax_total.should == 10
    end
    it "should calculate total" do
      @r2p.total.should == 80
    end
  end

  describe "calculate Deficiency" do
    context "Half Given" do
      before(:each) do
        @r2p = Factory.build(:registry_item_with_contributions, :Price => 5, :Quantity => 10, :Tax => 20, :Shipment => 2, :contributed => 40)
      end

      it "should calculate deficient percentage" do
        @r2p.percent.should == 0.5
      end
      it "should calculate deficient quantity" do
        @r2p.deficient_quantity.should == 5
      end
      it "should calculate deficient subtotal" do
        @r2p.deficient_subtotal.should == 25
      end
      it "should calculate deficient shipping" do
        @r2p.deficient_shipment.should == 10
      end
      it "should calculate deficient tax" do
        @r2p.deficient_tax.should == 5
      end
      it "should calculate total" do
        @r2p.deficient_total.should == 40
      end
    end

    context "Nothing Given" do
      before(:each) do
        @r2p = Factory.build(:registry_item, :Price => 5, :Quantity => 10, :Tax => 20, :Shipment => 2)
      end

      it "should calculate deficient percentage" do
        @r2p.percent.should == 1
      end
      it "should calculate deficient quantity" do
        @r2p.deficient_quantity.should == 10
      end
      it "should calculate deficient subtotal" do
        @r2p.deficient_subtotal.should == 50
      end
      it "should calculate deficient shipping" do
        @r2p.deficient_shipment.should == 20
      end
      it "should calculate deficient tax" do
        @r2p.deficient_tax.should == 10
      end
      it "should calculate total" do
        @r2p.deficient_total.should == 80
      end
    end
    context "Odd Amount Given" do
      before(:each) do
        @r2p = Factory.build(:registry_item_with_contributions, :Price => 5, :Quantity => 10, :Tax => 20, :Shipment => 2, :contributed => 42)
      end

      it "should calculate deficient percentage" do
        @r2p.percent.should == 0.475
      end
      it "should calculate deficient quantity" do
        @r2p.deficient_quantity.should == 4.75
      end
      it "should calculate deficient subtotal" do
        @r2p.deficient_subtotal.should == 23.75
      end
      it "should calculate deficient shipping" do
        @r2p.deficient_shipment.should == 9.5
      end
      it "should calculate deficient tax" do
        @r2p.deficient_tax.should == 4.75
      end
      it "should calculate total" do
        @r2p.deficient_total.should == 38
      end
    end
  end


  describe "allow contribute" do
    it "should allow contribute if quantity is 1 and price is $200 or more" do
      item = Factory.build(:registry_item, :Quantity => 1, :Price => 200)
      item.allow_contribute?.should be_true
    end
    it "should not allow contribute if quantity is more then 1" do
      item = Factory.build(:registry_item, :Quantity => 2, :Price => 10)
      item.allow_contribute?.should be_false
    end
    it "should not allow contribute if price is less then $100" do
      item = Factory.build(:registry_item, :Quantity => 1, :Price => 50)
      item.allow_contribute?.should be_false
    end
  end

  describe "duplicate item" do
    before(:each) do
      @registrant = Factory(:registrant)
    end

    it "should create a new registry item with the same params" do
      orig_item = Factory.build(:registry_item)
      new_item = orig_item.duplicate(@registrant)
      new_item.should_not == orig_item
      new_item.Quantity.should == orig_item.Quantity
      new_item.Price.should == orig_item.Price
    end

    it "should set a blank created at and update at date" do
      orig_item = Factory.create(:registry_item)
      new_item = orig_item.duplicate(@registrant)
      new_item.created_at.should be_nil
      new_item.updated_at.should be_nil
    end

    it "new item should belong to the supplied registrant." do
      orig_item = Factory.create(:registry_item)
      new_item = orig_item.duplicate(@registrant)
      new_item.registrant.should == @registrant
    end

    it "should create a link back to the original item." do
      orig_item = Factory.create(:registry_item)
      new_item = orig_item.duplicate(@registrant)
      new_item.copied_from.should == orig_item
    end

    it "should use the existing product if the product is in the catalog" do
      orig_item = Factory.build(:registry_item)
      new_item = orig_item.duplicate(@registrant)
      new_item.product.should == orig_item.product
    end

    context "item is not from the catalog" do
      it "should create a new product if the product is not in the catalog" do
        orig_item = Factory.create(:registry_item_added_myself)
        new_item = orig_item.duplicate(@registrant)
        new_item.product.should_not == orig_item.product
      end

      it "should set updated at and created at to nil" do
        orig_item = Factory.create(:registry_item_added_myself)
        new_item = orig_item.duplicate(@registrant)
        new_item.product.created_at.should be_nil
        new_item.product.updated_at.should be_nil
      end

      it "should set the product to belong to the supplied registrant" do
        orig_item = Factory.create(:registry_item_added_myself)
        new_item = orig_item.duplicate(@registrant)
        new_item.product.creator.should == @registrant
      end

      it "should copy the product image." do
        orig_item = Factory.create(:registry_item_added_myself)
        new_item = orig_item.duplicate(@registrant)

        new_item.product.main_product_image.should_not be_nil
        new_item.product.main_product_thumb.should_not be_nil
      end
    end
  end

  describe "get feed items" do
    before(:each) do
      @reg = Factory(:registrant)
      @reg2 = Factory(:registrant)
      @reg3 = Factory(:registrant)

      @reg.followed_registrants = [@reg2]
      @reg.save

      @reg_item1 = Factory(:registry_item, :registrant => @reg)
      @reg_item2 = Factory(:registry_item, :registrant => @reg2)
      @reg_item3 = Factory(:registry_item, :registrant => @reg3)

    end

    it "should show all when a filter is not set" do
      RegistryItem.get_feed_items().should =~ [@reg_item1, @reg_item2, @reg_item3]
    end

    it "should show friend activity when filtered to friend" do
      RegistryItem.get_feed_items("friends", @reg).should =~ [@reg_item2]
    end

    it "should show my activity when filter is set to me" do
      RegistryItem.get_feed_items("me", @reg).should =~ [@reg_item1]
    end

    context "With site filter" do
      before(:each) do
        @ex_reg_item1 = Factory(:registry_item_external, :registrant => @reg, :source_name => "macys.com")
        @ex_reg_item2 = Factory(:registry_item_external, :registrant => @reg2, :source_name => "macys.com")
        @ex_reg_item3 = Factory(:registry_item_external, :registrant => @reg, :source_name => "foo.com")
        @ex_reg_item4 = Factory(:registry_item_external, :registrant => @reg3, :source_name => "foo.com")
      end

      it "should return nothing when there are no matches" do
        RegistryItem.get_feed_items(nil, @reg,"nothing").should =~ []
      end

      it "should return results when there are matches" do
        RegistryItem.get_feed_items(nil, @reg, "macys.com").should =~ [@ex_reg_item1, @ex_reg_item2]
      end

      it "should include filter by me" do
        RegistryItem.get_feed_items("me", @reg, "macys.com").should =~ [@ex_reg_item1]
      end

      it "should include filter by friends" do
        RegistryItem.get_feed_items("friends", @reg, "macys.com").should =~ [@ex_reg_item2]
      end

    end

  end

end
