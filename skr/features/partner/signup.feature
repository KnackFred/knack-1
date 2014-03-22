# language: en
Feature: Partner Sign Up

  Scenario: Register partner - complete the first step
    When I go to the partner sign-up page
    And I fill in the following:
    | partner_BillingName            | John                  |
    | partner_BillingLastName        | Smith                 |
    | partner_Email                  | JohnsPartner@mail.com |
    | partner_Password               | Swordfish             |
    | partner_Password_confirmation  | Swordfish             |
    And I check "partner_AgreeWithSitePolicy"
    And I press "Register"
    Then I should be on the partner confirm page
    And I should see "JohnsPartner@mail.com"


  Scenario: Register partner - using existing email
    Given I am a registered partner with email "foo@bar.com" and password "Swordfish"
    When I go to the partner sign-up page
    And I fill in the following:
    | partner_BillingName            | John        |
    | partner_BillingLastName        | Smith       |
    | partner_Email                  | foo@bar.com |
    | partner_Password               | Swordfish   |
    | partner_Password_confirmation  | Swordfish   |
    And I check "partner_AgreeWithSitePolicy"
    And I press "Register"
    Then I should be on the partner sign-up page
    And I should see "This email is already in use"


  Scenario Outline: Register partner (First step)
    When I go to the partner sign-up page
    And I fill in the following:
    | partner_BillingName            | <name>                |
    | partner_BillingLastName        | <last_name>           |
    | partner_Email                  | <email>               |
    | partner_Password               | <password>            |
    | partner_Password_confirmation  | <confirm_password>    |
    And I <AgreeWithSitePolicy> "partner_AgreeWithSitePolicy"
    And I press "Register"
    Then I should be on the partner sign-up page
    And I should see "<message>"

  Scenarios: All States and Types
    | name   | last_name | email                   | password   | confirm_password | AgreeWithSitePolicy | message                        |
    |        |           |                         |            |                  | check               | can't be blank                 |
    | John   | Smith     | JohnsPartner@mail.com   | Swordfish1 | Swordfish2       | check               | Password Is not the same       |
    | John   | Smith     | JohnsPartner@mail.com   | Swordfish  | Swordfish        | uncheck             | Confirm agree with site police |
    | John   | Smith     | JohnsPartner@mail.com   | 111        | 111              | check               | minimum is 5 characters        |
    | John   | Smith     | JohnsPartner            | Swordfish  | Swordfish        | check               | email must be valid            |
    | John   | Smith     | *()''@mail.com          | Swordfish  | Swordfish        | check               | email must be valid            |
    | John   | Smith     | JohnsPartner@*()'       | Swordfish  | Swordfish        | check               | email must be valid            |
    | John   | Smith     | JohnsPartner@*().'      | Swordfish  | Swordfish        | check               | email must be valid            |
    | John   | Smith     | JohnsPartner@*()'.com   | Swordfish  | Swordfish        | check               | email must be valid            |
    | John   | Smith     | JohnsPartner@mail.*()'  | Swordfish  | Swordfish        | check               | email must be valid            |
