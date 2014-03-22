# language: en
Feature: Administrator Editproduct

  Scenario: Log in as administrator and go to edit page for a product
    Given I am an authenticated administrator
    And I have "1" product
    When I go to the administrator products page
    And I should see "1" row in the products table
    When I follow edit link for product in row "1"
    Then I should see edit for the product

  @javascript
  Scenario: Update basic product info
    Given I am an authenticated administrator editing existing product
    When I edit the products basic data
    Then I should see edit for the saved product

  @javascript
  Scenario: Set new brand
    Given I am an authenticated administrator editing existing product
    When I set a new brand for the product
    Then I should see edit for the saved product

  @javascript
  Scenario: Edit the products shipment category
    Given I am an authenticated administrator editing existing product
    When I edit the products shipment category
    Then I should see edit for the saved product

  @javascript
  Scenario: Add a category to the product
    Given I am an authenticated administrator editing existing product
    When I add a category to the product
    Then I should see edit for the saved product

  @javascript
  Scenario: Add a color to the product
    Given I am an authenticated administrator editing existing product
    When I add a color to the product
    Then I should see edit for the saved product

  @javascript
  Scenario: Add a varient to the product
    Given I am an authenticated administrator editing existing product
    When I add a varient to the product
    Then I should see edit for the saved product

  @javascript
  Scenario: Add a store to the product
    Given I am an authenticated administrator editing existing product
    When I add a store to the product
    Then I should see edit for the saved product

  @javascript
  Scenario: Enter invalid data
    Given I am an authenticated administrator editing existing product
    When I enter invalid product data
    Then I should see a validation error

  @javascript
  Scenario: Administrator editproduct page - click Back button
    Given I am an authenticated administrator editing existing product
    When I follow "View All Products"
    Then I should be on the administrator products page
