# language: en
Feature: Exchange Item
  In order to do get cash for something I no longer want
  As a Registrant
  I want to exchange items that have been contributed to for cash.

	@javascript
  Scenario: place an available item with contributions into the cart to be exchanged for cash.
    Given I am an authenticated registrant
    And I have "1" "available" "cash" gift in my registry with "12" dollars contributed
    When I go to the manage_registry page
    And I follow "Exchange For Cash"
	And I follow "Yes"
    Then I should be on "Cart"
    And I should see "1" item in my cart

  @javascript
  Scenario: place an available item with contributions into the cart to be exchanged for cash (user selected no).
    Given I am an authenticated registrant
    And I have "1" "available" "cash" gift in my registry with "12" dollars contributed
    When I go to the manage_registry page
    And I follow "Exchange For Cash"
    And I follow "No"
    Then I should see action "Cart"
    When I follow "In Cart"
    Then I should be on "Cart"
    And I should see "1" item in my cart

  Scenario: show an item in the cart for exchange as In Cart" .
    Given I am an authenticated registrant
    And I have "1" "available" "cash" gift in my registry with "12" dollars contributed
    When I go to the manage_registry page
    And I follow "Exchange For Cash"
    And I go to the manage_registry page
    Then I should see action "In Cart"

# Get an error if order items is in the cart.
# Should have javascript that tests dialog with yes option selected.
