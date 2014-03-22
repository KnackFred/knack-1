# language: en
Feature: Order

  Scenario: Log in as administrator and go to order page
    Given I am an authenticated administrator
    And I have "1" orders
    When I go to the administrator orders page
    And I follow "View / Edit"
    Then I should see the administrators edit page for the order

  Scenario: Edit an Order
    Given I am an authenticated administrator
    And I have "1" order
    When I go to the administrator order page for order 1
    And I select "Shipped" from "order[OrdersStatus_ID]"
    And I fill in "123456" for "order[ShipmentTracking]"
    And I select "UPS" from "order[ShippingMethod_ID]"
    And I fill in "01/17/2012" for "order[DeliveryDate]"
    And I press "save"
    Then I should be on the administrator orders page


