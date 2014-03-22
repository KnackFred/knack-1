# language: en
Feature: View the items in my Registry
  In order to see what items I have registered for
  And see if they have been purchased or contributed to
  And act on the items in my registry
  As an Authenticated Registrant
  I want to see a list of all my items

  Scenario: View empty manage registry page
    Given I am an authenticated registrant
    And I have "0" "available" "catalogue" gifts in my registry
    When I go to the manage_registry page
    Then I should see an empty message

  Scenario: View available items in manage registry page
    Given I am an authenticated registrant
    And I have "12" "available" "catalogue" gifts in my registry
    When I go to the manage_registry page
    Then I should see "12" "available" gifts in my registry

  Scenario: View purchased items in the manage registry page
    Given I am an authenticated registrant
    And I have "12" "purchased" "catalogue" gifts in my registry
    When I go to the manage_registry page
    Then I should see "12" "purchased" gifts in my registry

  Scenario: View ordered items in the manage registry page
    Given I am an authenticated registrant
    And I have "12" "ordered" "catalogue" gifts in my registry
    When I go to the manage_registry page
    Then I should see "12" "ordered" gifts in my registry

  Scenario: View order info for ordered item in the manage registry page
    Given I am an authenticated registrant
    And I have a gift ordered on "04/05/2011", it is order number "12" and it is expected to be delivered in "04/08/2011"
    When I go to the manage_registry page
    Then I should see "1" "ordered" gifts in my registry
    And I should see "Ordered 04/05/2011"
    And I should see "Order number 12"
    And I should see "Expected delivery 04/08/2011"

  Scenario: View name, quantity, price & total for items in manage registry pages.
    Given I am an authenticated registrant
    And I have "1" "available" "catalogue" gifts in my registry
    When I go to the manage_registry page
    Then I should see the details of the gift

  Scenario: View source for for items added from another site in manage registry pages.
    Given I am an authenticated registrant
    And I have a gift from "Macys.com" with url "www.macys.com" in my registry
    When I go to the manage_registry page
    Then I should see an external link with text "Macys.com"

  Scenario: View available catalogue gift type for items in manage registry pages.
    Given I am an authenticated registrant
    And I have "1" "available" "catalogue" gifts in my registry
    When I go to the manage_registry page
    Then I should see the details of the gift

  Scenario: View ordered, unique gift type for items in manage registry pages.
    Given I am an authenticated registrant
    And I have "1" "ordered" "unique" gifts in my registry
    When I go to the manage_registry page
    Then I should see the details of the gift

  Scenario: View purchased, cash gift type for items in manage registry pages.
    Given I am an authenticated registrant
    And I have "1" "purchased" "cash" gift in my registry with "12" dollars contributed
    When I go to the manage_registry page
    Then I should see the details of the gift

  Scenario: View total contributions on a gift
    Given I am an authenticated registrant
    And I have "1" "available" "catalogue" gifts in my registry
    And "1" guests have contributed "300" dollars
    When I go to the manage_registry page
    Then I should see "Contributed $300.00"

  Scenario: View number of contributors on a gift
    Given I am an authenticated registrant
    And I have "5" "available" "catalogue" gifts in my registry
    And "5" guests have contributed "300" dollars
    When I go to the manage_registry page
    Then I should see "Contributors 5"

  @javascript
  Scenario: View contributors pop-up
    Given I am an authenticated registrant
    And I have "5" "available" "catalogue" gifts in my registry
    And "5" guests have contributed "300" dollars from "John Smith" with note "Hello There"
    When I go to the manage_registry page
    And I open the contributions pop-up for the first gift
    Then I should see "$300.00" in frame "ifr-popup"
    Then I should see "John Smith" in frame "ifr-popup"
    Then I should see "Hello There" in frame "ifr-popup"

  Scenario Outline: View Actions
    Given I am an authenticated registrant
    And I have "1" "<gift_state>" "<gift_type>" gift in my registry
    When I go to the manage_registry page
    Then I should see action "<link1>"
    And I should see action "<link2>"
    And I should see action "<link3>"
    And I should not see action "<not_link1>"
    And I should not see action "<not_link2>"
    And I should not see action "<not_link3>"
    And I should not see action "<not_link4>"
    And I should not see action "<not_link5>"

  Scenarios: All States and Types
    | gift_state | gift_type | link1 | link2              | link3 | not_link1 | not_link2 | not_link3 | not_link4 | not_link5     |
    | available  | catalogue | Buy   | Delete             | Edit  | Order     | zyzyzx    | zyzyzx    | zyzyzx    | Exchange For Cash |
    | available  | unique    | Buy   | Delete             | Edit  | Order     | zyzyzx    | zyzyzx    | zyzyzx    | Exchange For Cash |
    | available  | cash      |       | Delete             | Edit  | Order     | Buy       | zyzyzx    | zyzyzx    | Exchange For Cash |
    | purchased  | catalogue | Order | Exchange For Cash  |       | zyzyzx    | Buy       | Edit      | Delete    | zyzyzx        |
    | purchased  | unique    | Order |                    |       | zyzyzx    | Buy       | Edit      | Delete    | Exchange For Cash |
    | purchased  | cash      |       | Exchange For Cash  |       | Order     | Buy       | Edit      | Delete    | zyzyzx        |
    | ordered    | catalogue |       |                    |       | Order     | Buy       | Edit      | Delete    | Exchange For Cash |
    | ordered    | unique    |       |                    |       | Order     | Buy       | Edit      | Delete    | Exchange For Cash |

  Scenario Outline: View Actions for partially purchased gifts
    Given I am an authenticated registrant
    And I have "1" "<gift_state>" "<gift_type>" gift in my registry with "12" dollars contributed
    When I go to the manage_registry page
    Then I should see action "<link1>"
    And I should see action "<link2>"
    And I should not see action "<not_link1>"
    And I should not see action "<not_link2>"
    And I should not see action "<not_link3>"
    And I should not see action "<not_link4>"

  Scenarios: All States and Types
    | gift_state | gift_type | link1 | link2             | not_link1 | not_link2         | not_link3 | not_link4 |
    | available  | catalogue | Buy   | Exchange For Cash | Order     | zyzyzx            | Edit      | Delete    |
    | available  | unique    | Buy   |                   | Order     | Exchange For Cash | Edit      | Delete    |
    | available  | cash      |       | Exchange For Cash | Order     | Buy               | Edit      | Delete    |

  ############################################
  # Filtering
  ############################################
  Scenario: filter the view to only show available items.
    Given I am an authenticated registrant
    And I have "1" "available" "catalogue" gift in my registry
    And I have "2" "ordered" "catalogue" gift in my registry
    And I have "3" "purchased" "catalogue" gift in my registry
    When I go to the manage_registry page
    When I follow "Available"
    Then I should see "1" registry items

  Scenario: filter the view to only show ordered items.
    Given I am an authenticated registrant
    And I have "1" "available" "catalogue" gift in my registry
    And I have "2" "ordered" "catalogue" gift in my registry
    And I have "3" "purchased" "catalogue" gift in my registry
    When I go to the manage_registry page
    When I follow "Ordered"
    Then I should see "2" registry items

  Scenario: filter the view to only show purchased items.
    Given I am an authenticated registrant
    And I have "1" "available" "catalogue" gift in my registry
    And I have "2" "ordered" "catalogue" gift in my registry
    And I have "3" "purchased" "catalogue" gift in my registry
    When I go to the manage_registry page
    When I follow "Purchased"
    Then I should see "3" registry items

  Scenario: when all is set all should be shown
    Given I am an authenticated registrant
    And I have "1" "available" "catalogue" gift in my registry
    And I have "2" "ordered" "catalogue" gift in my registry
    And I have "3" "purchased" "catalogue" gift in my registry
    When I go to the manage_registry page
    When I follow "Available"
    And I follow "x"
    Then I should see "6" registry items

  ############################################
  # Ordering
  ############################################

  Scenario: Default Order (Date Modified)
    Given I am an authenticated registrant
    And I have a "available" "catalogue" gift in my registry named "Product 1" with a total price of "10" dollars how "registrant"
    And I have a "available" "catalogue" gift in my registry named "Product 2" with a total price of "8" dollars how "registrant"
    And I have a "available" "catalogue" gift in my registry named "Product 3" with a total price of "14" dollars how "registrant"
    When I go to the manage_registry page
    Then I should see in this order: Product 1, Product 2, Product 3

  Scenario: Order by Price Ascending
    Given I am an authenticated registrant
    And I have a "available" "catalogue" gift in my registry named "Product 1" with a total price of "10" dollars how "registrant"
    And I have a "available" "catalogue" gift in my registry named "Product 2" with a total price of "8" dollars how "registrant"
    And I have a "available" "catalogue" gift in my registry named "Product 3" with a total price of "14" dollars how "registrant"
    When I go to the manage_registry page
    And I follow "Low to High"
    Then I should see in this order: Product 2, Product 1, Product 3


  Scenario: Order by Price Descending
    Given I am an authenticated registrant
    And I have a "available" "catalogue" gift in my registry named "Product 1" with a total price of "10" dollars how "registrant"
    And I have a "available" "catalogue" gift in my registry named "Product 2" with a total price of "8" dollars how "registrant"
    And I have a "available" "catalogue" gift in my registry named "Product 3" with a total price of "14" dollars how "registrant"
    When I go to the manage_registry page
    And I follow "High to Low"
    Then I should see in this order: Product 3, Product 1, Product 2

  Scenario: Reset to Default Order
    Given I am an authenticated registrant
    And I have a "available" "catalogue" gift in my registry named "Product 1" with a total price of "10" dollars how "registrant"
    And I have a "available" "catalogue" gift in my registry named "Product 2" with a total price of "8" dollars how "registrant"
    And I have a "available" "catalogue" gift in my registry named "Product 3" with a total price of "14" dollars how "registrant"
    When I go to the manage_registry page
    And I follow "High to Low"
    And I follow "x"
		And I wait for "1" seconds
    Then I should see in this order: Product 1, Product 2, Product 3

  ###############################################
  # Actions - Delete
  ###############################################
  @javascript
  Scenario: delete an available catalogue item
    Given I am an authenticated registrant
    And I have "1" "available" "catalogue" gift in my registry
    When I go to the manage_registry page
    And I follow "Delete"
    And I follow "Yes"
		And I wait for "1" seconds
    Then I should see an empty message

  @javascript
  Scenario: cancel deleting an available item
    Given I am an authenticated registrant
    And I have "1" "available" "catalogue" gift in my registry
    When I go to the manage_registry page
    And I follow "Delete"
    And I follow "No"
    Then I should see "Quantity 1"
