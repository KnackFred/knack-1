# language: en
Feature: buy
  In order to buy a product from the registry
  As a guest
  I want to add items to the cart to buy them or contribute to them

  @javascript
  Scenario: Buy All Remaining From Registry Page
    Given a registry with "1" "available" product in it
    When I visit the registry page
    And I buy the first registry item
    And I should see the item in my cart

  @javascript
  Scenario: Buy All Remaining From Registry Item
    Given a registry with "1" "available" product in it
    When I visit the registry item page
    And I buy the registry item
    And I should see the item in my cart

  @javascript
  Scenario: Buy Specific Set Quantity From the Registry Page
    Given a registry with a "available" product in it with quantity "5"
    When I visit the registry page
    And I buy "2" of the first registry item
    Then I should see an item in my cart with quantity "2"

  @javascript
  Scenario: Buy A Specific Quantity From the Registry Item
    Given a registry with a "available" product in it with quantity "5"
    When I visit the registry item page
    And I buy "2" of the registry item
    Then I should see an item in my cart with quantity "2"

  @javascript
  Scenario: Contribute From Registry Page
    Given a registry with one product eligible for contributions in it
    When I visit the registry page
    And I contribute "10" to the first registry item
    Then I should see an item in my cart with "10" contributed

  @javascript
  Scenario: Contribute From Registry Item
    Given a registry with one product eligible for contributions in it
    When I visit the registry item page
    And I contribute "10" to the registry item
    Then I should see an item in my cart with "10" contributed

  @javascript
  Scenario: Error if details are not specified for a confirmation.
    Given a registry with one product eligible for contributions in it
    When I visit the registry item page
    And I click contribute
    And I hit ok in the buy-contribute dialog
    Then I should see a validation error in the pop-up

  @javascript
  Scenario: Error if adding an item that is already in the cart.
    Given a registry with "1" "available" product in it
    And I visit the registry page
    And I buy the first registry item
    And I visit the registry page
    And I buy the first registry item
    Then I should see an error indicating that the item is already in the cart

  @javascript
  Scenario: Should not see the buy button if the item is already in the cart.
    Given a registry with "1" "available" product in it
    And I visit the registry page
    And I buy the first registry item
    When I visit the registry page
    And I click on the first registry item
    And I should not see the BUY button

