require 'spec_helper'

describe Category do

  ###############################
  ## VALIDATIONS
  ###############################
  describe "Validations" do

    it "should allow the category to be created" do
      expect {
        object = Factory.build(:category)
        object.save!()
      }.to change { Category.count }.by(1)
    end

    it "should allow two categories to be created" do
      expect {
        object = Factory.build(:category, :name => "Test Sport")
        object.save!()
        object2 = Factory.build(:category, :name => "Test Kitchen")
        object2.save!()
      }.to change { Category.count }.by(2)
    end

    it "should allow the category to the parent category should be created" do
      expect {
        object = Factory.build(:category, :name => "Test Sport")
        object.save!()
        object2 = Factory.build(:category,
                                :parent_id => object.parent_id,
                                :name => "Test Kitchen")
        object2.save!()
      }.to change { Category.count }.by(2)
    end

    ###############################
    ## name Validations
    ###############################
    it "should not allow the category to be create without a name " do

      object = Factory.build(:category)
      object.name = nil
      object.valid?.should be_false

    end

    it "should not allow the category to be create with a blank name " do
      object = Factory.build(:category)
      object.name = ""
      object.valid?.should be_false
    end

    it "should allow the category to be created with max length name" do
        object = Factory.build(:category)
        object.name = ("a" * 50)
        object.valid?.should be_true
    end

    it "should not allow the category to be created with max length +1 name" do
      object = Factory.build(:category)
      object.name = ("a" * 51)
      object.valid?.should be_false
    end

    ###############################
    ## per_shipment Validations
    ###############################
    it "should not allow the category to be created without a per_shipment " do
      object = Factory.build(:category)
      object.per_shipment = nil
      object.valid?.should be_false
    end

    it "should not allow the category to be created with not number per_shipment " do

      object = Factory.build(:category)
      object.per_shipment = "asdsd"
      object.valid?.should be_false

    end

    it "should not allow the category to be created with value < 0 of per_shipment " do

      object = Factory.build(:category)
      object.per_shipment = -10.10
      object.valid?.should be_false

    end

    it "should not allow the category to be created with value > 100 of per_shipment " do

      object = Factory.build(:category)
      object.per_shipment = 101
      object.valid?.should be_false

    end

    it "should allow the category to be created with number per_shipment" do
      object = Factory.build(:category)
      object.per_shipment = 10.10
      object.valid?.should be_true
    end

    it "should allow the category to be created with min value per_shipment" do
      object = Factory.build(:category)
      object.per_shipment = 0
      object.valid?.should be_true
    end

    it "should allow the category to be created with max value per_shipment" do
      object = Factory.build(:category)
      object.per_shipment = 100
      object.valid?.should be_true
    end


    ###############################
    ## parent_id Validations
    ###############################
    it "should not allow the category to be created without a parent_id " do
      object = Factory.build(:category)
      object.parent_id = nil
      object.valid?.should be_false
    end

    it "should not allow the category to be created with not number parent_id " do
      object = Factory.build(:category)
      object.per_shipment = "asdsd"
      object.valid?.should be_false
    end

    it "should not allow the category to be created with value < 0 of parent_id " do
      object = Factory.build(:category)
      object.per_shipment = -1
      object.valid?.should be_false
    end

    it "should not allow the category to be create with float number of parent_id " do
      object = Factory.build(:category)
      object.per_shipment = -10.10
      object.valid?.should be_false
    end

    it "should allow the category to be created with number parent_id" do
      object = Factory.build(:category)
      object.per_shipment = 1
      object.valid?.should be_true
    end

  end

  ###############################
  ## Validate the visible scope.
  ###############################
  describe "Validates visible scope"  do

    it 'should not include not visible categories when looking up children.' do
      parent = Factory.create(:category, :name => "Test Sport", :visible => true)
      child1 = Factory.create(:category_with_parent, :name => "Test Sport", :visible => true, :parent => parent)
      child2 = Factory.create(:category_with_parent, :name => "Test Sport", :visible => false, :parent => parent)

      parent.children.visible.should == [child1]
    end

    it 'should not include not visible categories when doing a scoped find.' do
      parent = Factory.build(:category, :name => "Test Sport", :visible => true)
      child1 = Factory.build(:category, :name => "Test Sport", :visible => true, :parent => parent)
      child2 = Factory.build(:category, :name => "Test Sport", :visible => false, :parent => parent)

      Category.visible.should_not include(child2)
    end

  end

  ###############################
  ## Drop-down menu categories
  ###############################
  describe "Menu categories" do
    before(:each) do
      @parent_category = Category.root      
      @parent_id = @parent_category.id
      @essentials = Category.find_by_name('Essentials')
      @experiences = Category.find_by_name('Experiences')
      @unique_gifts = Category.find_by_name('Unique Gifts')
      @bridal_party = Category.find_by_name('Bridal Party')

      @home = Category.find_by_name('Home')
      @kitchen = Category.find_by_name('Kitchen')
      @travel = Category.find_by_name('Travel')
      @recreation = Category.find_by_name('Recreation')
      @art = Category.find_by_name('Art')
      @furniture = Category.find_by_name('Furniture')
      @clothing = Category.find_by_name('Clothing')
      @groomsmen_presents = Category.find_by_name('Groomsmen Presents')
      @bridesmaid_presents = Category.find_by_name('Bridesmaid Presents')

      @subcategory_third_level1 = Factory.create(:category, :name => 'Test 31', :parent => @essentials)
      @subcategory_fourth_level1 = Factory.create(:category, :name => 'Test 41', :parent => @subcategory_third_level1)
      @subcategory_fourth_level2 = Factory.create(:category, :name => 'Test 42', :parent => @subcategory_third_level1)
      @subcategory_fourth_level3 = Factory.create(:category, :name => 'Test 43', :parent => @subcategory_third_level1)
    end

    it 'should find second level categories' do
      Category.get_second_level.should == [@essentials, @experiences, @unique_gifts, @bridal_party]
    end


    it 'should find category array parent ids' do
      @subcategory_fourth_level1.get_parent_ids.should == [@subcategory_fourth_level1.id, @subcategory_third_level1.id, @essentials.id]
    end

  end

  ###############################
  ## Stores and products
  ###############################
  describe "Stores and products" do
    before(:each) do
      @parent_category = Category.root
      @essentials = Category.find_by_name('Essentials')

      @cat_full = Factory.create(:category, :parent_id => @essentials.id)
      @store1 = Factory.create(:store, :category => @cat_full)
      @store2 = Factory.create(:store, :category => @cat_full)
      @store3 = Factory.create(:store, :category => @cat_full)

      @cat_empty = Factory.create(:category, :parent_id => @essentials.id)

      @cat_hidden = Factory.create(:category, :parent_id => @essentials.id, :visible => false)
      Factory.create(:store, :category => @cat_hidden, :visible => false)

      @cat_hidden_store = Factory.create(:category, :parent_id => @essentials.id)
      @store_hidden = Factory.create(:store, :category => @cat_hidden_store, :visible => false)

      @cat_deleted_store = Factory.create(:category, :parent_id => @essentials.id)
      Factory.create(:store, :category => @cat_deleted_store, :IsDeleted => true)

      @cat_deleted_partner = Factory.create(:category, :parent_id => @essentials.id)
      @partner = Factory.create(:partner, :IsDeleted => true)
      Factory.create(:store, :category => @cat_deleted_partner, :partner => @partner)

    end

    ###############################
    ## categories_with_stores
    ###############################
    it 'should return only categories with stores in them' do
      Category.with_stores.should include @cat_full
      Category.with_stores.should_not include @cat_empty
    end

    it 'should not return categories that are not visible' do
      Category.with_stores.should_not include @cat_hidden
    end

    it 'should not count stores that are not visible' do
      Category.with_stores.should_not include @cat_store_hidden
    end

    it 'should not count stores that are not deleted' do
      Category.with_stores.should_not include @cat_deleted_store
    end

    it 'should not count stores where partner is deleted' do
      Category.with_stores.should_not include @cat_deleted_partner
    end
  end

  ###############################
  ## categories_with_stores
  ###############################
  describe "Catalog_Menu" do
    it 'should return only the item for the root' do
      Category.root.catalog_menu.should == [Category.root]
    end

    it 'should return the path' do
      @essentials = Category.find_by_name('Essentials')
      @home = Category.find_by_name('Home')

      @home.catalog_menu.should == [Category.root, @essentials, @home]
    end
  end
end

