require 'spec_helper'

describe Store do
  ###############################
  ## VALIDATIONS
  ###############################
  describe "Validations" do

    it "should allow the store to be created" do
      expect {
        object = Factory.build(:store)
        object.save!()
      }.to change { Store.count }.by(1)
    end

    it "should allow two store to be created" do
      expect {
        object = Factory.build(:store)
        object.save!()
        object2 = Factory.build(:store)
        object2.save!()
      }.to change { Store.count }.by(2)
    end

    it "should not allow the store to be created without necessarily fields" do
      expect {
        object = Factory.build(:store)
        object.Email = nil
        object.Phone = nil
        object.save!()
      }.to change { Store.count }.by(1)
    end

    ###############################
    ## Name Validations
    ###############################
    it "should not allow the store to be create without a Name " do

      object = Factory.build(:store)
      object.Name = nil
      object.save().should be_false

    end

    it "should not allow the store to be create with a blank Name " do
      object = Factory.build(:store)
      object.Name = ""
      object.save().should be_false
    end

    it "should allow the store to be created with max length Name" do
      expect {
        object = Factory.build(:store)
        object.Name = ("a" * 50)
        object.save!()
      }.to change { Store.count }.by(1)
    end

    it "should not allow the store to be created with max length +1 Name" do
      object = Factory.build(:store)
      object.Name = ("a" * 51)
      object.save().should be_false
    end

    ###############################
    ## Street Validations
    ###############################
    it "should not allow the store to be create without a Street " do
      object = Factory.build(:store)
      object.Street = nil
      object.save().should be_false
    end

    it "should not allow the store to be create with a blank Street " do
      object = Factory.build(:store)
      object.Street = ""
      object.save().should be_false
    end

    it "should allow the store to be created with max length Street" do
      expect {
        object = Factory.build(:store)
        object.Street = ("a" * 50)
        object.save!()
      }.to change { Store.count }.by(1)
    end

    it "should not allow the store to be created with max length +1 Street" do
      object = Factory.build(:store)
      object.Street = ("a" * 51)
      object.save().should be_false
    end

    ###############################
    ## City Validations
    ###############################
    it "should not allow the store to be create without a City " do
      object = Factory.build(:store)
      object.City = nil
      object.save().should be_false
    end

    it "should not allow the store to be create with a blank City " do
      object = Factory.build(:store)
      object.City = ""
      object.save().should be_false
    end

    it "should allow the store to be created with max length City" do
      expect {
        object = Factory.build(:store)
        object.City = ("a" * 50)
        object.save!()
      }.to change { Store.count }.by(1)
    end

    it "should not allow the store to be created with max length +1 City" do
      object = Factory.build(:store)
      object.City = ("a" * 51)
      object.save().should be_false
    end

    ###############################
    ## ZIP Validations
    ###############################
    it "should not allow the store to be created without a ZIP" do
        object = Factory.build(:store, :ZIP => nil)
        object.save().should be_false
    end

    it "should allow the store to be created without a standard ZIP" do
      expect {
        object = Factory.build(:store, :ZIP => "98121")
        object.save!()
      }.to change { Store.count }.by(1)
    end

    it "should allow the store to be created without an extended ZIP" do
      expect {
        object = Factory.build(:store, :ZIP => "98121-2132")
        object.save!()
      }.to change { Store.count }.by(1)
    end

    it "should not allow the store to be created with invalid ZIP 1" do
        object = Factory.build(:store, :ZIP => "abcde" )
        object.save().should be_false
    end

    it "should not allow the store to be created with invalid ZIP 2" do
        object = Factory.build(:store, :ZIP => "" )
        object.save().should be_false
    end

    it "should not allow the store to be created with invalid ZIP 3" do
        object = Factory.build(:store, :ZIP => "1234" )
        object.save().should be_false
    end

    it "should not allow the store to be created with invalid ZIP 4" do
        object = Factory.build(:store, :ZIP => "123456" )
        object.save().should be_false
    end

    it "should not allow the store to be created with invalid ZIP 5" do
        object = Factory.build(:store, :ZIP => "12345-" )
        object.save().should be_false
    end

    it "should not allow the store to be created with invalid ZIP 6" do
        object = Factory.build(:store, :ZIP => "12345-333" )
        object.save().should be_false
    end

    it "should not allow the store to be created with invalid ZIP 7" do
        object = Factory.build(:store, :ZIP => "12345-33323" )
        object.save().should be_false
    end

    ###############################
    ## Email Validations
    ###############################
    it "should allow the store to be created without an email " do
      object = Factory.build(:store, :Email => nil)
      object.save().should be_true
    end

    it "should allow the store to be created with an empty email " do
      object = Factory.build(:store, :Email => "")
      object.save().should be_true
    end

    it "should allow store to be created with valid email " do
      object = Factory.build(:store, :Email => "joe@joe.com")
      object.save().should be_true
    end

    it "should not allow the store to be create with an invalid email 1" do
      object = Factory.build(:store, :Email => "jacom")
      object.save().should be_false
    end

    it "should not allow the store to be create with an invalid email 2" do
      object = Factory.build(:store, :Email => "j@acom")
      object.save().should be_false
    end

    it "should not allow the store to be create with an invalid email 3" do
      object = Factory.build(:store, :Email => "ja.com")
      object.save().should be_false
    end

    it "should not allow the store to be create with an invalid email 4" do
      object = Factory.build(:store, :Email => "@a.com")
      object.save().should be_false
    end

    it "should not allow the store to be create with an invalid email 5" do
      object = Factory.build(:store, :Email => "j@.com")
      object.save().should be_false
    end

    it "should not allow the store to be create with an invalid email 6" do
      object = Factory.build(:store, :Email => "j@a.")
      object.save().should be_false
    end

    it "should not allow the store to be create with an invalid email 7" do
      object = Factory.build(:store, :Email => "@.com")
      object.save().should be_false
    end

    it "should not allow the store to be create with an invalid email 8" do
      object = Factory.build(:store, :Email => "@.")
      object.save().should be_false
    end

    it "should allow store to be updated with same email" do
      object = Factory.build(:store, :Email => "joe@joe.com")
      object.save().should be_true
      object.Email = "joe@joe.com"
      object.save().should be_true
    end

    it "should allow store to be updated with another email" do
      object = Factory.build(:store, :Email => "joe@joe.com")
      object.save().should be_true
      object.Email = "joe1@joe.com"
      object.save().should be_true
    end

    it "should allow store to be updated with another email" do
      object = Factory.build(:store, :Email => "joe@joe.com")
      object.save().should be_true
      object.Email = "joe1@joe.com"
      object.save().should be_true
    end

    it "should allow the store to be created with max length email" do
      object = Factory.build(:store)
      object.Email = ("a" * 44) + "@a.com"
      object.save().should be_true
    end

    it "should not allow the store to be created with max length +1 email" do
      object = Factory.build(:store)
      object.Email = ("a" * 45) + "@a.com"
      object.save().should be_false
    end

    ###############################
    ## State_ID Validations
    ###############################
    it "should not allow the store to be created without a State_ID" do
        object = Factory.build(:store, :State_ID => nil)
        object.save.should be_false
    end

    it "should not allow the store to be created with non-numeric State_ID" do
        object = Factory.build(:store, :State_ID => "a" )
        object.save.should be_false
    end

    it "should not allow the store to be created with negative State_ID" do
        object = Factory.build(:store, :State_ID => -12 )
        object.save.should be_false
    end

    ###############################
    ## Category Validations
    ###############################
    it "should not allow the store to be created without a Category_ID" do
        store = Factory.build(:store)
        store.category = nil
        store.save.should be_false
    end

    ###############################
    ## Description Validations
    ###############################
    it "should allow the store to be created without an Description " do
      object = Factory.build(:store, :Description => nil)
      object.save().should be_true
    end

    it "should allow the store to be created with an empty Description " do
      object = Factory.build(:store, :Description => "")
      object.save().should be_true
    end

    it "should allow the store to be created with max length Description" do
      expect {
        object = Factory.build(:store, :Description => ("a" * 300))
        object.save!()
      }.to change { Store.count }.by(1)
    end

    it "should not allow the store to be created with max length +1 Description" do
      object = Factory.build(:store, :Description => ("a" * 301))
      object.save().should be_false
    end
  end

  ###############################
  ## Get products
  ###############################
  describe "Get products" do
    before(:each) do
      @store = Factory.create(:store)
      @store1 = Factory.create(:store)
      @category = Factory.create(:category)
      @product1 = Factory.create(:product)
      @product2 = Factory.create(:product)
      @product3 = Factory.create(:product)
      @product4 = Factory.create(:product)
      @product5 = Factory.create(:product)
      @p2s1 = Factory.create(:products2store, :store => @store, :product => @product1)
      @p2s2 = Factory.create(:products2store, :store => @store, :product => @product2)
      @p2s3 = Factory.create(:products2store, :store => @store, :product => @product3)
      @p2s4 = Factory.create(:products2store, :store => @store, :product => @product4)
      @p2s5 = Factory.create(:products2store, :store => @store1, :product => @product5)
      Factory.create(:products2category, :product => @product1, :category => @category)
      Factory.create(:products2category, :product => @product2, :category => @category)
      Factory.create(:products2category, :product => @product3, :category => @category)
      Factory.create(:products2category, :product => @product4, :category => @category)
      Factory.create(:products2category, :product => @product5, :category => @category)
    end

    it 'should list products in the store' do
      @store.products.should == [@product1, @product2, @product3, @product4]
    end

    it 'should count products in the store' do
      @store.count_products.should == 4
    end

  end

  describe "Get orders" do
    it "should show all orders for store" do
      store = Factory.create(:store, :IsDefault => true)
      product = Factory.create(:product)
      product1 = Factory.create(:product)
      Factory.create(:products2store, :product => product, :store => store)
      Factory.create(:products2store, :product => product1, :store => store)
      store.orders.should == []
      5.times {
        Factory.create(:orders2product, :product => product)
        Factory.create(:orders2product, :product => product1)
        registry_item = Factory.create(:registry_item, :product => product, :Purchased_ID => RegistryItem::PURCHASED)
        Factory.create(:orders2registry_item, :registry_item => registry_item, :Contribute_ID => nil, :IsGetMoney => 0)
      }
      store.orders.count.should == 15
      order = Factory.create(:order)
      Factory.create(:orders2product, :product => product, :order => order)
      Factory.create(:orders2product, :product => product1, :order => order)
      store.orders.count.should == 16
    end
  end

  describe "visible" do

    before (:each) do
      @visible_store = Factory.create(:store)
      @hidden_store = Factory.create(:store, :visible => false)
      @deleted_store = Factory.create(:store, :IsDeleted => true)

      @partner = Factory.create(:partner, :IsDeleted => true)
      @partner_deleted_store = Factory.create(:store, :partner => @partner)

    end

    it 'should includes stores that are visible, not deleted and whose partner is not deleted' do
      Store.visible.should include @visible_store
    end

    it 'should not include store that are not visible' do
      Store.visible.should_not include @hidden_store
    end

    it 'should not include stores that are deleted' do
      Store.visible.should_not include @deleted_store
    end

    it 'should not include stores whose partners are deleted.' do
      Store.visible.should_not include @patner_deleted_store
    end

  end

end

