# language: en
Feature: Partner Administrators.

  @javascript
  Scenario: Basic Nav
    Given I am an authenticated partner
    When I go to the partner administrators page
    Then I should be on the partner administrators page
    When I click Add button
    Then I should be on the partner administrator page
    When I click Back button
    Then I should be on the partner administrators page

  @javascript
  Scenario: Create an administrator,
    Given I am an authenticated partner
    And I create an administrator
    Then I should be on the partner administrators page
    And I should see the administrator in the administrator list

  @javascript
  Scenario: Receive an error if an admin with the same email already exists.
    Given I am an authenticated partner
    And I create an administrator
    And I try to create the same administrator
    Then I should see "This login is already in use"

  @javascript
  Scenario Outline: Partner Administrator page validation errors.
    Given I am an authenticated partner
    When I go to the partner administrators page
    And I click Add button
    And I fill in the following:
    | administrator_FirstName | <first_name> |
    | administrator_LastName  | <last_name>  |
    | administrator_Login     | <login>      |
    | administrator_Password  | <password>   |
    | administrator_Phone     | <phone>      |
    | administrator_Email     | <email>      |
    And I click Save button
    Then I should be on the partner administrator page
    Then I should see "<message>"

    Scenarios:
    | first_name   | last_name | login             | password  | phone   | email               | message                  |
    |            | Admin     | PAdmin1           | Swordfish | 5553219 | p_admin@mail.com    | can't be blank  |
    | Partner    |           | PAdmin2           | Swordfish | 5553219 | p_admin@mail.com    | can't be blank   |
    | Partner    | Admin     |                   | Swordfish | 5553219 | p_admin@mail.com    | can't be blank      |
    | Partner    | Admin     | PAdmin6           | Fish      | 5553219 | p_admin@mail.com    | minimum is 5 characters  |
    | Partner    | Admin     | PAdmin8           | Swordfish | (`</>') | p_admin@mail.com    | phone must be valid      |
    | Partner    | Admin     | PAdmin8           | Swordfish | 555     | p_admin@mail.com    | minimum is 6 characters  |
    | Partner    | Admin     | PAdmin8           | Swordfish | 5553219 | (`</\>')@mail.com   | email must be valid      |
    | Partner    | Admin     | PAdmin9           | Swordfish | 5553219 | p_admin@(`</\>')    | email must be valid      |
    | Partner    | Admin     | PAdmin9           | Swordfish | 5553219 | (`</\>')            | email must be valid      |
    | Partner    | Admin     | PAdmin9           | Swordfish | 5553219 | p_admin.at.mail.com | email must be valid      |
    |            |           |                   |           |         |                     | can't be blank           |

  @javascript
  Scenario: Delete an administrator,
    Given I am an authenticated partner with 1 administrators
    When I delete the first administrator
    Then I should not see the administrator in the administrator list


  @javascript
  Scenario Outline: Partner Administrators page - admins per page.
    Given I am an authenticated partner with <admin_count> administrators
    When I go to the partner administrators page
    When I select "<admin_per_page>" items per page
    Then I should see <admin_count> administrators

    Scenarios:
    | admin_count | admin_per_page |
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