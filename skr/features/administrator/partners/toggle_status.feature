# language: en
Feature: toggle_status

  @javascript
  Scenario: Log in as administrator and toggle deleted state
    Given I am an authenticated administrator
    And I have a partner that is "available" and "activated"
    When I go to the administrator partners page
    Then I should see "Active" within ".partner"
    When I follow "Active"
    And I wait until all Ajax requests are complete
    Then I should see "Deleted" within ".partner"
    When I follow "Deleted"
    And I wait until all Ajax requests are complete
    Then I should see "Active" within ".partner"

  @javascript
  Scenario: Log in as administrator and toggle activated state
    Given I am an authenticated administrator
    And I have a partner that is "available" and "not activated"
    When I go to the administrator partners page
    Then I should see "Not Activated" within ".partner"
    When I follow "Not Activated"
    And I wait until all Ajax requests are complete
    Then I should see "Activated" within ".partner"
    When I follow "Activated"
    And I wait until all Ajax requests are complete
    Then I should see "Not Activated" within ".partner"
