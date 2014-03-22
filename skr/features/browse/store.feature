# language: en
Feature: View the available stores
  In order to find products in the catalog that are from stores I know and like
  As a user
  I want to see a list of stores that are offered in the catalogue

  @javascript
  Scenario: View stores in modal window - from catalog
    Given I have "3" categories in "All" category
    And I have "2" stores in each categories
    And I have "2" products in one store from each category stores
    When I go to the catalog page
    And I follow "Stores"
	When I wait for "2" seconds
    Then I should see "1" stores from each category

  @javascript
  Scenario: View stores in modal window - from item
    Given I have "3" categories in "All" category
    And I have "2" stores in each categories
    And I have "2" products in one store from each category stores
    When I go to the catalog page
    And I click the first product
    And I follow "Stores"
	When I wait for "2" seconds
    Then I should see "1" stores from each category

  Scenario: View products for store
    Given I have "1" categories in "All" category
    And I have a store named "MY STORE" in one category
    And I have "10" products in one store from each category stores
    When I go to the stores page
    And I follow "MY STORE"
    And I should see "10" products
    And I should see store bio for "MY STORE"

  Scenario: See Breadcrumb For Store
    Given I have "1" categories in "All" category
    And I have a store named "MY STORE" in one category
    And I have "10" products in one store from each category stores
    When I go to the stores page
    And I follow "MY STORE"
    Then I should see "Listed in Store: Catalog > MY STORE"

  Scenario: See Breadcrumb For Item in Store
    Given I have "1" categories in "All" category
    And I have a store named "MY STORE" in one category
    And I have "10" products in one store from each category stores
    When I go to the stores page
    And I follow "MY STORE"
    And I click the first product
    Then I should see "Listed in Store: Catalog > MY STORE"

#    TODO, ONCE the 1.6branch has been integrated back we should add a test for the visible setting (and related scenarios)
#   Also when this happens we can clean up the Givens for these scenarios.