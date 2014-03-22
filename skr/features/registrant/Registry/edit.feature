# language: en
Feature: Edit Registry Page
  In order to ensure I have a more personal connection with my guests
  As a Registrant
  I want to modify the view of my registry page.  
  
  Scenario: Edit Description
    Given I am an authenticated registrant
    And I have "12" "available" "catalogue" gifts in my registry
    When I visit the registry page
    And I fill in "THIS IS A TEST DESCRIPTION" for "registrant_Description"
    And I press "SAVE"
    Then I should see "THIS IS A TEST DESCRIPTION"

#  @javascript
#  Scenario: Alert user of unsaved changes.
#    Given I am an authenticated registrant
#    And I have "12" "available" "catalogue" gifts in my registry
#    When I visit the registry page
#    And I fill in "THIS IS A TEST DESCRIPTION" for "registrant_Description"
#    And I follow "Manage Registry"
#    Then I should see "" in alert

  @javascript
  Scenario: Change Picture
    Given I am an authenticated registrant
    And I have "12" "available" "catalogue" gifts in my registry
    When I visit the registry page
    And I click on the profile picture
    Then I should see "Select a new profile picture"
    When I attach the file "public/images/defaultImage.png" to "fupload"
    And I wait for "1" seconds
    And I press "save-image"
    And I press "SAVE"
    Then I should see "This is what your guests will see"
