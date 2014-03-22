# language: en
Feature: Bulk update external items
  In order to take advantage of the external redirect feature.
  As a registrant with an existing registry
  I want to quickly change some of my cash items to external items

  Scenario: View all cash gifts items in the registry that have not been contributed to
    Given I am an authenticated registrant
    When I have "3" "available" "cash" gifts in my registry
    And I have "3" "purchased" "cash" gifts in my registry
    And I have "3" "available" "catalogue" gifts in my registry
    Then I should see "3" items on the update external page

  Scenario: View state of cash item
    Given I am an authenticated registrant
    When I have a "available" "cash" gift in my registry
    Then I should see the item on the update external page

  Scenario: View state of external item
    Given I am an authenticated registrant
    When I have a "available" "cash" gift in my registry
    Then I should see the item on the update external page

  Scenario: Modify external items
    Given I am an authenticated registrant
    And I have a "available" "cash" gift in my registry
    When I change the values for the item on the update external page
    Then I should see the item on the update external page

  Scenario: See validation error when incorrectly Modifying external items
    Given I am an authenticated registrant
    And I have a "available" "external" gift in my registry
    When I set an invalid value on the update external page
    Then I should see a validation error

