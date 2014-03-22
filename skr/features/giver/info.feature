# language: en
Feature: Registry Info
  In order to know what someone has registered for
  As a Guest
  I want to view their registry.
  And I want to view the status of the items on the registry.

  Scenario: Registry Info
    Given a registry for "John" "Shriver Blake" and "Katy" "DeCelles" with description "Hello and welcome to my gift registry"
    And I visit the registry page
    Then I should see "John & Katy's Registry"
    And I should see "Hello and welcome to my gift registry"

  Scenario: Registry Products
    Given a registry
    And the registry has "5" "available" products in it
    And the registry has "5" "purchased" products in it
    And I visit the registry page
    Then I should see "5" "available" registry items
    And I should see "5" "purchased" registry items

#    PRICE DISPLAY
  Scenario: Product Pricing (multiple quantity)
    Given a registry with a "available" product in it with quantity "5" and price "12"
    And I visit the registry page
    Then I should see "$12.00"
    And I should see "5 Requested"

  Scenario: Product Pricing (single item)
    Given a registry with a "available" product in it with quantity "1" and price "12"
    And I visit the registry page
    Then I should see "$12.00"
    And I should not see "Requested"

  Scenario: Product Pricing - multiple quantity - partially contributed
    Given a registry with a "available" product in it with quantity "5" and price "12" with "12" contributed
    And I visit the registry page
    Then I should see "$12.00"
    And I should see "4 of 5 Available"

  Scenario: Product Pricing - multiple quantity - partially contributed - round up
    Given a registry with a "available" product in it with quantity "5" and price "12" with "20" contributed
    And I visit the registry page
    Then I should see "$12.00"
    And I should see "3 of 5 Available"

  Scenario: Product Pricing - single item - partially contributed
    Given a registry with a "available" product in it with quantity "1" and price "100" with "10" contributed
    And I visit the registry page
    Then I should see "$100.00"
    And I should see "$90.00 Remaining"




