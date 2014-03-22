FactoryGirl.define do

  factory :partner_administrator do
    sequence(:email) { |n| "partner_admin#{n}@test.com" }
    new_password "HelloWorld"
    first_name "Partner"
    last_name "Administrator"
    partner
  end

  factory :partner do
    sequence :Email do |n| "test_email#{n}@test.com" end
    sequence :BillingEmail do |n| "test_email#{n}@test.com" end
    Password "HelloWorld"
    Password_confirmation "HelloWorld"
    State_ID 1
    ZIP "36785"
    City "Benton"
    BillingName "Unit Test First Name"
    BillingLastName "Unit Test Last Name"
    AgreeWithSitePolicy 1
    IsActivated true
    IsDeleted false
    Logins 0
    Description "This is something awesome"

    after_build do |partner, evaluator|
      if evaluator.stores.blank?
        partner.stores = [Factory.build(:store, :partner => partner)]
      else
        evaluator.stores.each do |store|
          partner.stores << store
        end
      end
    end
  end

  factory :store do |f|
    State_ID {State.first.id}
    sequence(:Email) { |n| "test_email#{n}@test.com" }
    sequence(:Name) { |n| "TEST STORE #{n}" }
    Street "Test Street"
    City "Test City"
    ZIP "98121"
    IsDefault false
    Phone '45674785'
    visible true

    after_build do |store, evaluator|
      if evaluator.category.nil?
        store.category = Category.root.children[0]
      else
        store.category = evaluator.category
      end

      if evaluator.partner.nil?
        store.partner = Factory.build(:partner, :stores => [store])
      else
        store.partner = evaluator.partner
      end
    end
  end
end