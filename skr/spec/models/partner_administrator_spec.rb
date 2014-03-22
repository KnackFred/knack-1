require "spec_helper"

describe PartnerAdministrator do
  ###############################
  ## VALIDATIONS
  ###############################
  describe "Validations" do

    it "should allow the Partner Administrator to be created" do
      expect {
        object = Factory.build(:partner_administrator)
        object.save!()
      }.to change { PartnerAdministrator.count }.by(1)
    end

    it "should allow two brand to be created" do
      expect {
        object = Factory.build(:partner_administrator)
        object.save!()
        object2 = Factory.build(:partner_administrator)
        object2.save!()
      }.to change { PartnerAdministrator.count }.by(2)
    end

    ###############################
    ## First Name Validations
    ###############################
    it "should not allow the Partner Administrator to be create without a first name " do
      object = Factory.build(:partner_administrator)
      object.first_name = nil
      object.valid?.should be_false
    end

    it "should not allow the Partner Administrator to be create with a blank first name " do
      object = Factory.build(:partner_administrator)
      object.first_name = ""
      object.valid?.should be_false
    end

    it "should allow the brand to be created with max length first name" do
      object = Factory.build(:partner_administrator)
      object.first_name = ("a" * 50)
      object.valid?.should be_true
    end

    it "should not allow the brand to be created with max length +1 first name" do
      object = Factory.build(:partner_administrator)
      object.first_name = ("a" * 51)
      object.valid?.should be_false
    end

    ###############################
    ## Last Name Validations
    ###############################
    it "should not allow the Partner Administrator to be create without a last name " do
      object = Factory.build(:partner_administrator)
      object.last_name = nil
      object.valid?.should be_false
    end

    it "should not allow the Partner Administrator to be create with a blank last name " do
      object = Factory.build(:partner_administrator)
      object.last_name = ""
      object.valid?.should be_false
    end

    it "should allow the brand to be created with max length last name" do
      object = Factory.build(:partner_administrator)
      object.last_name = ("a" * 50)
      object.valid?.should be_true
    end

    it "should not allow the brand to be created with max length +1 last name" do
      object = Factory.build(:partner_administrator)
      object.last_name = ("a" * 51)
      object.valid?.should be_false
    end

    describe "email" do
      ###############################
      ## email Validations
      ###############################
      it "should not allow to be created without an email " do
        object = Factory.build(:partner_administrator, :email => nil)
        object.valid?.should be_false
      end

      it "should not allow the object to be created with an empty email " do
        object = Factory.build(:partner_administrator, :email => "")
        object.valid?.should be_false
      end

      it "should not allow objects to be created with duplicate emails " do
        object = Factory.build(:partner_administrator, :email => "joe@joe.com")
        object.save().should be_true
        object2 = Factory.build(:partner_administrator, :email => "joe@joe.com")
        object2.save().should be_false
      end

      it "should not allow the object to be create with an invalid email 1" do
        object = Factory.build(:partner_administrator, :email => "jacom")
        object.valid?.should be_false
      end

      it "should not allow the object to be create with an invalid email 2" do
        object = Factory.build(:partner_administrator, :email => "j@acom")
        object.valid?.should be_false
      end

      it "should not allow the object to be create with an invalid email 3" do
        object = Factory.build(:partner_administrator, :email => "ja.com")
        object.valid?.should be_false
      end

      it "should not allow the object to be create with an invalid email 4" do
        object = Factory.build(:partner_administrator, :email => "@a.com")
        object.valid?.should be_false
      end

      it "should not allow the object to be create with an invalid email 5" do
        object = Factory.build(:partner_administrator, :email => "j@.com")
        object.valid?.should be_false
      end

      it "should not allow the object to be create with an invalid email 6" do
        object = Factory.build(:partner_administrator, :email => "j@a.")
        object.valid?.should be_false
      end

      it "should not allow the object to be create with an invalid email 7" do
        object = Factory.build(:partner_administrator, :email => "@.com")
        object.valid?.should be_false
      end

      it "should not allow the object to be create with an invalid email 8" do
        object = Factory.build(:partner_administrator, :email => "@.")
        object.valid?.should be_false
      end

      it "should allow objects to be updated with same email" do
        object = Factory.build(:partner_administrator, :email => "joe@joe.com")
        object.save().should be_true
        object.email = "joe@joe.com"
        object.save().should be_true
      end

      it "should allow the object to be created with max length email" do

        object = Factory.build(:partner_administrator)
        object.email = ("a" * 44) + "@a.com"
        object.valid?.should be_true
      end

      it "should not allow the object to be created with max length +1 email" do
        object = Factory.build(:partner_administrator)
        object.email = ("a" * 45) + "@a.com"
        object.valid?.should be_false
      end
    end

    describe "Phone" do
      it "should be valid with valid phone" do
        object = Factory.build(:partner_administrator, :phone => "416-919-8124")
        object.valid?.should be_true
      end

      it "should not be valid with invalid phone " do
        object = Factory.build(:partner_administrator, :phone => "foo")
        object.valid?.should be_false
      end

    end
  end

  describe "authentication" do
    describe "create password" do
      it "should not allow to be created without a Password" do
        expect {
          object = Factory.build(:partner_administrator)
          object.new_password = nil
          object.save!()
        }.to raise_exception()
      end

      it "should allow the object to be created with max length Password" do
        expect {
          object = Factory.build(:partner_administrator)
          object.new_password = ("a" * 20)
          object.save!()
        }.to change { PartnerAdministrator.count }.by(1)
      end

      it "should not allow the object to be created with max length +1 Password" do
        expect {
          object = Factory.build(:partner_administrator)
          object.new_password = ("a" * 21)
          object.save!()
        }.to raise_exception()
      end

      it "should allow the object to be created with min length Password" do
        expect {
          object = Factory.build(:partner_administrator)
          object.new_password = ("a" * 6)
          object.save!()
        }.to change { PartnerAdministrator.count }.by(1)
      end

      it "should not allow the object to be created with min length -1 Password" do
        expect {
          object = Factory.build(:partner_administrator)
          object.new_password = ("a" * 5)
          object.save!()
        }.to raise_exception()
      end
    end

    describe "change password" do
      it "should change the password if old_password is wrong" do
        object = Factory.create(:partner_administrator, :new_password => "123456")
        object.change_password = "1"
        object.new_password = "new_password"
        object.old_password = "123456"
        object.save.should be_true
        PartnerAdministrator.check_administrator(object.email, "new_password").should be_instance_of(PartnerAdministrator)
      end

      it "should not change the password if old_password is wrong" do
        object = Factory.create(:partner_administrator, :new_password => "123456")
        object.change_password = "1"
        object.new_password = "new_password"
        object.old_password = "foo"
        object.save.should be_false
      end
    end

    ###############################
    ## Authentication Basic
    ###############################
    it "should allow a user to log in with correct credentials" do
      registrant = Factory.build(:partner_administrator,
                                 :email => "foo@bar.com",
                                 :new_password => "Swordfish")
      registrant.save!()
      PartnerAdministrator.check_administrator("foo@bar.com", "Swordfish").should be_instance_of(PartnerAdministrator)
    end

    it "should allow a user to log in with correct credentials (w. whitespace)" do
      registrant = Factory.build(:partner_administrator,
                                 :email => "foo@bar.com",
                                 :new_password => "Swordfish")
      registrant.save!()
      PartnerAdministrator.check_administrator("foo@bar.com", " Swordfish ").should be_instance_of(PartnerAdministrator)
    end

    it "should not allow a user to log in with incorrect credentials" do
      registrant = Factory.build(:partner_administrator,
                                 :email => "foo@bar.com",
                                 :new_password => "Swordfish")
      registrant.save!()
      PartnerAdministrator.check_administrator("foo@bar.com", "Not Swordfish").should be_nil
    end

    it "should not allow a user to log in who is deleted credentials" do
      registrant = Factory.build(:partner_administrator,
                                 :email => "foo@bar.com",
                                 :new_password => "Swordfish",
                                 :is_deleted => true)
      registrant.save!()
      PartnerAdministrator.check_administrator("foo@bar.com", "Swordfish").should be_nil
    end

    it "should not allow a user to log in who entered incorrect email" do
      registrant = Factory.build(:partner_administrator,
                                 :email => "foo@bar.com",
                                 :new_password => "Swordfish")
      registrant.save!()
      PartnerAdministrator.check_administrator("NOT@AN.EMAIL", "Swordfish").should be_nil

    end
  end
end

