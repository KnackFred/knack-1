FactoryGirl.define do
  factory :registrant do
    sequence(:Email) { |n| "test_email#{n}@test.com" }
    new_password "HelloWorld"
    FirstName "Unit Test First Name"
    LastName "Unit Test Last Name"
    FirstNameCoCreated "Unit Test Co First Name"
    LastNameCoCreated "Unit Test Co Last Name"
    Address "Unit Test Address"
    City "Anytown"
    State_ID {State.first.id}
    ZIP "98121"
    EventDate "04/05/1980"
    EventLocation "Somewhere fun."
    ImageGUID "74b78b54ed0a1c5fab0af32be8b17150"
    RegistryType_ID {RegistrantType.find_by_Name("Wedding").id}
    IsActivated true
    IsDeleted false
    invite_friends_shown true

    after_build do |registrant, evaluator|
      if evaluator.sections.nil?
        order.sections = [Factory.build(:section)]
      else
        evaluator.sections.each do |prod|
          order.sections << Factory.build(:section)
        end
      end
    end
  end

  factory :state do
    sequence(:Name) { |n| "test_state_#{n}" }
    GeneralTax 7
  end

  factory :registrant_type do
    Name "Wedding"
  end

  factory :section do
     order 1
  end
end
