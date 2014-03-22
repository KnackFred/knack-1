# language: en
Feature: Products Search
  In order to see available products that I might want
  I want to search products

  Background:
    Given I have "1" categories in "All" category
    And I have "1" store in each categories
    And I have products with the following attributes in one store and one category stores
      | Name          | Description                                 | Brand   |
      | Rails Way     | It is written by Obie Fernandez             | Brand 1 |
      | RSpec Book    | It is written by David Chelimsky and others | Brand 2 |
      | Cucumber Book | It is written by Matt Wynne and others      | Brand 2 |
      | Rails1 Way    | It is written by Obie Fernandez             | Brand 1 |
      | Rails2 Way    | It is written by Obie Fernandez Rails       | RSpec   |
    And the Product indexes are processed
    When I go to the catalog page

  @javascript
  Scenario: Search products by name
    When I fill in "textfind" with "Cucumber"
    When I press "go"
    Then I should see "1" products

  @javascript
  Scenario: Search products by description
    When I fill in "textfind" with "written"
    When I press "go"
    Then I should see "5" products

  @javascript
  Scenario: Search products by brand
    When I fill in "textfind" with "Brand"
    When I press "go"
    Then I should see "4" products

  @javascript
  Scenario: Search products by Name and Description
    When I fill in "textfind" with "Rails"
    When I press "go"
    Then I should see "2" products

  @javascript
  Scenario: Search products by name and Brand
    When I fill in "textfind" with "RSpec"
    When I press "go"
    Then I should see "2" products

  @javascript
  Scenario: Search is case insensitive
    When I fill in "textfind" with "cucumber"
    When I press "go"
    Then I should see "1" products

  @javascript
  Scenario: Search results should autocomplete on brand
    When I fill in "textfind" with "Brand"
    Then I should see drop-down block with "4" products

  @javascript
  Scenario: Search results should autocomplete on name
    When I fill in "textfind" with "Book"
    Then I should see drop-down block with "2" products

  @javascript
  Scenario: View drop-down does not include description
    When I fill in "textfind" with "written"
    Then I should not see drop-down block

  @javascript
  Scenario: View Catalog by clicking number page link
    Given I have "3" categories in "All" category
    And I have "2" stores in each categories
    And I have "39" products in one store from each category stores
    And the Product indexes are processed
    When I go to the catalog page
    When I fill in "textfind" with "test"
    When I press "go"
    And I follow on page number "2"
    Then I should see "32" products

  @javascript
  Scenario: View Catalog by change count items per page
    Given I have "3" categories in "All" category
    And I have "2" stores in each categories
    And I have "4" products in one store from each category stores
    And the Product indexes are processed
    When I go to the catalog page
    When I fill in "textfind" with "test"
    When I press "go"
    And I select "8" items per page
    Then I should see "8" products
