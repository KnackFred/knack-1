# language: en
Feature: View the available brands
  In order to find products in the catalog that are from brands I know and like
  As a user
  I want to see a list of brands that are offered in the catalogue

  @javascript
  Scenario: View brands from catalog page
    Given I have "3" brands
    And I have "5" products in each brand
    When I go to the catalog page
    And I follow "Brands"
    Then I should see "3" brands in the pop-up

  @javascript
  Scenario: View products for brand from item page
    Given I have "3" brands
    And I have "5" products in each brand
    When I go to the catalog page
    And I click the first product
    And I follow "Brands"
    Then I should see "3" brands in the pop-up

  @javascript
  Scenario: Should not show brands with no available products in it
    And I have a brand named "MY BRAND" with "0" products in it
    When I go to the catalog page
    And I follow "Brands"
    Then I should see "0" brands in the pop-up

  Scenario: View products for selected brand
    And I have a brand named "MY BRAND" with "5" products in it
    When I go to the brands page
    And I follow "MY BRAND"
    Then I should see "5" products

  Scenario: See Breadcrumb For Brand
    Given I have a brand named "MY BRAND" with "5" products in it
    When I go to the brands page
    And I follow "MY BRAND"
    Then I should see "Listed in Brand: Catalog > MY BRAND"

  Scenario: See Breadcrumb For Item in Brand
    Given I have a brand named "MY BRAND" with "5" products in it
    When I go to the brands page
    And I follow "MY BRAND"
    And I click the first product
    Then I should see "Listed in Brand: Catalog > MY BRAND"

