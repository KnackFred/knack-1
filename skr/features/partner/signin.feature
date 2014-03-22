# language: en
Feature: Partner Sign In.
  @javascript
  Scenario: Partner Sign In - as registered partner
    Given I am a registered partner
    When I sign in as a partner
    Then I should be on the partner profile page
    And I should see "Login information"

  @javascript
  Scenario Outline: Partner Sign In
    When I go to the partner sign-in page
    And I fill in the following:
    | partner_Email    | <email>    |
    | partner_Password | <password> |
    And I press "Login"
    Then I should be on the partner sign-in page
    And I should see "<message>"

  Scenarios: All States and Types
    | email                   | password  | message                            |
    | Partner@mail.com        | Swordfish | There is no such login or password |
    |                         |           | can't be blank                     |