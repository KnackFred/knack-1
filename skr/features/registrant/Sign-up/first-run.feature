# language: en
Feature: Register
  In order to make my first experience with knack as simple as possible
  As a Potential User
  I want to finalize my profile and be given an overview of the site.


  @javascript
  Scenario: Register with Knack
    When I go to the signup page
    And I fill in the following:
    | registrant_FirstName                  | John           |
    | registrant_LastName                   | Smith          |
    | registrant_Email                      | john@smith.com |
    | registrant_new_password               | Swordfish      |
    And I select "Arizona" from "registrant_State_ID"
    And I press "Register"
    Then I should be on the addgift page
    And I should see "Like us on Facebook now"
    Then I follow "Close"
