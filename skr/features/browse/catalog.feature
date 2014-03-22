# language: en
Feature: View the products in Catalog
  In order to see available products that I might want
  I want to see available products
  And have the option of filtering by price.

  Scenario: View empty catalog page
    When I go to the catalog page
    Then I should see an empty message

  Scenario: View catalog page
    Given I have "3" categories in "All" category
    And I have "2" stores in each categories
    And I have "2" products in one store from each category stores
    When I go to the catalog page
    Then I should see "6" products

  @javascript
  Scenario: View Catalog by clicking number page link
    Given I have "3" categories in "All" category
    And I have "2" stores in each categories
    And I have "32" products in one store from each category stores
    When I go to the catalog page
    And I follow on page number "2"
    Then I should see "32" products

  @javascript
  Scenario: View Catalog by change count items per page
    Given I have "3" categories in "All" category
    And I have "2" stores in each categories
    And I have "4" products in one store from each category stores
    When I go to the catalog page
    And I select "8" items per page
    Then I should see "8" products

  @javascript
  Scenario: View Catalog by clicking on category link
    Given I have a category named "MY CATEGORY" in "All" category
    And I have "1" store in each categories
    And I have "4" products in one store from each category stores
    When I go to the catalog page
    And I follow "MY CATEGORY"
    Then I should see "4" products

  @javascript
  Scenario: View Catalog by change price slider
    Given I have "3" categories in "All" category
    And I have "2" stores in each categories
    And I have "3" products in one store from each category stores
    When I go to the catalog page
    And I shift the "left" slider by "8" positions
    Then I should see "2" products

  @javascript
  Scenario: View the same catalog page when back to catalog from item page
    Given I have "3" categories in "All" category
    And I have "2" stores in each categories
    And I have "3" products in one store from each category stores
    When I go to the catalog page
    And I shift the "left" slider by "8" positions
	And I wait for "1" seconds
    And I click the first product
    And I press button "BACK TO CATALOG"
    Then I should see "2" products

  Scenario: Show priority products first.
    Given I have a category named "MY CATEGORY" in "All" category
    And I have "1" store in each categories
    Given I have products with priority
        | Name         | Priority  |
        | Product 1    | 2         |
        | Product 2    | 5         |
        | Product 3    | 10        |
        | Product 4    | 0         |
    When I go to the catalog page
    Then I should see products in that order
        | Name          |
        | Product 3     |
        | Product 2     |
        | Product 1     |
        | Product 4     |

  Scenario: Show priority products first in category.
    Given I have a category named "MY CATEGORY" in "All" category
    And I have "1" store in each categories
    Given I have products with priority
        | Name         | Priority  |
        | Product 1    | 2         |
        | Product 2    | 5         |
        | Product 3    | 10        |
        | Product 4    | 0         |
    When I go to the catalog page
    Then I should see products in that order
        | Name          |
        | Product 3     |
        | Product 2     |
        | Product 1     |
        | Product 4     |

  Scenario: Show priority products first in search.
    Given I have a category named "MY CATEGORY" in "All" category
    And I have "1" store in each categories
    Given I have products with priority
        | Name         | Priority  |
        | Product 1    | 2         |
        | Product 2    | 5         |
        | Product 3    | 10        |
        | Product 4    | 0         |
    And the Product indexes are processed
    When I go to the catalog page
    When I fill in "textfind" with "product"
    When I press "go"
    Then I should see products in that order
        | Name          |
        | Product 3     |
        | Product 2     |
        | Product 1     |
        | Product 4     |