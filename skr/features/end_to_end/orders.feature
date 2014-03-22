# language: en
Feature: Orders.

  @javascript
  Scenario: Complete End To End Order
    Given I am a registered partner with "MY PRODUCT" product
    Given I am an authenticated registrant
    When I go to the catalog page
    And I click the first product
    And I press button "BUY NOW"
    And I wait until all Ajax requests are complete
    And I follow "Yes"
    Then I should be on "Cart"
    And I should see "1" item in my cart
    When I press button "CHECK OUT"
    And I press button "CONTINUE"
    And I fill in the following:
    | credit_card_card_number   | 4000001234567899 |
    | credit_card_verification  | 123              |
    And I press button "CONTINUE"
    And I press button "PROCESS ORDER"
    And I sign out
    When I sign in as a partner
    And I go to the orders page
    Then I should see "Unit Test First Name Unit Test Last Name"

