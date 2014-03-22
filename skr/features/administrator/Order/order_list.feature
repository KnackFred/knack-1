# language: en
Feature: Orderlist

  Scenario: Log in as administrator and go to orders page
    Given I am an authenticated administrator
    When I go to the administrator orders page
    Then I should be on the administrator orders page

  Scenario: Administrator orders page - see empty table if there is no orders in the database
    Given I am an authenticated administrator
    When I go to the administrator orders page
    Then I should see "0" rows in the orders table

  Scenario: Administrator orders page - see table with data if there is any orders in the database
    Given I am an authenticated administrator
    And I have "48" orders
    When I go to the administrator orders page
    Then I should see "48" rows in the orders table

  Scenario: Administrator orders page - see 50 products per page
    Given I am an authenticated administrator
    And I have "51" orders
    When I go to the administrator orders page
    Then I should see "50" rows in the orders table

  @javascript
  Scenario: Administrator orders page - see 100 products per page
    Given I am an authenticated administrator
    And I have "101" orders
    When I go to the administrator orders page
    And I select "100" items per page
    Then I should see "100" rows in the orders table

  @javascript
  Scenario: Administrator orders page - see orders by pages
    Given I am an authenticated administrator
    And I have "51" orders
    When I go to the administrator orders page
    And I follow on page number "2"
    Then I should see "1" row in the orders table

  @javascript
  Scenario: Administrator orders page - filter orders by id
    Given I am an authenticated administrator
    And I have "51" orders
    When I go to the administrator orders page
    And I fill in "filter[order_id]" with "10"
  	And I press "Filter"
    Then I should see "1" row in the orders table

#  @javascript
#  Scenario: Administrator orders page - filter orders by date
#    Given I am an authenticated administrator
#    And the following orders exist:
#      | DateTime                   |
#      | Date.parse('4/4/1980')     |
#      | Date.parse('4/5/1980')     |
#      | Date.parse('4/6/1980')     |
#      | Date.parse('4/7/1980')     |
#      | Date.parse('4/8/1980')     |
#      | Date.parse('4/9/1980')     |
#    When I go to the administrator orders page
#    And I select "4/6/1980" from "filter[datepicker_from]"
#    And I select "4/7/1980" from "filter[datepicker_to]"
#    And I press "Filter"
#    Then I should see "2" rows in the products table

#  @javascript
#  Scenario: Administrator orders page - filter orders by date
#    Given I am an authenticated administrator
#    And the following orders exist:
#      | Amount |
#      | 10     |
#      | 20     |
#      | 30     |
#      | 40     |
#    When I go to the administrator orders page
#    And I select "15" from "filter[gross_from]"
#    And I select "25" from "filter[gross_to]"
#    And I press "Filter"
#    Then I should see "2" rows in the products table

  @javascript
  Scenario: Administrator orders page - filter orders by type
    Given I am an authenticated administrator
    And I have orders with the following types
      | order_type     |
      | Buy            |
      | Buy            |
      | Contribute     |
      | Contribute     |
      | Withdraw Cash  |
      | Withdraw Cash  |
    When I go to the administrator orders page
    And I select "Buy" from "filter[type_order]"
    And I press "Filter"
    Then I should see "2" rows in the products table

  @javascript
  Scenario: Administrator orders page - filter orders by status
    Given I am an authenticated administrator
    And I have orders with the following statuses
      | order_status  |
      | New           |
      | New           |
      | Shipped       |
      | Shipped       |
      | Canceled      |
      | Canceled      |
      | Closed        |
      | Closed        |
    When I go to the administrator orders page
    And I select "New" from "filter[status_id]"
  	And I press "Filter"
    Then I should see "2" rows in the products table

    #  @javascript
#  Scenario: Administrator orders page - filter orders by customer
#
#  @javascript
#  Scenario: Administrator orders page - filter orders by Store
#
#  @javascript
#  Scenario: Administrator orders page - filter orders by Paid In Full

