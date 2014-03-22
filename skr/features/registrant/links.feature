# language: en
Feature: Share Links to My Registry
  In order to publicise their registry to their guests
  As an Authenticated Registrant
  I Want to embed links to their registry in emails or websites.

  Scenario: Access links page with 10 links
    Given I am an authenticated registrant
    And I have "10" "available" "catalogue" gifts in my registry
    When I go to the links page
    Then I should see 4 banners
    And each banner should have a corresponding code snippet
    And banner should have a gift count of "10"

  Scenario: Access links page with 5 link
    Given I am an authenticated registrant
    And I have "1" "available" "catalogue" gifts in my registry
    When I go to the links page
    Then I should see 4 banners
    And each banner should have a corresponding code snippet
    And banner should have a gift count of "1"

  Scenario: Access links page with 0 links
    Given I am an authenticated registrant
    When I go to the links page
    Then I should see 4 banners
    And each banner should have a corresponding code snippet
    And banner should have a gift count of "0"
