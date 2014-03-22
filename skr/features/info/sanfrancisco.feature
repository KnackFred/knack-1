# language: en
# language: en
Feature: In order to create a more personal connection with SF users
  As Knack
  We want to point these users to a SF specific landing page.

  Scenario: Access the SF Landing page directly
    When I go to the sanfrancisco page
    Then I should be on the sanfrancisco page

  Scenario: Access the SF Landing page through redirect
    When I go to the sf page
    Then I should be on the sanfrancisco page
    When I go to the san_francisco page
    Then I should be on the sanfrancisco page

