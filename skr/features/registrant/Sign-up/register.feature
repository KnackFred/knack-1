# language: en
Feature: Register
  In order to use the site
  As a Potential User
  I want to register with the site

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

  Scenario: Prevent registration if an email address is already in use.
    Given I am a registered user with email "foo@bar.com" and password "Swordfish"
    When I go to the signup page
    And I fill in the following:
    | registrant_FirstName                  | John           |
    | registrant_LastName                   | Smith          |
    | registrant_Email                      | foo@bar.com    |
    | registrant_new_password               | Swordfish      |
    And I select "Arizona" from "registrant_State_ID"
    And I press "Register"
    Then I should be on the signup page
    And I should see "This email is already in use"

  Scenario: Prevent registration if the user does not fill out any fields
    When I go to the signup page
    And I fill in the following:
    | registrant_FirstName                  |                |
    | registrant_LastName                   |                |
    | registrant_Email                      |                |
    | registrant_new_password               |                |
    And I select "Arizona" from "registrant_State_ID"
    And I press "Register"
    Then I should be on the signup page
    And I should see "can't be blank"

  Scenario: Prevent registration if the user does not fill out their state
    When I go to the signup page
    And I fill in the following:
    | registrant_FirstName                  |                |
    | registrant_LastName                   |                |
    | registrant_Email                      |                |
    | registrant_new_password               |                |
    And I press "Register"
    Then I should be on the signup page
    And I should see "State is not selected."

  Scenario: Prevent registration if the passwords are too short
    When I go to the signup page
    And I fill in the following:
      | registrant_FirstName                  | John           |
      | registrant_LastName                   | Smith          |
      | registrant_Email                      | foo@bar.com    |
      | registrant_new_password               | short          |
    And I select "Arizona" from "registrant_State_ID"
    And I press "Register"
    Then I should be on the signup page
    And I should see "is too short"

  Scenario: Prevent registration if the email address is invalid
    When I go to the signup page
    And I fill in the following:
      | registrant_FirstName                  | John           |
      | registrant_LastName                   | Smith          |
      | registrant_Email                      | foo            |
      | registrant_new_password               | short          |
    And I select "Arizona" from "registrant_State_ID"
    And I press "Register"
    Then I should be on the signup page
    And I should see "You must provide a valid email address"


