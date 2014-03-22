# language: en
Feature: Productlist

  Scenario: Log in as administrator and go to products page
    Given I am an authenticated administrator
    Then I should be on the administrator profile page
    When I go to the administrator products page
    Then I should be on the administrator products page

  Scenario: Administrator products page - see empty table if there is no products in the database
    Given I am an authenticated administrator on productlist page
    Then I should see "0" rows in the products table

  Scenario: Administrator products page - see table with data if there is any product in the database
    Given I am an authenticated administrator
    And I have "5" products
    When I go to the administrator products page
    Then I should see "5" rows in the products table

  Scenario: Administrator products page - see 50 products per page
    Given I am an authenticated administrator
    And I have "26" products
    When I go to the administrator products page
    Then I should see "25" rows in the products table
    
  @javascript
  Scenario: Administrator products page - see 100 products per page
    Given I am an authenticated administrator
    And I have "101" products
    When I go to the administrator products page
    And I select "100" items per page
    Then I should see "100" rows in the products table

  @javascript
  Scenario: Administrator products page - see products by pages
    Given I am an authenticated administrator
    And I have "51" products
    When I go to the administrator products page
    And I follow on page number "2"
    Then I should see "1" row in the products table

  @javascript
  Scenario: Administrator products page - filter products by id
    Given I am an authenticated administrator
    And I have "51" products
    When I go to the administrator products page
    And I fill in "filter[id]" with "10" 
  	And I press "Filter" 
    Then I should see "1" row in the products table

  @javascript
  Scenario: Administrator products page - filter products by status
    Given I am an authenticated administrator
    And I have products with the following statuses
    | product_status |
    |        1       |
    |        1       |
    |        1       |
    |        2       |
    |        2       |
    |        3       |
    When I go to the administrator products page
    And I select "Available" from "filter[product_status_id]"
  	And I press "Filter" 
    Then I should see "3" rows in the products table

  @javascript
   Scenario: Administrator products page - filter products by category
    Given I am an authenticated administrator
    And I have "6" products in category "Furniture"
    And I have "6" products in category "Art"
    When I go to the administrator products page
    Then I should see "12" rows in the products table
    When I select "Furniture" from "filter[category_id]"
   	And I press "Filter" 
    Then I should see "6" rows in the products table

  @javascript
   Scenario: Default type filter should be to show catalog items.
    Given There are "10" cash products
    And There are "5" catalog products
    And I am an authenticated administrator
    When I go to the administrator products page
    Then I should see "5" rows in the products table

  @javascript
  Scenario: Should show Cash items when selected
    Given There are "10" cash products
    And There are "5" catalog products
    And I am an authenticated administrator
    When I go to the administrator products page
    And I select "Cash" from "filter[product_type_id]"
   	And I press "Filter"
    Then I should see "10" rows in the products table

  @javascript
  Scenario: Should show All types when selected.
    Given There are "10" cash products
    And There are "5" catalog products
    And I am an authenticated administrator
    When I go to the administrator products page
    And I select "All" from "filter[product_type_id]"
    And I press "Filter"
    Then I should see "15" rows in the products table

  @javascript
   Scenario: Administrator products page - sort products by price
    Given I am an authenticated administrator
    And I have products with the following prices
    | master_price | sales_price |
    |      10      |             |
    |      50      |    20       |
    |      30      |             |
    When I go to the administrator products page
    And I select "Low-High" from "current_price"
    Then I should see rows in the products table sorted by price

  @javascript
   Scenario: Administrator products page - sort products by selected
    Given I am an authenticated administrator
    And I have products selected to registries at following quantities
    |   name    | quantity |
    | product1  |     2    |
    | product2  |     3    |
    | product3  |     1    |
    When I go to the administrator products page
    And I select "Low-High" from "selected"
    Then I should see rows in the products table sorted low-high

  @javascript
   Scenario: Administrator products page - sort products by purchased
    Given I am an authenticated administrator
    And I have products purchased at following quantities
    |   name    | quantity |
    | product1  |     2    |
    | product2  |     3    |
    | product3  |     1    |
    When I go to the administrator products page
    And I select "Low-High" from "purchased"
    Then I should see rows in the products table sorted low-high

  @javascript
   Scenario: Administrator products page - sort products by ordered
    Given I am an authenticated administrator
    And I have products ordered at following quantities
    |   name    | quantity |
    | product1  |     2    |
    | product2  |     3    |
    | product3  |     1    |
    When I go to the administrator products page
    And I select "Low-High" from "ordered"
    Then I should see rows in the products table sorted low-high

  @javascript
   Scenario: Administrator products page - sort products by priority
    Given I am an authenticated administrator
    And I have products with the following priorities
    |   name    | priority |
    | product1  |     2    |
    | product2  |     3    |
    | product3  |     1    |
    When I go to the administrator products page
    And I select "Low-High" from "priority"
    Then I should see rows in the products table sorted low-high









