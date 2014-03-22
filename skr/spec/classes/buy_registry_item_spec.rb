require "spec_helper"

describe BuyRegistryItem do

  describe "Create From Registry Item" do

    describe "Generic Item" do
      before(:each) do
        @registry_item = Factory.build(:registry_item)
        @params = {:item => @registry_item, :from => "test", :note => "hello", :contribute => 10}
      end

      it "should set the gift givers info" do
        object = BuyRegistryItem.new(@params)
        object.product_name.should == @registry_item.product.Name
        object.description.should == @registry_item.product.Description
        object.color_id.should == @registry_item.Color_ID
      end

      it "should set the type" do
        @params[:type] = BuyRegistryItem::CONTRIBUTE
        object = BuyRegistryItem.new(@params)
        object.type.should == BuyRegistryItem::CONTRIBUTE

        @params[:type] = BuyRegistryItem::BUY_REGISTRANT_FROM_REGISTRY
        object = BuyRegistryItem.new(@params)
        object.type.should == BuyRegistryItem::BUY_REGISTRANT_FROM_REGISTRY

        @params[:type] = BuyRegistryItem::ORDER
        object = BuyRegistryItem.new(@params)
        object.type.should == BuyRegistryItem::ORDER
      end

    end

    it "Should set Price info from registry item (For situations where the user is ordering an item)" do
      @registry_item = Factory.build(:registry_item, :Price => 1000, :Quantity => 1, :Shipment => 10, :Tax => 10)
      @params = {:item => @registry_item, :type => BuyRegistryItem::ORDER}

      object = BuyRegistryItem.new(@params)

      object.price.should == 1000
      object.quantity.should == 1
      object.subtotal.should == 1000
      object.shipment_total.should == 10
      object.tax_total.should == 100
      object.total.should == 1110
    end

    describe "Generate an item for contribute " do
      it "should ask the registry item for min and max values for contribution and quantity" do
        @registry_item = Factory.build(:registry_item, :Price => 1000, :Quantity => 1, :Shipment => 10, :Tax => 10)
        @params = {:item => @registry_item, :type => BuyRegistryItem::CONTRIBUTE}

        @registry_item.should_receive(:min_contribution).and_return(1)
        @registry_item.should_receive(:max_contribution).at_least(1).times.and_return(100)
        @registry_item.should_receive(:min_quantity).and_return(2)
        @registry_item.should_receive(:max_quantity).and_return(20)

        object = BuyRegistryItem.new(@params)

        object.min_contribution = 1
        object.max_contribution = 100
        object.min_quantity = 2
        object.max_quantity = 20
      end

      describe "Contribute to an Item using Quantity" do
        before(:each) do
          @registry_item = Factory.build(:registry_item, :Price => 100, :Quantity => 10, :Shipment => 10, :Tax => 1)
          @params = {:item => @registry_item, :from => "test", :note => "hello", :type => BuyRegistryItem::CONTRIBUTE}

        end

        it "should buy entire item" do
          @params[:quantity] = 10

          object = BuyRegistryItem.new(@params)
          object.price.should == 100
          object.quantity.should == 10
          object.subtotal.should == 1000
          object.shipment_total.should == 100
          object.tax_total.should == 10
          object.total.should == 1110
        end

        it "should buy half of item by quantity" do
          @params[:quantity] = 5

          object = BuyRegistryItem.new(@params)
          object.price.should == 100
          object.quantity.should == 5
          object.subtotal.should == 500
          object.shipment_total.should == 50
          object.tax_total.should == 5
          object.total.should == 555
        end
      end

      describe "contribute to item eligible for dollar amount contributions " do
        before(:each) do
          @registry_item = Factory.build(:registry_item, :Price => 1000, :Quantity => 1, :Shipment => 10, :Tax => 10)
          @params = {:item => @registry_item, :from => "test", :note => "hello", :type => BuyRegistryItem::CONTRIBUTE}

        end

        it "should buy entire item" do
          @params[:contribute] = 1000

          object = BuyRegistryItem.new(@params)
          object.price.should == 1000
          object.quantity.should == 1
          object.subtotal.should == 1000
          object.shipment_total.should == 10
          object.tax_total.should == 100
          object.total.should == 1110
        end

        it "should buy half of item by quantity" do
          @params[:contribute] = 500

          object = BuyRegistryItem.new(@params)
          object.price.should == 1000
          object.quantity.should == 0.5
          object.subtotal.should == 500
          object.shipment_total.should == 5
          object.tax_total.should == 50
          object.total.should == 555
        end
      end
    end
  end
end


################################
  ### VALIDATIONS
  ################################
  #describe "Validations" do
  #  ###############################
  #  ## id Validations
  #  ###############################
  #  it "should not allow the buy_registry_item to be create without a id" do
  #    object = Factory.build(:buy_registry_item)
  #    object.id = nil
  #    object.valid?.should be_false
  #  end
  #
  #  it "should not allow the buy_registry_item to be create with a blank id" do
  #    object = Factory.build(:buy_registry_item)
  #    object.id = ""
  #    object.valid?.should be_false
  #  end
  #
  #  it "should allow the buy_registry_item to be created with min value id" do
  #    object = Factory.build(:buy_registry_item)
  #    object.id = 1
  #    object.valid?.should be_true
  #  end
  #
  #  it "should allow the buy_registry_item to be created with valid value id" do
  #    object = Factory.build(:buy_registry_item)
  #    object.id = 100
  #    object.valid?.should be_true
  #  end
  #
  #  it "should not allow the buy_registry_item to be created with not valid value id" do
  #    object = Factory.build(:buy_registry_item)
  #    object.id = 0
  #    object.valid?.should be_false
  #  end
  #
  #  ###############################
  #  ## type Validations
  #  ###############################
  #  it "should not allow the buy_registry_item to be create without a type" do
  #    object = Factory.build(:buy_registry_item)
  #    object.type = nil
  #    object.valid?.should be_false
  #  end
  #
  #  it "should not allow the buy_registry_item to be create with a blank type" do
  #    object = Factory.build(:buy_registry_item)
  #    object.type = ""
  #    object.valid?.should be_false
  #  end
  #
  #  it "should not allow the buy_registry_item to be created with not valid value type" do
  #    object = Factory.build(:buy_registry_item)
  #    object.type = -1
  #    object.valid?.should be_false
  #  end
  #
  #  ###############################
  #  ## quantity Validations
  #  ###############################
  #  it "should not allow the buy_registry_item to be create without a quantity" do
  #    object = Factory.build(:buy_registry_item)
  #    object.quantity = nil
  #    object.valid?.should be_false
  #  end
  #
  #  it "should not allow the buy_registry_item to be create with a blank quantity" do
  #    object = Factory.build(:buy_registry_item)
  #    object.quantity = ""
  #    object.valid?.should be_false
  #  end
  #
  #  it "should allow the buy_registry_item to be created with min value quantity" do
  #    object = Factory.build(:buy_registry_item)
  #    object.quantity = 1
  #    object.valid?.should be_true
  #  end
  #
  #  it "should allow the buy_registry_item to be created with valid value quantity" do
  #    object = Factory.build(:buy_registry_item)
  #    object.quantity = 100
  #    object.valid?.should be_true
  #  end
  #
  #  it "should not allow the buy_registry_item to be created with not valid value quantity" do
  #    object = Factory.build(:buy_registry_item)
  #    object.quantity = 0
  #    object.valid?.should be_false
  #  end
  #
  #  ###############################
  #  ## product_name Validations
  #  ###############################
  #  it "should not allow the buy_registry_item to be create without a product_name" do
  #    object = Factory.build(:buy_registry_item)
  #    object.product_name = nil
  #    object.valid?.should be_false
  #  end
  #
  #  it "should not allow the buy_registry_item to be create with a blank product_name" do
  #    object = Factory.build(:buy_registry_item)
  #    object.product_name = ""
  #    object.valid?.should be_false
  #  end
  #
  #  it "should allow the buy_registry_item to be created with value product_name" do
  #    object = Factory.build(:buy_registry_item)
  #    object.product_name = "Product"
  #    object.valid?.should be_true
  #  end
  #
  #  ###############################
  #  ## price Validations
  #  ###############################
  #  it "should not allow the buy_registry_item to be create without a price" do
  #    object = Factory.build(:buy_registry_item)
  #    object.price = nil
  #    object.valid?.should be_false
  #  end
  #
  #  it "should not allow the buy_registry_item to be create with a blank price" do
  #    object = Factory.build(:buy_registry_item)
  #    object.price = ""
  #    object.valid?.should be_false
  #  end
  #
  #  it "should allow the buy_registry_item to be created with min value price" do
  #    object = Factory.build(:buy_registry_item)
  #    object.price = 0
  #    object.valid?.should be_true
  #  end
  #
  #  it "should allow the buy_registry_item to be created with valid value price" do
  #    object = Factory.build(:buy_registry_item)
  #    object.price = 100
  #    object.valid?.should be_true
  #  end
  #
  #  it "should not allow the buy_registry_item to be created with not valid value price" do
  #    object = Factory.build(:buy_registry_item)
  #    object.price = -1
  #    object.valid?.should be_false
  #  end
  #
  #  ###############################
  #  ## subtotal Validations
  #  ###############################
  #  it "should not allow the buy_registry_item to be create without a subtotal" do
  #    object = Factory.build(:buy_registry_item)
  #    object.subtotal = nil
  #    object.valid?.should be_false
  #  end
  #
  #  it "should not allow the buy_registry_item to be create with a blank subtotal" do
  #    object = Factory.build(:buy_registry_item)
  #    object.subtotal = ""
  #    object.valid?.should be_false
  #  end
  #
  #  it "should allow the buy_registry_item to be created with min value subtotal" do
  #    object = Factory.build(:buy_registry_item)
  #    object.subtotal = 0
  #    object.type = BuyRegistryItem::ORDER
  #    object.valid?.should be_true
  #  end
  #
  #  it "should allow the buy_registry_item to be created with valid value subtotal" do
  #    object = Factory.build(:buy_registry_item)
  #    object.subtotal = 100
  #    object.type = BuyRegistryItem::ORDER
  #    object.valid?.should be_true
  #  end
  #
  #  it "should not allow the buy_registry_item to be created with not valid value subtotal" do
  #    object = Factory.build(:buy_registry_item)
  #    object.subtotal = -1
  #    object.type = BuyRegistryItem::ORDER
  #    object.valid?.should be_true
  #  end
  #
  #  it "should allow the buy_registry_item to be created with min value subtotal if type for contribute cases" do
  #    object = Factory.build(:buy_registry_item)
  #    object.subtotal = 0
  #    object.type = BuyRegistryItem::CONTRIBUTE
  #    object.min_contribution = 0
  #    object.max_contribution = 100
  #    object.valid?.should be_true
  #  end
  #
  #  it "should not allow the buy_registry_item to be created with min value subtotal if type for contribute cases" do
  #    object = Factory.build(:buy_registry_item)
  #    object.subtotal = 0
  #    object.type = BuyRegistryItem::CONTRIBUTE
  #    object.min_contribution = 10
  #    object.max_contribution = 100
  #    object.valid?.should be_false
  #  end
  #
  #  it "should not allow the buy_registry_item to be created with min value subtotal if type for contribute cases" do
  #    object = Factory.build(:buy_registry_item)
  #    object.subtotal = 110
  #    object.type = BuyRegistryItem::CONTRIBUTE
  #    object.min_contribution = 10
  #    object.max_contribution = 100
  #    object.valid?.should be_false
  #  end
  #
  #  ################################
  #  ### amount_contributed Validations
  #  ################################
  #  #it "should allow the buy_registry_item to be create without a amount_contributed if type for not buy to someone cases" do
  #  #  object = Factory.build(:buy_registry_item)
  #  #  object.amount_contributed = nil
  #  #  object.type = BuyRegistryItem::ORDER
  #  #  object.valid?.should be_true
  #  #end
  #  #
  #  #it "should not allow the buy_registry_item to be create with a blank amount_contributed if type for not buy to someone cases" do
  #  #  object = Factory.build(:buy_registry_item)
  #  #  object.amount_contributed = ""
  #  #  object.type = BuyRegistryItem::ORDER
  #  #  object.valid?.should be_true
  #  #end
  #  #
  #  #it "should not allow the buy_registry_item to be create without a amount_contributed if type for not buy to someone cases" do
  #  #  object = Factory.build(:buy_registry_item)
  #  #  object.amount_contributed = nil
  #  #  object.type = BuyRegistryItem::BUY_GIVER_2_REGISTRANT
  #  #  object.valid?.should be_false
  #  #end
  #  #
  #  #it "should allow the buy_registry_item to be create with a blank amount_contributed if type for not buy to someone cases" do
  #  #  object = Factory.build(:buy_registry_item)
  #  #  object.amount_contributed = ""
  #  #  object.type = BuyRegistryItem::BUY_GIVER_2_REGISTRANT
  #  #  object.valid?.should be_false
  #  #end
  #  #
  #  #it "should allow the buy_registry_item to be created with min value amount_contributed" do
  #  #  object = Factory.build(:buy_registry_item)
  #  #  object.amount_contributed = 0
  #  #  object.type = BuyRegistryItem::BUY_GIVER_2_REGISTRANT
  #  #  object.valid?.should be_true
  #  #end
  #  #
  #  #it "should allow the buy_registry_item to be created with valid value amount_contributed" do
  #  #  object = Factory.build(:buy_registry_item)
  #  #  object.amount_contributed = 100
  #  #  object.type = BuyRegistryItem::BUY_GIVER_2_REGISTRANT
  #  #  object.valid?.should be_true
  #  #end
  #  #
  #  #it "should not allow the buy_registry_item to be created with not valid value amount_contributed" do
  #  #  object = Factory.build(:buy_registry_item)
  #  #  object.amount_contributed = -1
  #  #  object.type = BuyRegistryItem::BUY_GIVER_2_REGISTRANT
  #  #  object.valid?.should be_false
  #  #end
  #
  #  ###############################
  #  ## color_id Validations
  #  ###############################
  #  it "should allow the buy_registry_item to be create without a color_id" do
  #    object = Factory.build(:buy_registry_item)
  #    object.color_id = nil
  #    object.valid?.should be_true
  #  end
  #
  #  it "should not allow the buy_registry_item to be create with a blank color_id" do
  #    object = Factory.build(:buy_registry_item)
  #    object.color_id = ""
  #    object.valid?.should be_false
  #  end
  #
  #  it "should allow the buy_registry_item to be created with min value color_id" do
  #    object = Factory.build(:buy_registry_item)
  #    object.color_id = 1
  #    object.valid?.should be_true
  #  end
  #
  #  it "should allow the buy_registry_item to be created with valid value color_id" do
  #    object = Factory.build(:buy_registry_item)
  #    object.color_id = 100
  #    object.valid?.should be_true
  #  end
  #
  #  it "should not allow the buy_registry_item to be created with not valid value color_id" do
  #    object = Factory.build(:buy_registry_item)
  #    object.color_id = 0
  #    object.valid?.should be_false
  #  end
  #
  #  ###############################
  #  ## from Validations
  #  ###############################
  #  it "should allow the buy_registry_item to be created without a from if type not from contribute cases" do
  #    object = Factory.build(:buy_registry_item)
  #    object.from = nil
  #    object.type = BuyRegistryItem::ORDER
  #    object.valid?.should be_true
  #  end
  #
  #  it "should allow the buy_registry_item to be create with a blank from if type not from contribute cases" do
  #    object = Factory.build(:buy_registry_item)
  #    object.from = ""
  #    object.type = BuyRegistryItem::ORDER
  #    object.valid?.should be_true
  #  end
  #
  #  it "should not allow the buy_registry_item to be create without a from" do
  #    object = Factory.build(:buy_registry_item)
  #    object.from = nil
  #    object.type = BuyRegistryItem::CONTRIBUTE
  #    object.valid?.should be_false
  #  end
  #
  #  it "should not allow the buy_registry_item to be create with a blank from" do
  #    object = Factory.build(:buy_registry_item)
  #    object.from = ""
  #    object.type = BuyRegistryItem::CONTRIBUTE
  #    object.valid?.should be_false
  #  end
  #
  #  it "should allow the buy_registry_item to be created with max length from" do
  #    object = Factory.build(:buy_registry_item)
  #    object.from = ("a" * 49)
  #    object.type = BuyRegistryItem::CONTRIBUTE
  #    object.valid?.should be_true
  #  end
  #
  #  it "should not allow the buy_registry_item to be created with max length +1 from" do
  #    object = Factory.build(:buy_registry_item)
  #    object.from = ("a" * 51)
  #    object.type = BuyRegistryItem::CONTRIBUTE
  #    object.valid?.should be_false
  #  end
  #
  #  ###############################
  #  ## notes Validations
  #  ###############################
  #  it "should allow the buy_registry_item to be create without a notes " do
  #    object = Factory.build(:buy_registry_item)
  #    object.notes = nil
  #    object.valid?.should be_true
  #  end
  #
  #  it "should allow the buy_registry_item to be create with a blank notes " do
  #    object = Factory.build(:buy_registry_item)
  #    object.notes = ""
  #    object.valid?.should be_true
  #  end
  #
  #  it "should allow the buy_registry_item to be created with max length notes" do
  #    object = Factory.build(:buy_registry_item)
  #    object.notes = ("a" * 300)
  #    object.valid?.should be_true
  #  end
  #
  #  it "should not allow the buy_registry_item to be created with max length +1 notes" do
  #    object = Factory.build(:buy_registry_item)
  #    object.notes = ("a" * 301)
  #    object.valid?.should be_false
  #  end
  #
  #  ###############################
  #  ## total Validations
  #  ###############################
  #  it "should not allow the buy_registry_item to be create without a total" do
  #    object = Factory.build(:buy_registry_item)
  #    object.total = nil
  #    object.valid?.should be_false
  #  end
  #
  #  it "should not allow the buy_registry_item to be create with a blank total" do
  #    object = Factory.build(:buy_registry_item)
  #    object.total = ""
  #    object.valid?.should be_false
  #  end
  #
  #  it "should allow the buy_registry_item to be created with min value total" do
  #    object = Factory.build(:buy_registry_item)
  #    object.total = 0
  #    object.valid?.should be_true
  #  end
  #
  #  it "should allow the buy_registry_item to be created with valid value total" do
  #    object = Factory.build(:buy_registry_item)
  #    object.total = 100
  #    object.valid?.should be_true
  #  end
  #
  #  it "should not allow the buy_registry_item to be created with not valid value total" do
  #    object = Factory.build(:buy_registry_item)
  #    object.total = -1
  #    object.valid?.should be_false
  #  end
  #
  #  ###############################
  #  ## tax Validations
  #  ###############################
  #  it "should not allow the buy_registry_item to be create without a tax" do
  #    object = Factory.build(:buy_registry_item)
  #    object.tax = nil
  #    object.valid?.should be_false
  #  end
  #
  #  it "should not allow the buy_registry_item to be create with a blank tax" do
  #    object = Factory.build(:buy_registry_item)
  #    object.tax = ""
  #    object.valid?.should be_false
  #  end
  #
  #  it "should allow the buy_registry_item to be created with min value tax" do
  #    object = Factory.build(:buy_registry_item)
  #    object.tax = 0
  #    object.valid?.should be_true
  #  end
  #
  #  it "should allow the buy_registry_item to be created with valid value tax" do
  #    object = Factory.build(:buy_registry_item)
  #    object.tax = 100
  #    object.valid?.should be_true
  #  end
  #
  #  it "should not allow the buy_registry_item to be created with not valid value tax" do
  #    object = Factory.build(:buy_registry_item)
  #    object.tax = -1
  #    object.valid?.should be_false
  #  end
  #
  #  ###############################
  #  ## shipment Validations
  #  ###############################
  #  it "should not allow the buy_registry_item to be create without a shipment" do
  #    object = Factory.build(:buy_registry_item)
  #    object.shipment = nil
  #    object.valid?.should be_false
  #  end
  #
  #  it "should not allow the buy_registry_item to be create with a blank shipment" do
  #    object = Factory.build(:buy_registry_item)
  #    object.shipment = ""
  #    object.valid?.should be_false
  #  end
  #
  #  it "should allow the buy_registry_item to be created with min value shipment" do
  #    object = Factory.build(:buy_registry_item)
  #    object.shipment = 0
  #    object.valid?.should be_true
  #  end
  #
  #  it "should allow the buy_registry_item to be created with valid value shipment" do
  #    object = Factory.build(:buy_registry_item)
  #    object.shipment = 50
  #    object.valid?.should be_true
  #  end
  #
  #  it "should not allow the buy_registry_item to be created with not valid value shipment" do
  #    object = Factory.build(:buy_registry_item)
  #    object.shipment = -1
  #    object.valid?.should be_false
  #  end
  #end


#    it "should valid values for subtotal method for buy to someone" do
#      object = Factory.build(:buy_registry_item)
#      object.price = 100
#      object.tax = 100
#      object.shipment = 100
#      object.quantity = 2
#      object.total = 400
#      object.type = BuyRegistryItem::BUY_GIVER_2_REGISTRANT
#      object.subtotal = 300
#      object.amount_contributed = 10
#      object.subtotal.should == 190.0
#
#      object.total = 300.3425
#      object.subtotal.should == 90.35
#    end
#
#    it "should valid values for subtotal method for buy to himself" do
#      object = Factory.build(:buy_registry_item)
#      object.price = 100
#      object.tax = 100
#      object.shipment = 100
#      object.quantity = 2
#      object.total = 400
#      object.type = BuyRegistryItem::ORDER
#      object.subtotal = 300
#      object.amount_contributed = 10
#      object.subtotal.should == 200.0
#
#      object.price = 100.234
#      object.subtotal.should == 200.47
#    end
#
#    ###############################
#    ## tax
#    ###############################
#    it "should valid values for tax method for non contribute cases" do
#      object = Factory.build(:buy_registry_item)
#      object.tax = 100
#      object.type = BuyRegistryItem::ORDER
#      object.quantity = 2
#      object.tax.should == 200.0
#
#      object.tax = 1000.0
#      object.quantity = 2
#      object.tax.should == 2000.0
#
#      object.tax = 10.53
#      object.quantity = 2
#      object.tax.should == 21.06
#
#      object.tax = 10.5333
#      object.quantity = 2
#      object.tax.should == 21.07
#    end
#
#    it "should valid values for tax method for contribute cases" do
#      object = Factory.build(:buy_registry_item)
#      object.tax = 100
#      object.type = BuyRegistryItem::CONTRIBUTE
#      object.quantity = 2
#      object.tax.should == 100.0
#
#      object.tax = 1000.0
#      object.quantity = 2
#      object.tax.should == 1000.0
#
#      object.tax = 10.53
#      object.quantity = 2
#      object.tax.should == 10.53
#
#      object.tax = 10.5333
#      object.quantity = 2
#      object.tax.should == 10.54
#    end
#
#    ###############################
#    ## shipment
#    ###############################
#    it "should valid values for shipment method for non contribute cases" do
#      object = Factory.build(:buy_registry_item)
#      object.shipment = 100
#      object.type = BuyRegistryItem::ORDER
#      object.quantity = 2
#      object.shipment.should == 200.0
#
#      object.shipment = 1000.0
#      object.quantity = 2
#      object.shipment.should == 2000.0
#
#      object.shipment = 10.53
#      object.quantity = 2
#      object.shipment.should == 21.06
#
#      object.shipment = 10.5333
#      object.quantity = 2
#      object.shipment.should == 21.07
#    end
#
#    it "should valid values for shipment method for contribute cases" do
#      object = Factory.build(:buy_registry_item)
#      object.shipment = 100
#      object.type = BuyRegistryItem::CONTRIBUTE
#      object.quantity = 2
#      object.shipment.should == 100.0
#
#      object.shipment = 1000.0
#      object.quantity = 2
#      object.shipment.should == 1000.0
#
#      object.shipment = 10.53
#      object.quantity = 2
#      object.shipment.should == 10.53
#
#      object.shipment = 10.5333
#      object.quantity = 2
#      object.shipment.should == 10.54
#    end
#
#    ###############################
#    ## total
#    ###############################
#    it "should valid values for total method" do
#      object = Factory.build(:buy_registry_item)
#      object.price = 100
#      object.tax = 100
#      object.shipment = 100
#      object.quantity = 2
#      object.total.should == 600.0
#
#      object.price = 1000.0
#      object.tax = 1000.0
#      object.shipment = 1000.0
#      object.quantity = 2
#      object.total.should == 6000.0
#
#      object.price = 10.5333
#      object.tax = 10.5333
#      object.shipment = 10.5333
#      object.quantity = 2
#      object.total.should == 63.21
#    end
#  end
#end