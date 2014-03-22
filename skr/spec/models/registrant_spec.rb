require 'spec_helper'

describe Registrant do

  describe "Validations" do

    it "should allow the registrant to be created" do
      expect {
        registrant = Factory.build(:registrant)
        registrant.save!()
      }.to change { Registrant.count }.by(1)
    end

    it "should allow two registrants to be created" do
      expect {
        registrant = Factory.build(:registrant)
        registrant.save!()
        registrant2 = Factory.build(:registrant)
        registrant2.save!()
      }.to change { Registrant.count }.by(2)
    end

    it "should allow the registrant to be created without a profile" do
      expect {
        registrant = Factory.build(:registrant)
        registrant.FirstNameCoCreated = nil
        registrant.LastNameCoCreated = nil
        registrant.Address = nil
        registrant.City = nil
        registrant.ZIP = nil
        registrant.EventLocation = nil
        registrant.RegistryType_ID = nil
        registrant.save!()
      }.to change { Registrant.count }.by(1)
    end

    ###############################
    ## Email Validations
    ###############################
    it "should not allow the registrant to be created without an email " do
      registrant = Factory.build(:registrant, :Email => nil)
      registrant.save().should be_false
    end

    it "should not allow the registrant to be created with an empty email " do
      registrant = Factory.build(:registrant, :Email => "")
      registrant.save().should be_false
    end

    it "should not allow registrants to be created with duplicate emails " do
      registrant = Factory.build(:registrant, :Email => "joe@joe.com")
      registrant.save().should be_true
      registrant2 = Factory.build(:registrant, :Email => "joe@joe.com")
      registrant2.save().should be_false
    end

    it "should not allow the registrant to be create with an invalid email 1" do
      registrant = Factory.build(:registrant, :Email => "jacom")
      registrant.save().should be_false
    end

    it "should not allow the registrant to be create with an invalid email 2" do
      registrant = Factory.build(:registrant, :Email => "j@acom")
      registrant.save().should be_false
    end

    it "should not allow the registrant to be create with an invalid email 3" do
      registrant = Factory.build(:registrant, :Email => "ja.com")
      registrant.save().should be_false
    end

    it "should not allow the registrant to be create with an invalid email 4" do
      registrant = Factory.build(:registrant, :Email => "@a.com")
      registrant.save().should be_false
    end

    it "should not allow the registrant to be create with an invalid email 5" do
      registrant = Factory.build(:registrant, :Email => "j@.com")
      registrant.save().should be_false
    end

    it "should not allow the registrant to be create with an invalid email 6" do
      registrant = Factory.build(:registrant, :Email => "j@a.")
      registrant.save().should be_false
    end

    it "should not allow the registrant to be create with an invalid email 7" do
      registrant = Factory.build(:registrant, :Email => "@.com")
      registrant.save().should be_false
    end

    it "should not allow the registrant to be create with an invalid email 8" do
      registrant = Factory.build(:registrant, :Email => "@.")
      registrant.save().should be_false
    end

    it "should allow registrants to be updated with same email" do
      registrant = Factory.build(:registrant, :Email => "joe@joe.com")
      registrant.save().should be_true
      registrant.Email = "joe@joe.com"
      registrant.save().should be_true
    end

    it "should not allow registrants to be updated with another email and with duplicate" do
      registrant = Factory.build(:registrant, :Email => "joe@joe.com")
      registrant.save().should be_true
      registrant2 = Factory.build(:registrant, :Email => "joe1@joe.com")
      registrant2.save().should be_true
      registrant.Email = "joe1@joe.com"
      registrant.save().should be_false
    end

    it "should allow registrants to be updated with another email" do
      registrant = Factory.build(:registrant, :Email => "joe@joe.com")
      registrant.save().should be_true
      registrant.Email = "joe1@joe.com"
      registrant.save().should be_true
    end

    it "should allow the registrant to be created with max length email" do

      registrant = Factory.build(:registrant)
      registrant.Email = ("a" * 54) + "@a.com"
      registrant.save().should be_true
    end

    it "should not allow the registrant to be created with max length +1 email" do
      registrant = Factory.build(:registrant)
      registrant.Email = ("a" * 55) + "@a.com"
      registrant.save().should be_false
    end

    ###############################
    ## Name Validations
    ###############################
    it "should not allow the registrant to be create without a FirstName " do
      expect {
        registrant = Factory.build(:registrant)
        registrant.FirstName = nil
        registrant.save!()
      }.to raise_exception()
    end

    it "should not allow the registrant to be create without a LastName " do
      expect {
        registrant = Factory.build(:registrant)
        registrant.LastName = nil
        registrant.save!()
      }.to raise_exception()
    end

    it "should not allow the registrant to be create with a blank FirstName " do
      expect {
        registrant = Factory.build(:registrant)
        registrant.FirstName = ""
        registrant.save!()
      }.to raise_exception()
    end

    it "should not allow the registrant to be create with a blank LastName " do
      expect {
        registrant = Factory.build(:registrant)
        registrant.LastName = ""
        registrant.save!()
      }.to raise_exception()
    end

    it "should allow the registrant to be created with max length FirstName" do
      expect {
        registrant = Factory.build(:registrant)
        registrant.FirstName = ("a" * 30)
        registrant.save!()
      }.to change { Registrant.count }.by(1)
    end

    it "should allow the registrant to be created with max length LastName" do
      expect {
        registrant = Factory.build(:registrant)
        registrant.LastName = ("a" * 30)
        registrant.save!()
      }.to change { Registrant.count }.by(1)
    end


    it "should not allow the registrant to be created with max length +1 First Name" do
      expect {
        registrant = Factory.build(:registrant)
        registrant.FirstName = ("a" * 31)
        registrant.save!()
      }.to raise_exception()
    end

    it "should not allow the registrant to be created with max length +1 Last Name" do
      expect {
        registrant = Factory.build(:registrant)
        registrant.LastName = ("a" * 31)
        registrant.save!()
      }.to raise_exception()
    end


    ###############################
    ## Password Validations
    ###############################
    it "should not allow the registrant to be created without a Password" do
      expect {
        registrant = Factory.build(:registrant)
        registrant.new_password = nil
        registrant.save!()
      }.to raise_exception()
    end

    it "should allow the registrant to be created with max length Password" do
      expect {
        registrant = Factory.build(:registrant)
        registrant.new_password = ("a" * 20)
        registrant.save!()
      }.to change { Registrant.count }.by(1)
    end

    it "should not allow the registrant to be created with max length +1 Password" do
      expect {
        registrant = Factory.build(:registrant)
        registrant.new_password = ("a" * 21)
        registrant.save!()
      }.to raise_exception()
    end

    it "should allow the registrant to be created with min length Password" do
      expect {
        registrant = Factory.build(:registrant)
        registrant.new_password = ("a" * 6)
        registrant.save!()
      }.to change { Registrant.count }.by(1)
    end

    it "should not allow the registrant to be created with min length -1 Password" do
      expect {
        registrant = Factory.build(:registrant)
        registrant.new_password = ("a" * 5)
        registrant.save!()
      }.to raise_exception()
    end

    ###############################
    ## City Validations
    ###############################
    it "should allow the registrant to be created without a City" do
      expect {
        registrant = Factory.build(:registrant, :City => nil)
        registrant.save!()
      }.to change { Registrant.count }.by(1)
    end

    it "should allow the registrant to be updated without a City" do
        registrant = Factory.build(:registrant, :City => nil)
        registrant.save().should be_true
        registrant.save().should be_true
    end


    it "should allow the registrant to be created with max length FirstName" do
      expect {
        registrant = Factory.build(:registrant, :City => ("a" * 50))
        registrant.save!()
      }.to change { Registrant.count }.by(1)
    end

    it "should not allow the registrant to be created with max length +1 First Name" do
      expect {
        registrant = Factory.build(:registrant, :City => ("a" * 51))
        registrant.save!()
      }.to raise_exception()
    end

    ###############################
    ## State_ID Validations
    ###############################
    it "should not allow the registrant to be created without a State_ID" do
      expect {
        registrant = Factory.build(:registrant, :State_ID => nil)
        registrant.save!()
      }.to raise_exception()
    end

    it "should not allow the registrant to be updated without a State_ID" do
      expect {
      registrant = Factory.build(:registrant, :State_ID => nil)
        registrant.save!()
        registrant.save!()
      }.to raise_exception()
    end

    it "should not allow the registrant to be created with non-numeric State_ID" do
      expect {
        registrant = Factory.build(:registrant, :State_ID => "a" )
        registrant.save!()
      }.to raise_exception()
    end

    it "should not allow the registrant to be created with negative State_ID" do
      expect {
        registrant = Factory.build(:registrant, :State_ID => -12 )
        registrant.save!()
      }.to raise_exception()
    end

    ###############################
    ## ZIP Validations
    ###############################
    it "should allow the registrant to be created without a ZIP" do
      expect {
        registrant = Factory.build(:registrant, :ZIP => nil)
        registrant.save!()
      }.to change { Registrant.count }.by(1)
    end

    it "should allow the registrant to be updated without a ZIP" do
      registrant = Factory.build(:registrant, :ZIP => nil)
      registrant.save().should be_true
      registrant.save().should be_true
    end

    it "should allow the registrant to be created without a standard ZIP" do
      expect {
        registrant = Factory.build(:registrant, :ZIP => "98121")
        registrant.save!()
      }.to change { Registrant.count }.by(1)
    end

    it "should allow the registrant to be created without an extended ZIP" do
      expect {
        registrant = Factory.build(:registrant, :ZIP => "98121-2132")
        registrant.save!()
      }.to change { Registrant.count }.by(1)
    end

    it "should not allow the registrant to be created with invalid ZIP 1" do
      expect {
        registrant = Factory.build(:registrant, :ZIP => "abcde" )
        registrant.save!()
      }.to raise_exception()
    end

    it "should not allow the registrant to be created with invalid ZIP 3" do
      expect {
        registrant = Factory.build(:registrant, :ZIP => "1234" )
        registrant.save!()
      }.to raise_exception()
    end

    it "should not allow the registrant to be created with invalid ZIP 4" do
      expect {
        registrant = Factory.build(:registrant, :ZIP => "123456" )
        registrant.save!()
      }.to raise_exception()
    end

    it "should not allow the registrant to be created with invalid ZIP 5" do
      expect {
        registrant = Factory.build(:registrant, :ZIP => "12345-" )
        registrant.save!()
      }.to raise_exception()
    end

    it "should not allow the registrant to be created with invalid ZIP 6" do
      expect {
        registrant = Factory.build(:registrant, :ZIP => "12345-333" )
        registrant.save!()
      }.to raise_exception()
    end

    it "should not allow the registrant to be created with invalid ZIP 7" do
      expect {
        registrant = Factory.build(:registrant, :ZIP => "12345-33323" )
        registrant.save!()
      }.to raise_exception()
    end

    ###############################
    ## RegistryType_ID Validations
    ###############################
    it "should allow the registrant to be created without a RegistryType_ID" do
      expect {
        registrant = Factory.build(:registrant, :RegistryType_ID => nil)
        registrant.save!()
      }.to change { Registrant.count }.by(1)
    end

    it "should allow the registrant to be updated without a RegistryType_ID" do
      registrant = Factory.build(:registrant, :RegistryType_ID => nil)
      registrant.save().should be_true
      registrant.save().should be_true
    end

    it "should not allow the registrant to be created with non-numeric RegistryType_ID" do
      expect {
        registrant = Factory.build(:registrant, :RegistryType_ID => "a" )
        registrant.save!()
      }.to raise_exception()
    end

    it "should not allow the registrant to be created with negative RegistryType_ID" do
      expect {
        registrant = Factory.build(:registrant, :RegistryType_ID => -12 )
        registrant.save!()
      }.to raise_exception()
    end

    ###############################
    ## FirstNameCoCreated Validations
    ###############################
    it "should allow the registrant to be created with max length FirstName" do
      expect {
        registrant = Factory.build(:registrant, :FirstNameCoCreated => ("a" * 30))
        registrant.save!()
      }.to change { Registrant.count }.by(1)
    end

    it "should not allow the registrant to be created with max length +1 First Name" do
      expect {
        registrant = Factory.build(:registrant, :FirstNameCoCreated => ("a" * 31))
        registrant.save!()
      }.to raise_exception()
    end


    ###############################
    ## LastNameCoCreated Validations
    ###############################
    it "should allow the registrant to be created with max length LastName" do
      expect {
        registrant = Factory.build(:registrant, :LastNameCoCreated => ("a" * 30))
        registrant.save!()
      }.to change { Registrant.count }.by(1)
    end

    it "should not allow the registrant to be created with max length +1 Last Name" do
      expect {
        registrant = Factory.build(:registrant, :LastNameCoCreated => ("a" * 31))
        registrant.save!()
      }.to raise_exception()
    end

    ###############################
    ## Address Validations
    ###############################
    it "should allow the registrant to be created with max length LastName" do
      expect {
        registrant = Factory.build(:registrant, :Address => ("a" * 50))
        registrant.save!()
      }.to change { Registrant.count }.by(1)
    end

    it "should not allow the registrant to be created with max length +1 Last Name" do
      expect {
        registrant = Factory.build(:registrant, :Address => ("a" * 51))
        registrant.save!()
      }.to raise_exception()
    end

    ###############################
    ## PhoneNumber Validations
    ###############################
    it "should allow the registrant to be created with max length Phone" do
      expect {
        registrant = Factory.build(:registrant, :PhoneNumber => ("a" * 20))
        registrant.save!()
      }.to change { Registrant.count }.by(1)
    end

    it "should not allow the registrant to be created with max length +1 Phone" do
      expect {
        registrant = Factory.build(:registrant, :PhoneNumber => ("a" * 21))
        registrant.save!()
      }.to raise_exception()
    end

    ###############################
    ## EventLocation Validations
    ###############################
    it "should allow the registrant to be created with max length LastName" do
      expect {
        registrant = Factory.build(:registrant, :EventLocation => ("a" * 150))
        registrant.save!()
      }.to change { Registrant.count }.by(1)
    end

    it "should not allow the registrant to be created with max length +1 Last Name" do
      expect {
        registrant = Factory.build(:registrant, :EventLocation => ("a" * 151))
        registrant.save!()
      }.to raise_exception()
    end

    ###############################
    ## Description Validations
    ###############################
    it "should allow the registrant to be created with max length LastName" do
      expect {
        registrant = Factory.build(:registrant, :Description => ("a" * 600))
        registrant.save!()
      }.to change { Registrant.count }.by(1)
    end

    it "should not allow the registrant to be created with max length +1 Last Name" do
      expect {
        registrant = Factory.build(:registrant, :Description => ("a" * 601))
        registrant.save!()
      }.to raise_exception()
    end

  end

  ###############################
  ## display_name
  ###############################

  describe "display_name" do

    it "should not truncate name for user with short name" do
      registrant = Factory.create(:registrant, :FirstName => "1234", :LastName => "1234567890")
      registrant.display_name.should == "1234 1234567890"
    end

    it "should only use first name for user with a long name" do
      registrant = Factory.create(:registrant, :FirstName => "1234", :LastName => "12345678901")
      registrant.display_name.should == "1234"
    end

    it "should truncate the first name if it is to long" do
      registrant = Factory.create(:registrant, :FirstName => "12345678901234567890", :LastName => "12345678901")
      registrant.display_name.should == "1234567890123..."
    end
  end

  describe "Authentication" do
    ###############################
    ## Authentication Basic
    ###############################
    it "should allow a user to log in with correct credentials" do
      registrant = Factory.build(:registrant,
                                 :Email => "foo@bar.com",
                                 :new_password => "Swordfish")
      registrant.save!()
      Registrant.sign_in("foo@bar.com", "Swordfish").should be_instance_of(Registrant)
    end

    it "should allow a user to log in with correct credentials (w. whitespace)" do
      registrant = Factory.build(:registrant,
                                 :Email => "foo@bar.com",
                                 :new_password => "Swordfish")
      registrant.save!()
      Registrant.sign_in("foo@bar.com", " Swordfish ").should be_instance_of(Registrant)
    end

    it "should not allow a user to log in with incorrect credentials" do
      registrant = Factory.build(:registrant,
                                 :Email => "foo@bar.com",
                                 :new_password => "Swordfish")
      registrant.save!()
      lambda {Registrant.sign_in("foo@bar.com", "Not Swordfish")}.should raise_exception
    end

    it "should allow a user to log in who is not Activated" do
      registrant = Factory.build(:registrant,
                                 :Email => "foo@bar.com",
                                 :new_password => "Swordfish",
                                 :IsActivated => false)
      registrant.save!()
      Registrant.sign_in("foo@bar.com", "Swordfish").should be_instance_of(Registrant)
    end

    it "should not allow a user to log in who is deleted credentials" do
      registrant = Factory.build(:registrant,
                                 :Email => "foo@bar.com",
                                 :new_password => "Swordfish",
                                 :IsDeleted => true)
      registrant.save!()
      lambda { Registrant.sign_in("foo@bar.com", "Swordfish")}.should raise_exception
    end

    it "should not allow a user to log in who entered incorrect email" do
      registrant = Factory.build(:registrant,
                                 :Email => "foo@bar.com",
                                 :new_password => "Swordfish")
      registrant.save!()
      lambda { Registrant.sign_in("NOT@AN.EMAIL", "Swordfish")}.should raise_exception

    end

    it "should not allow a facebook user to log-in the wrong way." do
      registrant = Factory.build(:registrant,
                                 :Email => "foo@bar.com",
                                 :fbuid => 1232)
      registrant.save!()
      lambda { Registrant.sign_in("foo@bar.com", "Swordfish")}.should raise_exception
    end

    it "should increment Login count by 1" do
      registrant = Factory.create(:registrant,
                                 :Email => "foo@bar.com",
                                 :new_password => "Swordfish")
      expect{
        Registrant.sign_in("foo@bar.com", "Swordfish")
      }.to change{registrant.reload.Logins}.by(1)
    end

    ###############################
    ## Authentication Remember Me
    ###############################

    it "should allow a user with 'remember me' set to sign-in." do
      registrant = Factory.build(:registrant)
      registrant.save!()
      Registrant.sign_in_remember_me(registrant.id, registrant.secret_code).should be_instance_of(Registrant)
    end

    it "should not allow a user with 'remember me' set but bad code to sign-in." do
      registrant = Factory.create(:registrant)
      Registrant.sign_in_remember_me(registrant.id, "FAKE CODE").should be_nil
    end

    it "should not allow a user with 'remember me' set who has been deleted to sign-in." do
      registrant = Factory.create(:registrant, :IsDeleted => true)
      Registrant.sign_in_remember_me(registrant.id, registrant.secret_code).should be_nil
    end

    it "should increment Login count by 1" do
      registrant = Factory.create(:registrant)
      expect{
        Registrant.sign_in_remember_me(registrant.id, registrant.secret_code)
      }.to change{registrant.reload.Logins}.by(1)
    end

    ###############################
    ## Authentication Facebook
    ###############################

    it "should allow a facebook user to log-in." do
      registrant = Factory.create(:registrant,
                                 :fbuid => 1232)
      Registrant.sign_in_fb(registrant.fbuid).should be_instance_of(Registrant)
    end

    it "should not allow a facebook user to log-in who is deleted." do
      registrant = Factory.create(:registrant,
                                 :IsDeleted => true,
                                 :fbuid => 1232)
      lambda { Registrant.sign_in_fb(registrant.fbuid)}.should raise_exception
    end

    it "should not allow a nil user to log-in" do
      lambda { Registrant.sign_in_fb(nil)}.should raise_exception
    end

    it "should increment Login count by 1" do
      registrant = Factory.create(:registrant,
                                 :fbuid => 1232)
      expect{
        Registrant.sign_in_fb(registrant.fbuid)
      }.to change{registrant.reload.Logins}.by(1)
    end

    ###############################
    ## Activation
    ###############################

    it "should activate a user who is not activated." do
      registrant = Factory.build(:registrant,
                                 :IsActivated => false,
                                  :ImageGUID => "MY GUID")
      registrant.save!()
      Registrant.activate(registrant.ImageGUID).should be_instance_of(Registrant)
    end

    it "should not activate a user who is already activated." do
      registrant = Factory.build(:registrant,
                                 :IsActivated => true)
      registrant.save!()
      Registrant.activate(registrant.ImageGUID).should be_nil
    end

    it "should not activate a user who is not deleted." do
      registrant = Factory.build(:registrant,
                                 :IsDeleted => true)
      registrant.save!()
      Registrant.activate(registrant.ImageGUID).should be_nil
    end

  end

  describe "Change Password" do
    ###############################
    ## Change Password
    ###############################

    it "should change the password if everything is right " do
      registrant = Factory.build(:registrant,
                                 :new_password => "Swordfish")
      registrant.save!()
      registrant.change_password = "1"
      registrant.old_password = "Swordfish"
      registrant.new_password = "DFDFGDSGDFSGFG"
      registrant.save().should be_true
      Registrant.sign_in(registrant.Email, "DFDFGDSGDFSGFG").should be_instance_of(Registrant)
    end

    it "should not change the password if the change_password flag is not set)" do
      registrant = Factory.build(:registrant,
                                 :new_password => "Swordfish")
      registrant.save!()
      registrant.change_password = "0"
      registrant.old_password = "Swordfish"
      registrant.new_password = "DFDFGDSGDFSGFG"
      registrant.save().should be_true
      Registrant.sign_in(registrant.Email, "Swordfish").should be_instance_of(Registrant)
        end

    it "should ignore password change info on update if change_password is not set" do
      registrant = Factory.build(:registrant,
                                 :new_password => "Swordfish")
      registrant.save!()
      registrant.change_password = "0"
      registrant.old_password = "WRONG"
      registrant.new_password = "SHRT"
      registrant.save().should.should be_true
      Registrant.sign_in(registrant.Email, "Swordfish").should be_instance_of(Registrant)
    end

    it "should not allow password change if old password is not set" do
      registrant = Factory.build(:registrant,
                                 :new_password => "Swordfish")
      registrant.save!()
      registrant.change_password = "1"
      registrant.old_password = nil
      registrant.new_password = "DFDFGDSGDFSGFG"
      registrant.save().should be_false
    end

    it "should not allow password change if old password is wrong)" do
      registrant = Factory.build(:registrant,
                                 :new_password => "Swordfish")
      registrant.save!()
      registrant.change_password = "1"
      registrant.old_password = "Wrong"
      registrant.new_password = "DFDFGDSGDFSGFG"
      registrant.save().should be_false
    end

    it "should not accept short password on create" do
      registrant = Factory.build(:registrant,
                                 :new_password => "123")
      registrant.save().should == false
    end

    it "should not accept short password on change password" do
      registrant = Factory.build(:registrant,
                                 :new_password => "Swordfish")
      registrant.save!()
      registrant.change_password = "1"
      registrant.old_password = "Swordfish"
      registrant.new_password = "111"
      registrant.save().should be_false
    end

    it "should not change a Facebook's users password" do
      registrant = Factory.build(:registrant,
                                 :fbuid => "21322")
      registrant.save!()
      registrant.change_password = "1"
      registrant.old_password = "Swordfish"
      registrant.new_password = "DFDFGDSGDFSGFG"
      registrant.save().should be_false
    end

    it "sign-in should no longer accept old password - old specified" do
      registrant = Factory.build(:registrant,
                                 :new_password => "Swordfish")
      registrant.save!()
      registrant.change_password = "1"
      registrant.old_password = "Swordfish"
      registrant.new_password = "DFDFGDSGDFSGFG"
      registrant.save!()
      lambda {Registrant.sign_in(registrant.Email, "Swordfish")}.should raise_exception
    end

    describe "Reset Password" do
      ###############################
      ## Reset Password
      ###############################

      it "should changed the password to a new value" do
        registrant = Factory.build(:registrant,
                                   :new_password => "Swordfish")
        registrant.save!()
        new_pwd = registrant.reset_password
        Registrant.sign_in(registrant.Email, new_pwd).should be_instance_of(Registrant)
      end
    end


    ###############################
    ## fb_exists
    ###############################

    it "should return registrant if matching facebook user exists." do
      registrant = Factory.build(:registrant,
                                 :fbuid => ("54654564654654564"))
      registrant.save!()
      Registrant.fb_exists("54654564654654564").should == registrant
    end

    it "should return false if matching facebook user does not exists." do
      registrant = Factory.build(:registrant,
                                 :fbuid => ("54654564654654564"))
      registrant.save!()
      Registrant.fb_exists("455435435435435").should be_false
    end

  end


  describe "Manage Registry" do

    it "Should count purchased gifts" do
      registrant = Factory.create(:registrant)
      product1 = Factory.create(:product)
      product2 = Factory.create(:product)
      product3 = Factory.create(:product)
      product4 = Factory.create(:product)
      product5 = Factory.create(:product)
      product6 = Factory.create(:product)
      Factory.create(:registry_item, :registrant => registrant, :product => product1, :Purchased_ID => 1)
      Factory.create(:registry_item, :registrant => registrant, :product => product2, :Purchased_ID => 1)
      Factory.create(:registry_item, :registrant => registrant, :product => product3, :Purchased_ID => 2)
      Factory.create(:registry_item, :registrant => registrant, :product => product4, :Purchased_ID => 2)
      Factory.create(:registry_item, :registrant => registrant, :product => product5, :Purchased_ID => 3)
      Factory.create(:registry_item, :registrant => registrant, :product => product6, :Purchased_ID => 3)

      registrant.gifts_count(RegistryItem::PURCHASED).should == 2
    end

    it "Should count ordered gifts" do
      registrant = Factory.create(:registrant)
      product1 = Factory.create(:product)
      product2 = Factory.create(:product)
      product3 = Factory.create(:product)
      product4 = Factory.create(:product)
      product5 = Factory.create(:product)
      product6 = Factory.create(:product)
      Factory.create(:registry_item, :registrant => registrant, :product => product1, :Purchased_ID => 1)
      Factory.create(:registry_item, :registrant => registrant, :product => product2, :Purchased_ID => 1)
      Factory.create(:registry_item, :registrant => registrant, :product => product3, :Purchased_ID => 2)
      Factory.create(:registry_item, :registrant => registrant, :product => product4, :Purchased_ID => 2)
      Factory.create(:registry_item, :registrant => registrant, :product => product5, :Purchased_ID => 3)
      Factory.create(:registry_item, :registrant => registrant, :product => product6, :Purchased_ID => 3)

      registrant.gifts_count(RegistryItem::ORDERED).should == 2
    end

    it "Should count un_purchased gifts" do
      registrant = Factory.create(:registrant)
      product1 = Factory.create(:product)
      product2 = Factory.create(:product)
      product3 = Factory.create(:product)
      product4 = Factory.create(:product)
      product5 = Factory.create(:product)
      product6 = Factory.create(:product)
      Factory.create(:registry_item, :registrant => registrant, :product => product1, :Purchased_ID => 1)
      Factory.create(:registry_item, :registrant => registrant, :product => product2, :Purchased_ID => 1)
      Factory.create(:registry_item, :registrant => registrant, :product => product3, :Purchased_ID => 2)
      Factory.create(:registry_item, :registrant => registrant, :product => product4, :Purchased_ID => 2)
      Factory.create(:registry_item, :registrant => registrant, :product => product5, :Purchased_ID => 3)
      Factory.create(:registry_item, :registrant => registrant, :product => product6, :Purchased_ID => 3)

      registrant.gifts_count(RegistryItem::AVAILABLE).should == 2
    end

    it "Should count all gifts" do
      registrant = Factory.create(:registrant)
      product1 = Factory.create(:product)
      product2 = Factory.create(:product)
      product3 = Factory.create(:product)
      product4 = Factory.create(:product)
      product5 = Factory.create(:product)
      product6 = Factory.create(:product)
      Factory.create(:registry_item, :registrant => registrant, :product => product1, :Purchased_ID => 1)
      Factory.create(:registry_item, :registrant => registrant, :product => product2, :Purchased_ID => 1)
      Factory.create(:registry_item, :registrant => registrant, :product => product3, :Purchased_ID => 2)
      Factory.create(:registry_item, :registrant => registrant, :product => product4, :Purchased_ID => 2)
      Factory.create(:registry_item, :registrant => registrant, :product => product5, :Purchased_ID => 3)
      Factory.create(:registry_item, :registrant => registrant, :product => product6, :Purchased_ID => 3)

      registrant.gifts_count().should == 6
    end

    it "Should return purchased items" do
      registrant = Factory.create(:registrant)
      product1 = Factory.create(:product)
      product2 = Factory.create(:product)
      product3 = Factory.create(:product)
      product4 = Factory.create(:product)
      product5 = Factory.create(:product)
      product6 = Factory.create(:product)
      registry_item1 = Factory.create(:registry_item, :registrant => registrant, :product => product1, :Purchased_ID => 1, :Price => 1)
      registry_item2 = Factory.create(:registry_item, :registrant => registrant, :product => product2, :Purchased_ID => 1, :Price => 2)
      registry_item3 = Factory.create(:registry_item, :registrant => registrant, :product => product3, :Purchased_ID => 2, :Price => 3)
      registry_item4 = Factory.create(:registry_item, :registrant => registrant, :product => product4, :Purchased_ID => 2, :Price => 4)
      registry_item5 = Factory.create(:registry_item, :registrant => registrant, :product => product5, :Purchased_ID => 3, :Price => 5)
      registry_item6 = Factory.create(:registry_item, :registrant => registrant, :product => product6, :Purchased_ID => 3, :Price => 6)

      (registrant.gifts(RegistryItem::PURCHASED) - [registry_item1, registry_item2]).should == []
    end

    it "Should return ordered items" do
      registrant = Factory.create(:registrant)
      product1 = Factory.create(:product)
      product2 = Factory.create(:product)
      product3 = Factory.create(:product)
      product4 = Factory.create(:product)
      product5 = Factory.create(:product)
      product6 = Factory.create(:product)
      registry_item1 = Factory.create(:registry_item, :registrant => registrant, :product => product1, :Purchased_ID => 1, :Price => 1)
      registry_item2 = Factory.create(:registry_item, :registrant => registrant, :product => product2, :Purchased_ID => 1, :Price => 2)
      registry_item3 = Factory.create(:registry_item, :registrant => registrant, :product => product3, :Purchased_ID => 2, :Price => 3)
      registry_item4 = Factory.create(:registry_item, :registrant => registrant, :product => product4, :Purchased_ID => 2, :Price => 4)
      registry_item5 = Factory.create(:registry_item, :registrant => registrant, :product => product5, :Purchased_ID => 3, :Price => 5)
      registry_item6 = Factory.create(:registry_item, :registrant => registrant, :product => product6, :Purchased_ID => 3, :Price => 6)

      registrant.gifts(RegistryItem::ORDERED).should == [registry_item5, registry_item6]
    end

    it "Should return un-purchased items" do
      registrant = Factory.create(:registrant)
      product1 = Factory.create(:product)
      product2 = Factory.create(:product)
      product3 = Factory.create(:product)
      product4 = Factory.create(:product)
      product5 = Factory.create(:product)
      product6 = Factory.create(:product)
      registry_item1 = Factory.create(:registry_item, :registrant => registrant, :product => product1, :Purchased_ID => 1, :Price => 1)
      registry_item2 = Factory.create(:registry_item, :registrant => registrant, :product => product2, :Purchased_ID => 1, :Price => 2)
      registry_item3 = Factory.create(:registry_item, :registrant => registrant, :product => product3, :Purchased_ID => 2, :Price => 3)
      registry_item4 = Factory.create(:registry_item, :registrant => registrant, :product => product4, :Purchased_ID => 2, :Price => 4)
      registry_item5 = Factory.create(:registry_item, :registrant => registrant, :product => product5, :Purchased_ID => 3, :Price => 5)
      registry_item6 = Factory.create(:registry_item, :registrant => registrant, :product => product6, :Purchased_ID => 3, :Price => 6)

      registrant.gifts(RegistryItem::AVAILABLE).should == [registry_item3, registry_item4]
    end

    it "Should return all gifts" do
      registrant = Factory.create(:registrant)
      registry_item1 = Factory.create(:registry_item, :registrant => registrant)
      registry_item2 = Factory.create(:registry_item, :registrant => registrant)
      registry_item3 = Factory.create(:registry_item, :registrant => registrant)
      registry_item4 = Factory.create(:registry_item, :registrant => registrant)
      registry_item5 = Factory.create(:registry_item, :registrant => registrant)
      registry_item6 = Factory.create(:registry_item, :registrant => registrant)
      (registrant.gifts() - [registry_item1, registry_item2, registry_item3, registry_item4, registry_item5, registry_item6]).should == []
    end

    it "Should order by price descending" do
      registrant = Factory.create(:registrant)
      product1 = Factory.create(:product)
      product2 = Factory.create(:product)
      product3 = Factory.create(:product)
      product4 = Factory.create(:product)
      product5 = Factory.create(:product)
      product6 = Factory.create(:product)
      registry_item1 = Factory.create(:registry_item, :registrant => registrant, :product => product1, :Purchased_ID => 1, :Price => 2)
      registry_item2 = Factory.create(:registry_item, :registrant => registrant, :product => product2, :Purchased_ID => 1, :Price => 1)
      registry_item3 = Factory.create(:registry_item, :registrant => registrant, :product => product3, :Purchased_ID => 2, :Price => 3)
      registry_item4 = Factory.create(:registry_item, :registrant => registrant, :product => product4, :Purchased_ID => 2, :Price => 5)
      registry_item5 = Factory.create(:registry_item, :registrant => registrant, :product => product5, :Purchased_ID => 3, :Price => 4)
      registry_item6 = Factory.create(:registry_item, :registrant => registrant, :product => product6, :Purchased_ID => 3, :Price => 6)

      registrant.gifts(nil, 1, 99999, 2).should == [registry_item6, registry_item4, registry_item5, registry_item3, registry_item1, registry_item2]
    end

    it "Should order by price ascending" do
      registrant = Factory.create(:registrant)
      product1 = Factory.create(:product)
      product2 = Factory.create(:product)
      product3 = Factory.create(:product)
      product4 = Factory.create(:product)
      product5 = Factory.create(:product)
      product6 = Factory.create(:product)
      registry_item1 = Factory.create(:registry_item, :registrant => registrant, :product => product1, :Purchased_ID => 1, :Price => 2)
      registry_item2 = Factory.create(:registry_item, :registrant => registrant, :product => product2, :Purchased_ID => 1, :Price => 1)
      registry_item3 = Factory.create(:registry_item, :registrant => registrant, :product => product3, :Purchased_ID => 2, :Price => 3)
      registry_item4 = Factory.create(:registry_item, :registrant => registrant, :product => product4, :Purchased_ID => 2, :Price => 5)
      registry_item5 = Factory.create(:registry_item, :registrant => registrant, :product => product5, :Purchased_ID => 3, :Price => 4)
      registry_item6 = Factory.create(:registry_item, :registrant => registrant, :product => product6, :Purchased_ID => 3, :Price => 6)

      registrant.gifts(nil, 1, 99999, 1).should == [registry_item2, registry_item1, registry_item3, registry_item5, registry_item4, registry_item6]
    end

    it "Pagination Should Work" do
      registrant = Factory.create(:registrant)
      products = 6.times.map { Factory.create(:product) }
      registry_items = 6.times.map do |i|
        Factory.create(:registry_item, :registrant => registrant, :product => products[i], :Purchased_ID => RegistryItem::AVAILABLE, :Price => i + 1).tap do |item|
          item.update_attribute(:updated_at, i.hours.ago)
        end
      end

      registrant.gifts(RegistryItem::AVAILABLE, 1, 2).should =~ registry_items.slice(0, 2)
      registrant.gifts(RegistryItem::AVAILABLE, 2, 2).should =~ registry_items.slice(2, 2)
      registrant.gifts(RegistryItem::AVAILABLE, 3, 2).should =~ registry_items.slice(4, 2)


    end
  end

  describe "Search" do
    before(:each) do
      @registrant1 = Factory.create(:registrant,
                                    :FirstName => "alex",
                                    :LastName => "smith",
                                    :FirstNameCoCreated => "sue",
                                    :LastNameCoCreated => "bing")
      @registrant2 = Factory.create(:registrant,
                                    :FirstName => "fred",
                                    :LastName => "mack",
                                    :FirstNameCoCreated => "liz",
                                    :LastNameCoCreated => "lat")

    end

    it "should find complete names" do
      Registrant.search("alex", nil, nil).should == [@registrant1]
      Registrant.search("smith", nil, nil).should == [@registrant1]
      Registrant.search("sue", nil, nil).should == [@registrant1]
      Registrant.search("bing", nil, nil).should == [@registrant1]

      Registrant.search("fred", nil, nil).should == [@registrant2]
      Registrant.search("mack", nil, nil).should == [@registrant2]
      Registrant.search("liz", nil, nil).should == [@registrant2]
      Registrant.search("lat", nil, nil).should == [@registrant2]

      Registrant.search("alex fred", nil, nil).should == [@registrant1, @registrant2]
      Registrant.search("bing liz", nil, nil).should == [@registrant1, @registrant2]
      Registrant.search("smith lat", nil, nil).should == [@registrant1, @registrant2]
      Registrant.search("sue mack", nil, nil).should == [@registrant1, @registrant2]
    end

    it "should find partial names start" do
      Registrant.search("al fr", nil, nil).should == [@registrant1, @registrant2]
      Registrant.search("bi li", nil, nil).should == [@registrant1, @registrant2]
      Registrant.search("sm la", nil, nil).should == [@registrant1, @registrant2]
      Registrant.search("su ma", nil, nil).should == [@registrant1, @registrant2]
    end

    it "should find partial names middle" do
      Registrant.search("le re", nil, nil).should == [@registrant1, @registrant2]
      Registrant.search("in i", nil, nil).should == [@registrant1, @registrant2]
      Registrant.search("it a", nil, nil).should == [@registrant1, @registrant2]
      Registrant.search("u ac", nil, nil).should == [@registrant1, @registrant2]
    end

    it "find should be case insensitive" do
      Registrant.search("Alex Fred", nil, nil).should == [@registrant1, @registrant2]
      Registrant.search("Bing Liz", nil, nil).should == [@registrant1, @registrant2]
      Registrant.search("Smith Lat", nil, nil).should == [@registrant1, @registrant2]
      Registrant.search("Sue Mack", nil, nil).should == [@registrant1, @registrant2]
    end

    it "find should sometimes return nothing" do
      Registrant.search("sadsadsa sdsad", nil, nil).should == []
    end

    it "find should support pagination " do
      registrant3 = Factory.create(:registrant,
                                   :FirstName => "fred",
                                   :LastName => "mack",
                                   :FirstNameCoCreated => "liz",
                                   :LastNameCoCreated => "lat")
      registrant4 = Factory.create(:registrant,
                                   :FirstName => "fred",
                                   :LastName => "mack",
                                   :FirstNameCoCreated => "liz",
                                   :LastNameCoCreated => "lat")

      Registrant.search("Alex Fred", 1, 2).should == [@registrant1, @registrant2]
      Registrant.search("Bing Liz", 1, 2).should == [@registrant1, @registrant2]
      Registrant.search("Smith Lat", 1, 2).should == [@registrant1, @registrant2]
      Registrant.search("Sue Mack", 1, 2).should == [@registrant1, @registrant2]

      Registrant.search("Alex Fred", 2, 2).should == [registrant3, registrant4]
      Registrant.search("Bing Liz", 2, 2).should == [registrant3, registrant4]
      Registrant.search("Smith Lat", 2, 2).should == [registrant3, registrant4]
      Registrant.search("Sue Mack", 2, 2).should == [registrant3, registrant4]
    end


    it "should count number of search results" do
      Registrant.count_all_give("alex").should == 1
      Registrant.count_all_give("smith").should == 1
      Registrant.count_all_give("sue").should == 1
      Registrant.count_all_give("bing").should == 1

      Registrant.count_all_give("fred").should == 1
      Registrant.count_all_give("mack").should == 1
      Registrant.count_all_give("liz").should == 1
      Registrant.count_all_give("lat").should == 1

      Registrant.count_all_give("alex fred").should == 2
      Registrant.count_all_give("bing liz").should == 2
      Registrant.count_all_give("smith lat").should == 2
      Registrant.count_all_give("sue mack").should == 2
    end
  end

###############################
## email_exists
###############################

  describe "email_exists" do
    it "should return registrant if matching email exists." do
      registrant = Factory.build(:registrant,
                                 :Email => ("foo@bar.com"))
      registrant.save!()
      Registrant.email_exists("foo@bar.com").should == registrant
    end

    it "should return false if matching email does not exists." do
      registrant = Factory.build(:registrant,
                                 :Email => ("foo@bar.com"))
      registrant.save!()
      Registrant.email_exists("fake@bar.com").should be_false
    end

    it "should return false if matching email is nil." do
      registrant = Factory.build(:registrant,
                                 :Email => ("foo@bar.com"))
      registrant.save!()
      Registrant.email_exists(nil).should be_false
    end

  end

  ###############################
  ## get_queue
  ###############################

  describe "get_queue" do

    before(:each) do
      @registrant = Factory.create(:registrant)
      category = Factory.create(:category)
      product1 = Factory.create(:product)
      product2 = Factory.create(:product)
      product3 = Factory.create(:product)
      product4 = Factory.create(:product)
      product5 = Factory.create(:product)
      product6 = Factory.create(:product, :Registrant_ID => @registrant.id)
      product7 = Factory.create(:product, :Registrant_ID => @registrant.id)
      @r2p_purchased_0 = Factory.create(:registry_item, :registrant => @registrant, :product => product1, :Purchased_ID => RegistryItem::PURCHASED)
      @r2p_available = Factory.create(:registry_item, :registrant => @registrant, :product => product2, :Purchased_ID => RegistryItem::AVAILABLE)
      @r2p_order = Factory.create(:registry_item, :registrant => @registrant, :product => product3, :Purchased_ID => RegistryItem::ORDERED)
      @r2p_purchased_1 = Factory.create(:registry_item, :registrant => @registrant, :product => product4, :Purchased_ID => RegistryItem::PURCHASED)
      @r2p_purchased_2 = Factory.create(:registry_item, :registrant => @registrant, :product => product5, :Purchased_ID => RegistryItem::PURCHASED)
      @r2p_cash_1 = Factory.create(:registry_item, :registrant => @registrant, :product => product6, :Purchased_ID => RegistryItem::AVAILABLE)
      @r2p_cash_2 = Factory.create(:registry_item, :registrant => @registrant, :product => product7, :Purchased_ID => RegistryItem::AVAILABLE)
    end

    it "should include cash in the credits" do
      @registrant.Cash = 35
      @registrant.get_queue.should == 35
    end

    it "should sum all contributions to purchased products" do
      @r2p_purchased_0.update_attributes(:Contributed => 1)
      @r2p_purchased_1.update_attributes(:Contributed => 10)
      @r2p_purchased_2.update_attributes(:Contributed => 100)
      @registrant.get_queue.should == 111
    end

    it "should include contributions on available products" do
      @r2p_purchased_0.update_attributes(:Contributed => 1)
      @r2p_available.update_attributes(:Contributed => 10)
      @r2p_purchased_1.update_attributes(:Contributed => 100)
      @r2p_purchased_2.update_attributes(:Contributed => 1000)
      @registrant.get_queue.should == 1111
    end

    it "should not include contributions on ordered products " do
      @r2p_purchased_0.update_attributes(:Contributed => 1)
      @r2p_available.update_attributes(:Contributed => 10)
      @r2p_order.update_attributes(:Contributed => 100)
      @r2p_purchased_1.update_attributes(:Contributed => 1000)
      @r2p_purchased_2.update_attributes(:Contributed => 10000)
      @registrant.get_queue.should == 11011
    end

    it "should include both registrant cash and exchanged products" do
      @registrant.Cash = 35
      @r2p_purchased_1.update_attributes(:Contributed => 1000)
      @r2p_purchased_2.update_attributes(:Contributed => 10000)

      @registrant.get_queue.should == 11035
    end

    it "should handle negative cash" do
      @registrant.Cash = -35
      @r2p_purchased_1.update_attributes(:Contributed => 1000)
      @r2p_purchased_2.update_attributes(:Contributed => 10000)

      @registrant.get_queue.should == 10965
    end
  end

  ###############################
  ## get_queue
  ###############################

  describe "get_queue_for_payment" do

    before(:each) do
      @registrant = Factory.create(:registrant)
      category = Factory.create(:category)
      product1 = Factory.create(:product)
      product2 = Factory.create(:product, :IsKind => true)
      product3 = Factory.create(:product)
      product4 = Factory.create(:product, :IsKind => true)
      product5 = Factory.create(:product)
      product6 = Factory.create(:product, :IsKind => true)
      @r2p_purchased_1 = Factory.create(:registry_item, :registrant => @registrant, :product => product1, :Purchased_ID => RegistryItem::PURCHASED)
      @r2p_purchased_u = Factory.create(:registry_item, :registrant => @registrant, :product => product2, :Purchased_ID => RegistryItem::PURCHASED)
      @r2p_available_1 = Factory.create(:registry_item, :registrant => @registrant, :product => product3, :Purchased_ID => RegistryItem::AVAILABLE)
      @r2p_available_u = Factory.create(:registry_item, :registrant => @registrant, :product => product4, :Purchased_ID => RegistryItem::AVAILABLE)
      @r2p_order_1 = Factory.create(:registry_item, :registrant => @registrant, :product => product5, :Purchased_ID => RegistryItem::ORDERED)
      @r2p_order_u = Factory.create(:registry_item, :registrant => @registrant, :product => product6, :Purchased_ID => RegistryItem::ORDERED)
      @cart = Cart.new
    end

    it "should include cash in the credits" do
      @registrant.Cash = 35
      @registrant.get_queue_for_payment(@cart).should == 35
    end

    it "should sum all contributions to purchased products that are not unique" do
      @r2p_purchased_1.update_attributes(:Contributed => 1)
      @r2p_purchased_u.update_attributes(:Contributed => 10)
      @registrant.get_queue_for_payment(@cart).should == 1
    end

    it "should include contributions on available products that are not unique" do
      @r2p_available_1.update_attributes(:Contributed => 1)
      @r2p_available_u.update_attributes(:Contributed => 10)
      @r2p_purchased_1.update_attributes(:Contributed => 100)
      @r2p_purchased_u.update_attributes(:Contributed => 1000)
      @registrant.get_queue_for_payment(@cart).should == 101
    end

    it "should include contributions if unique items are in the cart" do
      @cart.registry_items << @r2p_available_u << @r2p_purchased_u
      @r2p_available_1.update_attributes(:Contributed => 1)
      @r2p_available_u.update_attributes(:Contributed => 10)
      @r2p_purchased_1.update_attributes(:Contributed => 100)
      @r2p_purchased_u.update_attributes(:Contributed => 1000)
      @registrant.get_queue_for_payment(@cart).should == 1111
    end

    it "should not include contributions on ordered products" do
      @r2p_purchased_1.update_attributes(:Contributed => 1)
      @r2p_purchased_u.update_attributes(:Contributed => 10)
      @r2p_available_1.update_attributes(:Contributed => 100)
      @r2p_available_u.update_attributes(:Contributed => 1000)
      @r2p_order_1.update_attributes(:Contributed     => 10000)
      @r2p_order_u.update_attributes(:Contributed     => 100000)
      @registrant.get_queue_for_payment(@cart).should == 101
    end

    it "should include both registrant cash and exchanged products" do
      @registrant.Cash = 35
      @r2p_purchased_1.update_attributes(:Contributed => 1000)
      @registrant.get_queue_for_payment(@cart).should == 1035
    end

    it "should handle negative cash" do
      @registrant.Cash = -35
      @r2p_purchased_1.update_attributes(:Contributed => 1000)

      @registrant.get_queue_for_payment(@cart).should == 965
    end
  end


  ###############################
  ## get_list_products_for_withdrawals
  ###############################

  describe "get_list_products_for_withdrawals" do

    before(:each) do
      @registrant = Factory.create(:registrant)
      product1 = Factory.create(:product)
      product2 = Factory.create(:product, :IsKind => true)
      product3 = Factory.create(:product)
      product4 = Factory.create(:product, :IsKind => true)
      product5 = Factory.create(:product)
      product6 = Factory.create(:product, :IsKind => true)
      @r2p_purchased_1 = Factory.create(:registry_item, :registrant => @registrant, :product => product1, :Purchased_ID => RegistryItem::PURCHASED)
      @r2p_purchased_u = Factory.create(:registry_item, :registrant => @registrant, :product => product2, :Purchased_ID => RegistryItem::PURCHASED)
      @r2p_available_1 = Factory.create(:registry_item, :registrant => @registrant, :product => product3, :Purchased_ID => RegistryItem::AVAILABLE)
      @r2p_available_u = Factory.create(:registry_item, :registrant => @registrant, :product => product4, :Purchased_ID => RegistryItem::AVAILABLE)
      @r2p_order_1 = Factory.create(:registry_item, :registrant => @registrant, :product => product5, :Purchased_ID => RegistryItem::ORDERED)
      @r2p_order_u = Factory.create(:registry_item, :registrant => @registrant, :product => product6, :Purchased_ID => RegistryItem::ORDERED)
      @cart = Cart.new
    end


    it "should return purchased products that are not unique" do
      @r2p_purchased_1.update_attributes(:Contributed => 10)
      @r2p_purchased_u.update_attributes(:Contributed => 10)
      @registrant.get_list_products_for_withdrawals.should == [@r2p_purchased_1]
    end

    it "should return available products that are not unique" do
      @r2p_available_1.update_attributes(:Contributed => 10)
      @r2p_available_u.update_attributes(:Contributed => 10)
      @r2p_purchased_1.update_attributes(:Contributed => 10)
      @r2p_purchased_u.update_attributes(:Contributed => 10)
      @registrant.get_list_products_for_withdrawals.should include(@r2p_purchased_1)
      @registrant.get_list_products_for_withdrawals.should include(@r2p_available_1)
    end

    it "should not return ordered products" do
      @r2p_purchased_1.update_attributes(:Contributed => 10)
      @r2p_purchased_u.update_attributes(:Contributed => 10)
      @r2p_available_1.update_attributes(:Contributed => 10)
      @r2p_available_u.update_attributes(:Contributed => 10)
      @r2p_order_1.update_attributes(:Contributed     => 10)
      @r2p_order_u.update_attributes(:Contributed     => 10)
      @registrant.get_list_products_for_withdrawals.should include(@r2p_purchased_1)
      @registrant.get_list_products_for_withdrawals.should include(@r2p_available_1)
    end

    it "should return ordered products" do
      @r2p_purchased_1.update_attributes(:Contributed => 10)
      @r2p_purchased_u.update_attributes(:Contributed => 40)
      @r2p_available_1.update_attributes(:Contributed => 30)
      @r2p_available_u.update_attributes(:Contributed => 50)
      @registrant.get_list_products_for_withdrawals.should == [@r2p_available_1, @r2p_purchased_1]
    end

  end

  describe "follow fb friends" do
    before(:each) do
      @registrant = Factory.create(:registrant)
      @followed_registrant1 = Factory.create(:registrant, :fbuid => 121212)
      @followed_registrant2 = Factory.create(:registrant, :fbuid => 232323)
    end

    it "should do nothing if nothing has changed" do
      @registrant.followed_registrants = [@followed_registrant1, @followed_registrant2]
      @registrant.save

      friends = [232323, 121212]

      @registrant.follow_fb_friends(friends)
      @registrant.follows.count.should == 2
    end

    it "should add new friends" do

      friends = [232323]
      @registrant.follow_fb_friends(friends)
      @registrant.follows.count.should == 1
    end

    it "should add new friends (2)" do
      @registrant.followed_registrants = [@followed_registrant1]
      @registrant.save

      friends = [232323, 121212]

      @registrant.follow_fb_friends(friends)
      @registrant.follows.count.should == 2
    end

    it "should ignore fbuid's that are not valid" do
      @registrant.followed_registrants = [@followed_registrant1]
      @registrant.save

      friends = [444]

      @registrant.follow_fb_friends(friends)
      @registrant.follows.count.should == 1
    end

    it "should not change anything if no friends are specified" do
      @registrant.followed_registrants = [@followed_registrant1]
      @registrant.save

      friends = []

      @registrant.follow_fb_friends(friends)
      @registrant.follows.count.should == 1
    end
  end

  describe "follows?" do
    before(:each) do
      @registrant = Factory.create(:registrant)
      @followed_registrant1 = Factory.create(:registrant, :fbuid => 121212)
      @followed_registrant2 = Factory.create(:registrant, :fbuid => 232323)
    end

    it "should return true if registrant is already follwoed " do
      @registrant.followed_registrants = [@followed_registrant1]

      @registrant.follows?(@followed_registrant1).should be_true
    end

    it "should return false if following nothing" do
      @registrant.followed_registrants = []

      @registrant.follows?(@followed_registrant1).should be_false
    end

    it "should return false if following only others" do
      @registrant.followed_registrants = [@followed_registrant1]

      @registrant.follows?(@followed_registrant2).should be_false
    end
  end

end
