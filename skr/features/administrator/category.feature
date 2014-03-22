# language: en
Feature: Category

  Scenario: Categories list should show the categories in the system.
    Given I am an authenticated administrator
    When I go to the administrator categories page
    Then I should entries for each category in the system



