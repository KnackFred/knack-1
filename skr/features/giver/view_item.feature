# language: en
Feature: Registry Info
  In order to see the details of an item, and potentially buy/contribute to the item
  As a Guest
  I want to view their registry.
  And I want to view the status of the items on the registry.

  Scenario: Open Item Page
    Given a registry with products in it
    When I visit the registry page
    And I click on registry item "1"
    Then I should see the registry item

  Scenario: Product Pricing (multiple quantity)
    Given a registry with a "available" product in it with quantity "5" and price "12"
    When I visit the registry item page
    Then I should see "$12.00"
    And I should see "5 Requested"

  Scenario: Product Pricing (single item)
    Given a registry with a "available" product in it with quantity "1" and price "12"
    When I visit the registry item page
    Then I should see "$12.00"
    And I should see "1 Requested"

  Scenario: Product Pricing - multiple quantity - partially contributed
    Given a registry with a "available" product in it with quantity "5" and price "12" with "12" contributed
    When I visit the registry item page
    Then I should see "$12.00"
    And I should see "4 of 5 Available"

  Scenario: Product Pricing - multiple quantity - partially contributed - round up
    Given a registry with a "available" product in it with quantity "5" and price "12" with "20" contributed
    When I visit the registry item page
    Then I should see "$12.00"
    And I should see "3 of 5 Available"

  Scenario: Product Pricing - single item - partially contributed
    Given a registry with a "available" product in it with quantity "1" and price "100" with "10" contributed
    When I visit the registry item page
    Then I should see "$100.00"
    And I should see "$90.00 Remaining"

