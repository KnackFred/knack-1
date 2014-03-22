# language: en
Feature: Options for adding an item
  As a registrant
  In order to build my registry
  I need to know the options I have for adding items to my registry
  And I need to be able to add my own cash items to my registry for experiences like my honeymoon.

  Scenario: View addgift page
    Given I am an authenticated registrant
    When I go to the addgift page
    Then I should see "Choose a gift from our Catalog, which features offerings from some of the best boutique retailers and artists in the country!"
    And I should see "Use our Gift List Tool to add any gift from your favorite website!"
    And I should see "Add honeymoon items, cooking classes, or anything you can think of using our Add Your Own Gift Tool!"

  Scenario: Choose first case adding product
    Given I am an authenticated registrant
    When I go to the addgift page
    And I follow "Choose a gift from our Catalog, which features offerings from some of the best boutique retailers and artists in the country!"
    Then I should see "Catalog"

  @javascript
  Scenario: View modal window "Add Gifts From Another Site"
    Given I am an authenticated registrant
    When I go to the addgift page
	And I click block "Use our"
	When I wait for "2" seconds
    Then I should see "Add Gifts From Another Site"
    And I should see "Instructions for Internet Explorer Users" in frame "ifr-popup"

  @javascript
  Scenario: View Instructions for Safari Users
    Given I am an authenticated registrant
    When I go to the addgift page
	And I click block "Use our"
	When I wait for "2" seconds
    And I select "Safari" from "browser_id" in frame "ifr-popup"
    Then I should see "Instructions for Safari Users" in frame "ifr-popup"

  @javascript
  Scenario: View Instructions for FireFox Users
    Given I am an authenticated registrant
    When I go to the addgift page
	And I click block "Use our"
    And I select "Firefox" from "browser_id" in frame "ifr-popup"
    Then I should see "Instructions for Firefox Users" in frame "ifr-popup"

  @javascript
  Scenario: View modal window "Add My Own Gift"
    Given I am an authenticated registrant
    When I go to the addgift page
    And I click block "Add honeymoon items, cooking classes, or anything you can think of using our"
    Then I should see "Add My Own Gift"
    And I should be in frame "ifr-popup" on the add_my_gift page

  @javascript
  Scenario: Prevent add gift if the user does not fill out any fields
    Given I am an authenticated registrant
    When I go to the addgift page
    And I click block "Add honeymoon items, cooking classes, or anything you can think of using our"
	And I wait for "2" seconds
    And I fill in the following in frame "ifr-popup":
    | name                          | value          |
    | product_Name                  |                |
    | product_MasterPrice           |                |
    | product_quantity              |                |
    And I press "AddToRegistryButton" in frame "ifr-popup"
    Then I should be in frame "ifr-popup" on the add_my_gift page
    And I should see "can't be blank" in frame "ifr-popup"

  @javascript
  Scenario: Add gift without image and not use tax and shipment
    Given I am an authenticated registrant
    When I go to the addgift page
    And I click block "Add honeymoon items, cooking classes, or anything you can think of using our"
	And I wait for "2" seconds
    And I fill in the following in frame "ifr-popup":
    | name                          | value             |
    | product_Name                  | Test my own gift  |
    | product_MasterPrice           | 100               |
    | product_quantity              | 2                 |
    Then I should see "$200.00" in frame "ifr-popup"
    And I press "AddToRegistryButton" in frame "ifr-popup"
    And I wait for "3" seconds
    Then I should be on the manage_registry page
    And I should see "Test my own gift"

  @javascript
  Scenario: Add gift with use tax and shipment and without image
    Given I am an authenticated registrant
    When I go to the addgift page
    And I click block "Add honeymoon items, cooking classes, or anything you can think of using our"
	And I wait for "2" seconds
    And I fill in the following in frame "ifr-popup":
    | name                          | value             |
    | product_Name                  | Test my own gift  |
    | product_MasterPrice           | 100               |
    | product_quantity              | 2                 |
    Then I should see "$200.00" in frame "ifr-popup"
    And I check "product_use_tax" in frame "ifr-popup"
    And I select "10 %" from "product_sales_tax" in frame "ifr-popup"
    And I fill in "product_ShipmentCost" with "23" in frame "ifr-popup"
    Then I should see "$266.00" in frame "ifr-popup"
    When I uncheck "product_use_tax" in frame "ifr-popup"
    Then I should see "$200.00" in frame "ifr-popup"
    When I check "product_use_tax" in frame "ifr-popup"
    And I press "AddToRegistryButton" in frame "ifr-popup"
    And I wait for "3" seconds
    Then I should be on the manage_registry page
    And I should see "Test my own gift"
    And I should see "Price $100.00"
    And I should see "Subtotal $200.00"

  @javascript
  Scenario: Add gift with image
	Given I am an authenticated registrant
	When I go to the addgift page
    And I click block "Add honeymoon items, cooking classes, or anything you can think of using our"
	And I wait for "2" seconds
	And I fill in the following in frame "ifr-popup":
	| name                          | value             |
	| product_Name                  | Test my own gift  |
	| product_MasterPrice           | 100               |
	| product_quantity              | 2                 |
	And I attach the file "cash.png" to "fupload" in frame "ifr-popup"
	Then I should see "save-image" in frame "ifr-popup"
	When I press "save-image" in frame "ifr-popup"
	# Then I should see 
	And I press "AddToRegistryButton" in frame "ifr-popup"
	And I wait for "3" seconds
	Then I should be on the manage_registry page
	And I should see "Test my own gift"

  @javascript
  Scenario: Add gift with a stock image
	Given I am an authenticated registrant
	When I go to the addgift page
    And I click block "Add honeymoon items, cooking classes, or anything you can think of using our"
	And I wait for "2" seconds
	And I fill in the following in frame "ifr-popup":
	| name                          | value             |
	| product_Name                  | Test my own gift  |
	| product_MasterPrice           | 100               |
	| product_quantity              | 2                 |
	And I follow "Use Stock Image" in frame "ifr-popup"
	When I click first stock image in frame "ifr-popup"
	And I press "AddToRegistryButton" in frame "ifr-popup"
	And I wait for "3" seconds
	Then I should be on the manage_registry page
	And I should see "Test my own gift"

