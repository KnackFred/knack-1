# language: en
Feature: Profile
  In order to make sure my personal and registry information is correct
  As a Registrant
  I want to be able to view and update my personal and registry information

  @javascript
  Scenario: view profile
    Given I am an authenticated registrant
    When I go to the profile page
    Then I should be on the profile page
    And I should see my profile information

  @javascript
  Scenario: change profile
    Given I am an authenticated registrant
    When I go to the profile page
    And I fill out an empty profile
    And I press "Save"
    Then I should be on the profile page
    And I should see "Your changes have been saved."
    And I wait for "10" seconds
    And I should see my profile information

  @javascript
  Scenario: change profile
    Given I am an authenticated registrant
    When I go to the profile page
    And I fill out my profile
    And I press "Save"
    Then I should be on the profile page
    And I should see "Your changes have been saved."
    And I should see my profile information

  @javascript
  Scenario: change password
    Given I am an authenticated registrant
    When I go to the profile page
    And I change my password
    Then I should be on the profile page
    And I should see "Your changes have been saved."
    And I should be able to sign-out and sign back in

  #Scenario: Facebook users should not see change password
  #  Given I am a registered facebook user with email "test@test.com"
  #  When I go to the profile page
  #  Then I should not see "Change Password"

#MISSING: First Sign IN



