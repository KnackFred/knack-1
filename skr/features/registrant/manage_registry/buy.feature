# language: en
Feature: Buy an item in my registry
  If I did not receive something I really wanted
  As a registrant
  I want to buy an available item from my registry

  @javascript
  Scenario: buy an available catalogue item
    Given I am an authenticated registrant
    And I have a "available" "catalogue" gift in my registry with quantity "2"
    When I go to the manage_registry page
    And I buy the first item in my registry
    Then I should see an item in my cart with quantity "2"

  @javascript
  Scenario: Change Quantity as I buy the item
    Given I am an authenticated registrant
    And I have a "available" "catalogue" gift in my registry with quantity "2"
    When I go to the manage_registry page
    And I buy "10" of the first item in my registry
    Then I should see an item in my cart with quantity "10"

  @javascript
  Scenario: view variants when buying an item
    Given I am an authenticated registrant
    And I have an "available" gift in my registry with a variant named "Stuff" and value "foo" of "bar,foo,bat"
    When I go to the manage_registry page
    And I follow "Buy"
    Then I should see "Stuff" in frame "ifr-popupBuy"
    And I should see "foo" in frame "ifr-popupBuy"



