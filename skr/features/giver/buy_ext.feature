# language: en
Feature: buy external
  In order to buy an external product from the registry
  As a guest
  I want to buy an item from an external site.

# NOTE THESE WILL NOT WORK WITH CAPYBARA WEBKIT.
# YOU CAN CHECK knack_en.rb to see if capyabra webkit  is enabled.

#  Basics of the UI
  @javascript
  Scenario: Buy External From Registry Page
    Given a registry with an external gift in it
    When I visit the registry page
    And I click buy
    Then I should see a pop-up explaining the process
    When I click continue
    Then I should see two pop-ups one with instructions and the other with the item

  @javascript
  Scenario: Buy External From Item Page
    Given a registry with an external gift in it
    When I visit the registry item page
    And I click buy
    Then I should see a pop-up explaining the process
    When I click continue
    Then I should see two pop-ups one with instructions and the other with the item

  @javascript
  Scenario: Buy External should show varients
    Given a registry with an external gift in it with varients
    When I initiate the external buying process
    Then I should see a pop-up with the varients in it

  @javascript
  Scenario: Confirm External Purchase
    Given a registry with an external gift in it
    When I initiate the external buying process
    And I confirm my purchase
    Then I should see the external purchase confirmation

  @javascript
  Scenario: Error Confirm External Purchase
    Given a registry with an external gift in it
    When I initiate the external buying process
    And I try to confirm my purchase with invalid data
    Then I should see a validation error in the window

  @javascript
  Scenario: Items purchased externally should no longer be on the registry
    Given a registry with an external gift in it
    When I buy the external item
    And I visit the registry page
    Then I should see "1" "purchased" registry items

  @javascript
  Scenario: Contributions should be shown as external to the registrant
    Given I am an authenticated registrant
    And I have a "purchased" "external" gift in my registry
    When I go to the manage_registry page
    And I open the contributions pop-up for the first gift
    Then I should not see the name and email fields for the contribution

  @javascript
  Scenario: External contributions should not count toward credit.
    Given I am an authenticated registrant
    And I have a "purchased" "external" gift in my registry
    When I go to the manage_registry page
    Then I should have "0" dollars in credit.

  @javascript
  Scenario: View External Purchase in all transactions page
    Given I am an authenticated registrant
    And I have a "purchased" "external" gift in my registry
    When I go to the All Transactions page
    Then I should see a "Purchased Externally" transaction with amount "0"

