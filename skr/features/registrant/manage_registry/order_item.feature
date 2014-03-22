# language: en
Feature: Order Item
  In order to receive a gift from their registry that was not purchased by a guest
  As a Registrant
  I want to order an item off of my registry.

  @javascript
  Scenario: Add purchased item to cart for order
    Given I am an authenticated registrant
    And I have "1" "purchased" "catalogue" gift in my registry
    When I go to the manage_registry page
    And I follow "Order"
    And I follow "Yes"
    Then I should be on "Cart"
    And I should see the item in my cart
    When I go to the manage_registry page
    Then I should see action "In Cart"

  @javascript
  Scenario: Add purchased item to cart for order
    Given I am an authenticated registrant
    And I have "1" "purchased" "catalogue" gift in my registry
    When I go to the manage_registry page
    And I follow "Order"
    And I follow "No"
    Then I should see action "Cart"
    When I follow "In Cart"
    Then I should be on "Cart"
    And I should see the item in my cart

  Scenario: show an item in the cart for order as In Cart" .
    Given I am an authenticated registrant
    And I have "1" "purchased" "catalogue" gift in my registry
    When I go to the manage_registry page
    And I follow "Order"
    And I go to the manage_registry page
    Then I should see action "In Cart"

  @javascript
  Scenario: Order an item
    Given I am an authenticated registrant
    And I have "1" "purchased" "catalogue" gift in my registry
    When I go to the manage_registry page
    And I follow "Order"
    And I follow "Yes"
    Then I should be on "Cart"
    And I should see the item in my cart

  @javascript
  Scenario: order a catalogue item with variant
    Given I am an authenticated registrant
    And I have an "ordered" gift in my registry with a variant named "Stuff" and value "foo" of "bar,foo,bat"
    When I go to the manage_registry page
    And I follow "Order"

