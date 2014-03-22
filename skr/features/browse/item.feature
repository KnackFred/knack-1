# language: en
Feature: View item page
  In order to learn more about a product
  And add that item to my cart or registry
  I want to see product information

#    Show the Correct Buttons and Extra info in the correct circumstances
  Scenario: View product information on catalog item page as a not authenticated user.
    Given I have a product named "MY PRODUCT"
    When I visit the item page for the first product
    Then I should see "MY PRODUCT"
    And I should see "buy" action and no others
    And I should see the how does knack work section
    And I should not see the registry info

  Scenario: View product information on catalog item page as an authenticated user.
    Given I have a product named "MY PRODUCT"
    And I am an authenticated registrant
    When I visit the item page for the first product
    Then I should see "MY PRODUCT"
    And I should see "buy and add" action and no others
    And I should not see the how does knack work section
    And I should not see the registry info

  Scenario: Directly view item page for a cash product
    Given There is a cash product named "MY PRODUCT"
    When I visit the item page for the first product
    Then I should see "MY PRODUCT"
    And I should see "no" action and no others

  Scenario: View registry item page
    Given a registry with "1" "available" product in it
    When I visit the registry item page
    Then I should see "contribute" action and no others
    And I should see the registry info

  Scenario: View registry item page for purchased item
    Given a registry with "1" "purchased" product in it
    When I visit the registry item page
    Then I should see "no" action and no others
    And I should see the registry info

# ACTIONS
  @javascript
  Scenario: Add product to cart to buy
    Given There is a product named "MY PRODUCT"
    When I visit the item page for the first product
    And I press the buy button
    And I follow "Yes"
    Then I should be on "Cart"
    And I should see "1" item in my cart

  @javascript
  Scenario: Add product to cart to buy as registrant
    Given I am an authenticated registrant
    And There is a product named "MY PRODUCT"
    When I visit the item page for the first product
    And I press the buy button
    And I follow "Yes"
    Then I should be on "Cart"
    And I should see "1" item in my cart

  @javascript
  Scenario: Add product to registry as registrant
    Given I am an authenticated registrant
    And There is a product named "MY PRODUCT"
    When I visit the item page for the first product
    And I press button "ADD TO REGISTRY"
    And I follow "Yes"
    Then I should be on the manage_registry page
    And I should see "1" "available" gift in my registry

# NOTE Scenarios for buying an items from the registry are in the giver/buy.feature section


  Scenario: View Category by clicking on category link
    Given I have a category named "MY CATEGORY" in "All" category
    And I have "1" store in each categories
    And I have "4" products in one store from each category stores
    When I go to the catalog page
    And I click the first product
    And I follow "MY CATEGORY"
    Then I should see "4" products

  Scenario: View Brand by clicking on Brand link
    Given I have "1" brands
    And I have "1" products in each brand
    When I visit the item page for the first product
    And I follow the Brand Link
    Then I should be on the brand's page

