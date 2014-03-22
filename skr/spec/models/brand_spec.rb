require "spec_helper"

describe Brand do
  ###############################
  ## VALIDATIONS
  ###############################
  describe "Validations" do

    it "should allow the brand to be created" do
      expect {
        object = Factory.build(:brand)
        object.save!()
      }.to change { Brand.count }.by(1)
    end

    it "should allow two brand to be created" do
      expect {
        object = Factory.build(:brand, :Name => 'Test brand 1')
        object.save!()
        object2 = Factory.build(:brand, :Name => 'Test brand 2')
        object2.save!()
      }.to change { Brand.count }.by(2)
    end

    ###############################
    ## Name Validations
    ###############################
    it "should not allow the brand to be create without a Name " do
      object = Factory.build(:brand)
      object.Name = nil
      object.valid?.should be_false
    end

    it "should not allow the brand to be create with a blank Name " do
      object = Factory.build(:brand)
      object.Name = ""
      object.valid?.should be_false
    end

    it "should allow the brand to be created with max length Name" do
      expect {
        object = Factory.build(:brand)
        object.Name = ("a" * 50)
        object.save!()
      }.to change { Brand.count }.by(1)
    end

    it "should not allow the brand to be created with max length +1 Name" do
      object = Factory.build(:brand)
      object.Name = ("a" * 51)
      object.valid?.should be_false
    end

    it "should not allow two brand to be created with the same name" do
      object = Factory.build(:brand, :Name => 'Test brand name')
      object.save().should be_true
      object2 = Factory.build(:brand, :Name => 'Test brand name')
      object2.save().should be_false
    end
  end

  ###############################
  ## Get brands and count products
  ###############################
  describe "Get brands" do
    before(:each) do
      @brand = Factory.create(:brand)
      @brand1 = Factory.create(:brand)
      @brand2 = Factory.create(:brand)
      @category = Factory.create(:category)
      5.times do |i|
        product = Factory.create(:product, :categories => [@category], :Brand_ID => @brand.id)
        product = Factory.create(:product, :categories => [@category], :Brand_ID => @brand1.id)
      end
    end

    it 'should all brands in which there are products' do
      Brand.find_all_with_products.should == [@brand, @brand1].sort_by{|x| x.Name}
    end

  end
end

