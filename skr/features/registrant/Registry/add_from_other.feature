# language: en
Feature: Add from other registry
  In order to more easily create my registry, and have more fun doing it.
  As a Registrant
  I want to add items from someone else's registry page

  Scenario: Add Catalog Item From Someone Else's Registry
    Given a registry with "1" product in it
    And I am an authenticated registrant
    When I visit the registry page
    And I add the first item to my registry
    Then I should see "1" gift in my registry

  Scenario: Add Catalog Item From Seomeone Else's Registry
    Given a registry with an external gift in it
    And I am an authenticated registrant
    When I visit the registry page
    And I add the first item to my registry
    Then I should see "1" gift in my registry

  Scenario: Varients when adding from catalog
    Given a registry with an external gift in it with varients
    And I am an authenticated registrant
    When I visit the registry page
    And I click the button to add the first item to my registry
    Then I should see a pop-up with the varients in it
    When I click SAVE button
    Then I should see "1" gift in my registry

