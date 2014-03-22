# language: en
Feature: Edit an item in the registry
  In order to create the registry I want
  As an Authenticated Registrant
  I want to be able to edit items I have added to my registry.

  Scenario: edit an available catalog item with no contributions.
    Given I am an authenticated registrant
    And I have "1" "available" "catalogue" gift in my registry
    When I go to the manage_registry page
    And I follow "Edit"
    And I fill in "Quantity" with "5"
    And I press "SAVE"
    Then I should see "1"

  Scenario: Validation error on catalog item.
    Given I am an authenticated registrant
    And I have "1" "available" "catalogue" gift in my registry
    When I go to the manage_registry page
    And I follow "Edit"
    And I fill in "Quantity" with "0"
    And I press "SAVE"
    Then I should see "Quantity"
    When I fill in "Quantity" with "1"
    And I press "SAVE"
    Then I should see "1"

  Scenario: do not allow user to edit quantity on a one of a kind item.
    Given I am an authenticated registrant
    And I have "1" "available" "unique" gift in my registry
    When I go to the manage_registry page
    And I follow "Edit"
    Then I should see read only field "Quantity"

  Scenario: edit a cash item with variants.
    Given I am an authenticated registrant
    And I have an "available" gift in my registry with a variant named "Stuff" and value "foo" of "bar,foo,bat"
    And I have "1" "available" "cash" gift in my registry
    When I go to the manage_registry page
    And I follow "Edit"
    And I select "foo" from "product_params_Stuff"
    And I press "SAVE"
    Then I should see "1"

  Scenario: edit a cash item with no contributions.
    Given I am an authenticated registrant
    And I have "1" "available" "cash" gift in my registry
    When I go to the manage_registry page
    And I follow "Edit"
    And I fill in the following:
      | Quantity    | 5                |
      | Name        | New Name         |
      | Description | New Description  |
      | Price       | 14.72            |
    And I press "SAVE"
    Then I should see "1"
    When I go to the manage_registry page
    Then I should see "New Name"

  Scenario: validation error when editing a cash item with no contributions.
    Given I am an authenticated registrant
    And I have "1" "available" "cash" gift in my registry
    When I go to the manage_registry page
    And I follow "Edit"
    And I fill in the following:
      | Quantity    | 5                |
      | Name        |          |
      | Description | New Description  |
      | Price       | 14.72            |
    And I press "SAVE"
    Then I should see "Quantity"
    When I fill in "Name" with "Name"
    And I press "SAVE"
    Then I should see "1"


