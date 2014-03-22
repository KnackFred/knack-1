# language: en

Feature: Edit an external item in the registry
  In order to control how I receive external gifts
  As an Authenticated Registrant
  I want to indicate if Knack should redirect users buying a non catalog gift, and update the url they are pointed to.


  Scenario: set a cash item to external
    Given I am an authenticated registrant
    And I have a "available" "cash" gift in my registry
    When I go to the manage_registry page
    And I set the item to redirect and provide a source url and name
    When I go to the manage_registry page
    And I should see the external item

  Scenario: edit varients on an exteral item
    Given I am an authenticated registrant
    And I have a "available" "cash" gift in my registry
    When I go to the manage_registry page
    When I edit the items varients
    Then I should see the item has updated varients

# The only way to test for validation is javascript but I can not get the pop-ups working with javascript.
#  @javascript
#  Scenario: validation error when editing a cash item with no contributions.
#    Given I am an authenticated registrant
#    And I have a "available" "cash" gift in my registry
#    When I go to the manage_registry page
#    And I set the item to redirect without providing a source url and name
#    And I should see a validation error in the pop-up


