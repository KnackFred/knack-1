# language: en
Feature: Partner Stores.

  @javascript
  Scenario: Navigate to the stores Page
    Given I am an authenticated partner
    When I follow "Stores"
    Then I should be on the stores list page
    When I press the add button
    Then I should be on the edit store page
    When I press the back button
    Then I should be on the stores list page

  @javascript
  Scenario: Create a store
    Given I am an authenticated partner
    When I create a new store
    Then I should be on the stores list page
    Then I should see "TestStore@store.com"


  @javascript
  Scenario Outline: Partner Store page - create store with invalid info.
    Given I am an authenticated partner
    When I go to the stores list page
    Then I should be on the stores list page
    When I click Add button
    Then I should be on the edit store page
    When I fill in the following:
    | store_Name         | <name>     |
    | store_Street       | <street>   |
    | store_City         | <city>     |
    | store_ZIP          | <zip>      |
    | store_Phone        | <phone>    |
    | store_Email        | <email>    |
    And I select Alabama from store State select box
    And I click Save button
    Then I should be on the edit store page
    Then I should see "<message>"

  Scenarios:
  | name       | street    | city      | zip      | phone    | email                   | message                                |
  |            | 1-st     | Benton   | 36785    | 5553221  | test_store@mail.com    | can't be blank                         |
  | Test store |          | Benton   | 36785    | 5553221  | test_store@mail.com    | can't be blank                         |
  | Test store | 1-st     |          | 36785    | 5553221  | test_store@mail.com    | can't be blank                         |
  | Test store | 1-st     | Benton   |          | 5553221  | test_store@mail.com    | You must provide a valid ZIP           |
  | Test store | 1-st     | Benton   | abcd     | 5553221  | test_store@mail.com    | You must provide a valid ZIP           |
  | Test store | 1-st     | Benton   | 3678     | 5553221  | test_store@mail.com    | You must provide a valid ZIP           |
  | Test store | 1-st     | Benton   | 36785    | 555      | test_store@mail.com    | minimum is 6 characters                |
  | Test store | 1-st     | Benton   | 36785    | (`</\>') | test_store@mail.com    | You must provide a valid Phone         |
  | Test store | 1-st     | Benton   | 36785    | abcdefg  | test_store@mail.com    | You must provide a valid Phone         |
  | Test store | 1-st     | Benton   | 36785    | 5553221  | (`</\>')               | You must provide a valid email address |
  | Test store | 1-st     | Benton   | 36785    | 5553221  | (`</\>')@mail.com      | You must provide a valid email address |
  | Test store | 1-st     | Benton   | 36785    | 5553221  | test_store@(`</\>')    | You must provide a valid email address |
  | Test store | 1-st     | Benton   | 36785    | 5553221  | test_store.at.mail.com | You must provide a valid email address |
  | Test store | 1-st     | Benton   | 36785    | 5553221  | test_store@.mail       | You must provide a valid email address |
  |            |          |          |          |          |                        | can't be blank     |


  @javascript
  Scenario Outline: Partner Stores page - stores per page.
    Given I am a registered partner with <store_count> stores
    When I go to the stores list page
    Then I should be on the stores list page
    When I select "<store_per_page>" items per page
    Then I should see <store_count> stores

    Scenarios:
    | store_count | store_per_page |
    | 1           | 8              |
    | 5           | 8              |
    | 7           | 8              |
    | 8           | 8              |
    | 1           | 16             |
    | 8           | 16             |
    | 15          | 16             |
    | 16          | 16             |
    | 1           | 24             |
    | 16          | 24             |
    | 23          | 24             |
    | 24          | 24             |
    | 1           | 50             |
    | 24          | 50             |
    | 49          | 50             |
    | 50          | 50             |