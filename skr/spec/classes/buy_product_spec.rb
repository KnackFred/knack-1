require "spec_helper"

describe BuyProduct do

  ###############################
  describe "new - from product" do
    describe "assign properties" do
      before(:each) do
        @product = Factory.build(:product)
        @params = {:product => @product, :quantity => 1}
      end

      it "should set the product info" do
        object = BuyProduct.new(@params)
        object.product_name.should == @product.Name
        object.description.should == @product.Description
        object.category_id.should == @product.get_category.id
        object.category_name.should == @product.get_category.name
      end

      it "should set color if it's specified" do
        @params[:color_id] = 5
        Color.should_receive(:find_by_id).with(5).and_return("green")

        object = BuyProduct.new(@params)

        object.color_id.should == 5
        object.color_name.should == "green"
      end

      it "should set params if they are specified" do
        @params[:params] = "[{\"key\":\"66\",\"value\":\"1252\"},{\"key\":\"67\",\"value\":\"1256\"}]"
        BuyProduct.should_receive(:parse_params).with([{'key' => '66', 'value' => '1252'}, {'key' => '67', 'value' => '1256'}]).and_return(['foo','bar','bat'])
        object = BuyProduct.new(@params)

        object.list_params.should == ['foo','bar','bat']
      end

    end

    ###############################
    ## is_kind
    ###############################
    it "should set is_kind (false)" do
      product = Factory.create(:product, :IsKind => false)
      object = BuyProduct.new({:product => product, :quantity => 1})
      object.is_kind.should be_false
    end

    it "should set is_kind (true)" do
      product = Factory.create(:product, :IsKind => true)
      object = BuyProduct.new({:product => product, :quantity => 1})
      object.is_kind.should be_true
    end

    describe "calculate prices correctly" do
      describe "with shipping" do
        before(:each) do
          @product = Factory.build(:product_free_shipping, :SalesPrice => 10)
          @product.should_receive(:Shipment).and_return(1)
          @params = {:product => @product}
        end

        it "should include products shipping cost times quantity of 5" do
          @params[:quantity] = 1

          object = BuyProduct.new(@params)

          object.price.should == 10
          object.quantity.should == 1
          object.subtotal.should == 10
          object.shipment_total.should == 1
          object.tax_total.should == 0
          object.total.should == 11
        end

        it "should include products shipping cost times quantity of 5" do
          @params[:quantity] = 5

          object = BuyProduct.new(@params)

          object.price.should == 10
          object.quantity.should == 5
          object.subtotal.should == 50
          object.shipment_total.should == 5
          object.tax_total.should == 0
          object.total.should == 55
        end
      end

      describe "with tax" do
        before(:each) do
          @product = Factory.build(:product_free_shipping, :SalesPrice => 10)
          @params = {:product => @product, :state_id => 2}
        end

        it "should include products tax rate for the state times quantity of 1" do

          @params[:quantity] = 1
          @product.should_receive(:tax).with(2).and_return(1.0)

          object = BuyProduct.new(@params)

          object.price.should == 10
          object.quantity.should == 1
          object.subtotal.should == 10
          object.shipment_total.should == 0
          object.tax_total.should == 0.1
          object.total.should == 10.1
        end

        it "should include products tax rate for the state times quantity of 5" do
          @params[:quantity] = 5
          @product.should_receive(:tax).with(2).and_return(1.0)

          object = BuyProduct.new(@params)

          object.price.should == 10
          object.quantity.should == 5
          object.subtotal.should == 50
          object.shipment_total.should == 0
          object.tax_total.should == 0.5
          object.total.should == 50.5
        end
      end
    end
  end
  describe "Methods" do

    ###############################
    ## parse_params
    ###############################
    describe "Parse Params" do
      before(:each) do
        partner = Factory.create(:partner)
        @param1 = Factory.create(:product_param, :partner => partner, :Name => "Size")
        @param2 = Factory.create(:product_param, :partner => partner, :Name => "Length")
        @param3 = Factory.create(:product_param, :partner => partner, :Name => "Weigh")
        @value1 = Factory.create(:value_param, :product_param => @param1, :Value => 100)
        @value2 = Factory.create(:value_param, :product_param => @param2, :Value => 200)
        @value3 = Factory.create(:value_param, :product_param => @param3, :Value => 300)
      end

      it "should valid values for parse_params method if not array" do
        params = {"key" => @param1.id, "value" => @value1.id}
        BuyProduct.parse_params(params).length.should == 0
      end

      it "should valid values for parse_params method if not valid format" do
        params = [{"keys" => @param1.id, "value" => @value1.id}, @value2.id, {"key" => @param3.id, "value" => @value3.id}]
        BuyProduct.parse_params(params).length.should == 1
      end

      it "should valid values for parse_params method" do
        params = [{"key" => @param1.id, "value" => @value1.id}, {"key" => @param2.id, "value" => @value2.id}, {"key" => @param3.id, "value" => @value3.id}]
        BuyProduct.parse_params(params).length.should == 3
      end

      it "should valid values for parse_params method if param not found" do
        params = [{"key" => 999, "value" => @value1.id}, {"key" => @param2.id, "value" => @value2.id}, {"key" => @param3.id, "value" => @value3.id}]
        BuyProduct.parse_params(params).length.should == 2
      end

      it "should valid values for parse_params method if value not found" do
        params = [{"key" => @param1.id, "value" => 999}, {"key" => @param2.id, "value" => @value2.id}, {"key" => @param3.id, "value" => @value3.id}]
        BuyProduct.parse_params(params).length.should == 2
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
  #  it "should not allow the buy_product to be create without a id" do
  #    object = Factory.build(:buy_product)
  #    object.id = nil
  #    object.valid?.should be_false
  #  end
  #
  #  it "should not allow the buy_product to be create with a blank id" do
  #    object = Factory.build(:buy_product)
  #    object.id = ""
  #    object.valid?.should be_false
  #  end
  #
  #  it "should allow the buy_product to be created with min value id" do
  #    object = Factory.build(:buy_product)
  #    object.id = 1
  #    object.valid?.should be_true
  #  end
  #
  #  it "should allow the buy_product to be created with valid value id" do
  #    object = Factory.build(:buy_product)
  #    object.id = 100
  #    object.valid?.should be_true
  #  end
  #
  #  it "should not allow the buy_product to be created with not valid value id" do
  #    object = Factory.build(:buy_product)
  #    object.id = 0
  #    object.valid?.should be_false
  #  end
  #
  #  ###############################
  #  ## Quantity Validations
  #  ###############################
  #  it "should not allow the buy_product to be create without a Quantity" do
  #    object = Factory.build(:buy_product)
  #    object.Quantity = nil
  #    object.valid?.should be_false
  #  end
  #
  #  it "should not allow the buy_product to be create with a blank Quantity" do
  #    object = Factory.build(:buy_product)
  #    object.Quantity = ""
  #    object.valid?.should be_false
  #  end
  #
  #  it "should allow the buy_product to be created with min value Quantity" do
  #    object = Factory.build(:buy_product)
  #    object.Quantity = 1
  #    object.valid?.should be_true
  #  end
  #
  #  it "should allow the buy_product to be created with valid value Quantity" do
  #    object = Factory.build(:buy_product)
  #    object.Quantity = 100
  #    object.valid?.should be_true
  #  end
  #
  #  it "should not allow the buy_product to be created with not valid value Quantity" do
  #    object = Factory.build(:buy_product)
  #    object.Quantity = 0
  #    object.valid?.should be_false
  #  end
  #
  #  ###############################
  #  ## ProductName Validations
  #  ###############################
  #  it "should not allow the buy_product to be create without a ProductName" do
  #    object = Factory.build(:buy_product)
  #    object.ProductName = nil
  #    object.valid?.should be_false
  #  end
  #
  #  it "should not allow the buy_product to be create with a blank ProductName" do
  #    object = Factory.build(:buy_product)
  #    object.ProductName = ""
  #    object.valid?.should be_false
  #  end
  #
  #  it "should allow the buy_product to be created with value ProductName" do
  #    object = Factory.build(:buy_product)
  #    object.ProductName = "Product"
  #    object.valid?.should be_true
  #  end
  #
  #  ###############################
  #  ## Price Validations
  #  ###############################
  #  it "should not allow the buy_product to be create without a Price" do
  #    object = Factory.build(:buy_product)
  #    object.Price = nil
  #    object.valid?.should be_false
  #  end
  #
  #  it "should not allow the buy_product to be create with a blank Price" do
  #    object = Factory.build(:buy_product)
  #    object.Price = ""
  #    object.valid?.should be_false
  #  end
  #
  #  it "should allow the buy_product to be created with min value Price" do
  #    object = Factory.build(:buy_product)
  #    object.Price = 0
  #    object.valid?.should be_true
  #  end
  #
  #  it "should allow the buy_product to be created with valid value Price" do
  #    object = Factory.build(:buy_product)
  #    object.Price = 100
  #    object.valid?.should be_true
  #  end
  #
  #  it "should not allow the buy_product to be created with not valid value Price" do
  #    object = Factory.build(:buy_product)
  #    object.Price = -1
  #    object.valid?.should be_false
  #  end
  #
  #  ###############################
  #  ## Color_ID Validations
  #  ###############################
  #  it "should allow the buy_product to be create without a Color_ID" do
  #    object = Factory.build(:buy_product)
  #    object.Color_ID = nil
  #    object.valid?.should be_true
  #  end
  #
  #  it "should not allow the buy_product to be create with a blank Color_ID" do
  #    object = Factory.build(:buy_product)
  #    object.Color_ID = ""
  #    object.valid?.should be_false
  #  end
  #
  #  it "should allow the buy_product to be created with min value Color_ID" do
  #    object = Factory.build(:buy_product)
  #    object.Color_ID = 1
  #    object.valid?.should be_true
  #  end
  #
  #  it "should allow the buy_product to be created with valid value Color_ID" do
  #    object = Factory.build(:buy_product)
  #    object.Color_ID = 100
  #    object.valid?.should be_true
  #  end
  #
  #  it "should not allow the buy_product to be created with not valid value Color_ID" do
  #    object = Factory.build(:buy_product)
  #    object.Color_ID = 0
  #    object.valid?.should be_false
  #  end
  #
  #  ###############################
  #  ## Category_ID Validations
  #  ###############################
  #  it "should allow the buy_product to be create without a Category_ID" do
  #    object = Factory.build(:buy_product)
  #    object.Category_ID = nil
  #    object.valid?.should be_false
  #  end
  #
  #  it "should not allow the buy_product to be create with a blank Category_ID" do
  #    object = Factory.build(:buy_product)
  #    object.Category_ID = ""
  #    object.valid?.should be_false
  #  end
  #
  #  it "should allow the buy_product to be created with min value Category_ID" do
  #    object = Factory.build(:buy_product)
  #    object.Category_ID = 1
  #    object.valid?.should be_true
  #  end
  #
  #  it "should allow the buy_product to be created with valid value Category_ID" do
  #    object = Factory.build(:buy_product)
  #    object.Category_ID = 100
  #    object.valid?.should be_true
  #  end
  #
  #  it "should not allow the buy_product to be created with not valid value Category_ID" do
  #    object = Factory.build(:buy_product)
  #    object.Category_ID = 0
  #    object.valid?.should be_false
  #  end
  #
  #  ###############################
  #  ## Tax Validations
  #  ###############################
  #  it "should not allow the buy_product to be create without a Tax" do
  #    object = Factory.build(:buy_product)
  #    object.Tax = nil
  #    object.valid?.should be_false
  #  end
  #
  #  it "should not allow the buy_product to be create with a blank Tax" do
  #    object = Factory.build(:buy_product)
  #    object.Tax = ""
  #    object.valid?.should be_false
  #  end
  #
  #  it "should allow the buy_product to be created with min value Tax" do
  #    object = Factory.build(:buy_product)
  #    object.Tax = 0
  #    object.valid?.should be_true
  #  end
  #
  #  it "should allow the buy_product to be created with valid value Tax" do
  #    object = Factory.build(:buy_product)
  #    object.Tax = 100
  #    object.valid?.should be_true
  #  end
  #
  #  it "should not allow the buy_product to be created with not valid value Tax" do
  #    object = Factory.build(:buy_product)
  #    object.Tax = -1
  #    object.valid?.should be_false
  #  end
  #
  #  ###############################
  #  ## Shipment Validations
  #  ###############################
  #  it "should not allow the buy_product to be create without a Shipment" do
  #    object = Factory.build(:buy_product)
  #    object.Shipment = nil
  #    object.valid?.should be_false
  #  end
  #
  #  it "should not allow the buy_product to be create with a blank Shipment" do
  #    object = Factory.build(:buy_product)
  #    object.Shipment = ""
  #    object.valid?.should be_false
  #  end
  #
  #  it "should allow the buy_product to be created with min value Shipment" do
  #    object = Factory.build(:buy_product)
  #    object.Shipment = 0
  #    object.valid?.should be_true
  #  end
  #
  #  it "should allow the buy_product to be created with valid value Shipment" do
  #    object = Factory.build(:buy_product)
  #    object.Shipment = 50
  #    object.valid?.should be_true
  #  end
  #
  #  it "should not allow the buy_product to be created with not valid value Shipment" do
  #    object = Factory.build(:buy_product)
  #    object.Shipment = -1
  #    object.valid?.should be_false
  #  end
  #
  #  ###############################
  #  ## list_params Validations
  #  ###############################
  #  it "should not allow the buy_product to be create without a list_params" do
  #    object = Factory.build(:buy_product)
  #    object.list_params = nil
  #    object.valid?.should be_false
  #  end
  #
  #  it "should not allow the buy_product to be create with a blank list_params" do
  #    object = Factory.build(:buy_product)
  #    object.list_params = ""
  #    object.valid?.should be_false
  #  end
  #
  #  it "should allow the buy_product to be created with empty array list_params" do
  #    object = Factory.build(:buy_product)
  #    object.list_params = []
  #    object.valid?.should be_true
  #  end
  #
  #  it "should allow the buy_product to be created with valid array list_params" do
  #    object = Factory.build(:buy_product)
  #    object.list_params = [1,2,4,5]
  #    object.valid?.should be_true
  #  end
  #end
end