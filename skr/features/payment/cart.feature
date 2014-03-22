# language: en
Feature: View the cart
  In order to buy product I add product in to cart
  As a authorized user and a not authenticated user
  I want to see a list of items in the cart

  Scenario: View empty cart page
    When I go to the cart page
    Then I should see empty cart

#-------------------------
# Process of adding items to buy for himself
#-------------------------

# How not authenticated user
  @javascript
  Scenario: Add 1 product to cart for buy how not authenticated user
		Given I have "1" product in cart how "buyer" for buy
		Then I should be on "Cart"
		And I should see "1" item in my cart
	
  @javascript
  Scenario: Add 3 products to cart for buy how not authenticated user
		Given I have "3" products in cart how "buyer" for buy
		Then I should be on "Cart"
		And I should see "3" items in my cart	

# How authorized user
  @javascript
  Scenario: Add 1 product to cart for buy how authorized user
		Given I have "1" product in cart how "registrant" for buy
		Then I should be on "Cart"
		And I should see "1" item in my cart
	
  @javascript
  Scenario: Add 2 products to cart for buy how authorized user
		Given I have "2" products in cart how "registrant" for buy	
		Then I should be on "Cart"
		And I should see "2" items in my cart

#-------------------------
# Process of adding items to buy for someone
#-------------------------

# How not authenticated user
  @javascript
  Scenario: Add 1 product to cart from item page for buy to someone how not authenticated user
		Given I have "1" product in cart how "buyer" for "buy" to someone from the "item" page
		Then I should be on "Cart"
		And I should see "1" item in my cart

  @javascript
  Scenario: Add 2 products to cart from item page for buy to someone how not authenticated user
		Given I have "2" products in cart how "buyer" for "buy" to someone from the "item" page
		Then I should be on "Cart"
		And I should see "2" items in my cart

  @javascript
  Scenario: Add 1 product to cart for buy to someone how not authenticated user
		Given I have "1" product in cart how "buyer" for "buy" to someone from the "registry" page
		Then I should be on "Cart"
		And I should see "1" item in my cart

  @javascript
  Scenario: Add 2 products to cart from registry page for buy to someone how not authenticated user
		Given I have "2" products in cart how "buyer" for "buy" to someone from the "registry" page
		Then I should be on "Cart"
		And I should see "2" items in my cart

# How authorized user
  @javascript
  Scenario: Add 1 product to cart for buy to someone how authorized user
		Given I have "1" product in cart how "registrant" for "buy" to someone from the "item" page
		Then I should be on "Cart"
		And I should see "1" item in my cart

  @javascript
  Scenario: Add 2 products to cart for buy to someone how authorized user
		Given I have "2" products in cart how "registrant" for "buy" to someone from the "item" page
		Then I should be on "Cart"
		And I should see "2" items in my cart

  @javascript
  Scenario: Add 1 product to cart for buy to someone how authorized user
		Given I have "1" product in cart how "registrant" for "buy" to someone from the "registry" page
		Then I should be on "Cart"
		And I should see "1" item in my cart

  @javascript
  Scenario: Add 2 products to cart for buy to someone how authorized user
		Given I have "2" products in cart how "registrant" for "buy" to someone from the "registry" page
		Then I should be on "Cart"
		And I should see "2" items in my cart

#-------------------------
# Process of adding items to contribute and buy for someone
#-------------------------

# How not authenticated user
  @javascript
  Scenario: Add 2 products to cart for contribute and buy to someone how not authenticated user from item page
		Given I have two products in cart how "buyer" for buy and contribute to someone from the "item" page
		Then I should be on "Cart"
		And I should see "2" items in my cart

  @javascript
  Scenario: Add 2 products to cart for contribute and buy to someone how not authenticated user from registry page
		Given I have two products in cart how "buyer" for buy and contribute to someone from the "registry" page
		Then I should be on "Cart"
		And I should see "2" items in my cart

# How authorized user
  @javascript
  Scenario: Add 2 products to cart for contribute and buy to someone how authorized user from item page
		Given I have two products in cart how "registrant" for buy and contribute to someone from the "item" page
		Then I should be on "Cart"
		And I should see "2" items in my cart

  @javascript
  Scenario: Add 2 products to cart for contribute and buy to someone how authorized user from registry page
		Given I have two products in cart how "registrant" for buy and contribute to someone from the "registry" page
		Then I should be on "Cart"
  	    And I should see "2" items in my cart

#-------------------------
# Process of adding items to buy from manage registry
#-------------------------

  @javascript
  Scenario: Add 1 product to cart from manage registry for buy
		Given I have "1" "available" product in cart how "registrant" from manage registry for "buy"
		Then I should be on "Cart"
  	And I should see "1" item in my cart

  @javascript
  Scenario: Add 2 products to cart from manage registry for buy
		Given I have "2" "available" products in cart how "registrant" from manage registry for "buy"
		Then I should be on "Cart"
  	And I should see "2" items in my cart

#-------------------------
# Process withdraw cash from items to buy from manage registry
#-------------------------
  @javascript
  Scenario: Withdraw cash from 1 product
		Given I have "1" "purchased" product in cart how "registrant" from manage registry for "withdraw"
		Then I should be on "Cart"
		And I should see "1" item in my cart
		And I should see "$10"

  @javascript
  Scenario: Withdraw cash from 2 producs
		Given I have "2" "purchased" products in cart how "registrant" from manage registry for "withdraw"
		Then I should be on "Cart"
		And I should see "1" item in my cart
		And I should see "$20"

#-------------------------
# The process of verification of non-add to the cart of different types of operation
#-------------------------	

#-------------------------
# Buy and contribute for someone
#-------------------------

# How not authenticated user
  @javascript
  Scenario: View error message when we trying to buy the item for someone from item page, but in the cart already have an item for himself how not authenticated user
		Given I am an authenticated registrant
		And I have "1" "available" "catalogue" gift in my registry with names how "registrant"
		When I sign out
		And I wait for "1" seconds
		Given I have "1" product in cart how "buyer" for buy
		When I visit the registry page
		And I follow "MY PRODUCT (0)"
		And I wait for "2" seconds
		And I press button "BUY"
		And I wait until all Ajax requests are complete
		And I wait for "1" seconds
		Then I should see "requests unfortunately cannot be handled simultaneously. Please remove some requests in your cart so that we can process your order." in frame "ifr-popup"	
		
  @javascript
  Scenario: View error message when we trying to contribute the item for someone from item page, but in the cart already have an item for himself how not authenticated user
		Given I am an authenticated registrant
		And I have "1" "available" "catalogue" gift in my registry with names how "registrant"
		When I sign out
		And I wait for "1" seconds
		Given I have "1" product in cart how "buyer" for buy
		When I visit the registry page
		And I follow "MY PRODUCT (0)"
		And I wait for "2" seconds
		And I press button "BUY"
		And I wait until all Ajax requests are complete
		And I wait for "1" seconds
		Then I should see "requests unfortunately cannot be handled simultaneously. Please remove some requests in your cart so that we can process your order." in frame "ifr-popup"
	
  @javascript
  Scenario: View error message when we trying to buy the item for someone from registry page, but in the cart already have an item for himself how not authenticated user
		Given I am an authenticated registrant
		And I have "1" "available" "catalogue" gift in my registry with names how "registrant"
		When I sign out
		And I wait for "1" seconds
		Given I have "1" product in cart how "buyer" for buy
		When I visit the registry page
		And I press button "BUY" on the registry page
		And I wait until all Ajax requests are complete
		And I wait for "1" seconds
		Then I should see "requests unfortunately cannot be handled simultaneously. Please remove some requests in your cart so that we can process your order." in frame "ifr-popup"	

  @javascript
  Scenario: View error message when we trying to contribute the item for someone from registry page, but in the cart already have an item for himself how not authenticated user
		Given I am an authenticated registrant
		And I have "1" "available" "catalogue" gift in my registry with names how "registrant"
		When I sign out
		And I wait for "1" seconds
		Given I have "1" product in cart how "buyer" for buy
		When I visit the registry page
		And I press button "BUY" on the registry page
		And I wait until all Ajax requests are complete
		And I wait for "1" seconds
		Then I should see "requests unfortunately cannot be handled simultaneously. Please remove some requests in your cart so that we can process your order." in frame "ifr-popup"
	
# How authorized user

# when buy
  @javascript
  Scenario: View error message when we trying to buy the item for someone from item page, but in the cart already have an item for himself how authorized user
		Given I am an authenticated registrant
		And I have "1" "available" "catalogue" gift in my registry with names how "registrant"
		When I sign out
		And I wait for "1" seconds
		Given I have "1" product in cart how "registrant giver" for buy
		When I visit the registry page
		And I follow "MY PRODUCT (0)"
		And I wait for "2" seconds
		And I press button "BUY"
		And I wait until all Ajax requests are complete
		And I wait for "1" seconds
		Then I should see "requests unfortunately cannot be handled simultaneously. Please remove some requests in your cart so that we can process your order." in frame "ifr-popup"	

  @javascript
  Scenario: View error message when we trying to contribute the item for someone from item page, but in the cart already have an item for himself how authorized user
		Given I am an authenticated registrant
		And I have "1" "available" "catalogue" gift in my registry with names how "registrant"
		When I sign out
		And I wait for "1" seconds
		Given I have "1" product in cart how "registrant giver" for buy
		When I visit the registry page
		And I follow "MY PRODUCT (0)"
		And I wait for "2" seconds
		And I press button "BUY"
		And I wait until all Ajax requests are complete
		And I wait for "1" seconds
		Then I should see "requests unfortunately cannot be handled simultaneously. Please remove some requests in your cart so that we can process your order." in frame "ifr-popup"

  @javascript
  Scenario: View error message when we trying to buy the item for someone from registry page, but in the cart already have an item for himself how authorized user
		Given I am an authenticated registrant
		And I have "1" "available" "catalogue" gift in my registry with names how "registrant"
		When I sign out
		And I wait for "1" seconds
		Given I have "1" product in cart how "registrant giver" for buy
		When I visit the registry page
		And I press button "BUY" on the registry page
		And I wait until all Ajax requests are complete
		And I wait for "1" seconds
		Then I should see "requests unfortunately cannot be handled simultaneously. Please remove some requests in your cart so that we can process your order." in frame "ifr-popup"	

  @javascript
  Scenario: View error message when we trying to contribute the item for someone from registry page, but in the cart already have an item for himself how authorized user
		Given I am an authenticated registrant
		And I have "1" "available" "catalogue" gift in my registry with names how "registrant"
		When I sign out
		And I wait for "1" seconds
		Given I have "1" product in cart how "registrant giver" for buy
		When I visit the registry page
		And I press button "BUY" on the registry page
		And I wait until all Ajax requests are complete
		And I wait for "1" seconds
		Then I should see "requests unfortunately cannot be handled simultaneously. Please remove some requests in your cart so that we can process your order." in frame "ifr-popup"	

# when withdraw
  @javascript
  Scenario: View error message when we trying to buy the item for someone from item page, but in the cart already have an item for withdraw how authorized user
		Given I am an authenticated registrant
		And I have "1" "available" "catalogue" gift in my registry with names how "registrant"
		When I sign out
		And I wait for "1" seconds
		Given I have "1" "purchased" product in cart how "registrant giver" from manage registry for "withdraw"
		When I visit the registry page
		And I follow "MY PRODUCT (0)"
		And I wait for "2" seconds
		And I press button "BUY"
		And I wait until all Ajax requests are complete
		And I wait for "1" seconds
		Then I should see "requests unfortunately cannot be handled simultaneously. Please remove some requests in your cart so that we can process your order." in frame "ifr-popup"
	
  @javascript
  Scenario: View error message when we trying to contribute the item for someone from item page, but in the cart already have an item for withdraw how authorized user
		Given I am an authenticated registrant
		And I have "1" "available" "catalogue" gift in my registry with names how "registrant"
		When I sign out
		And I wait for "1" seconds
		Given I have "1" "purchased" product in cart how "registrant giver" from manage registry for "withdraw"
		When I visit the registry page
		And I follow "MY PRODUCT (0)"
		And I wait for "2" seconds
		And I press button "BUY"
		And I wait until all Ajax requests are complete
		And I wait for "1" seconds
		Then I should see "requests unfortunately cannot be handled simultaneously. Please remove some requests in your cart so that we can process your order." in frame "ifr-popup"

  @javascript
  Scenario: View error message when we trying to buy the item for someone from registry page, but in the cart already have an item for withdraw how authorized user
		Given I am an authenticated registrant
		And I have "1" "available" "catalogue" gift in my registry with names how "registrant"
		When I sign out
		And I wait for "1" seconds
		Given I have "1" "purchased" product in cart how "registrant giver" from manage registry for "withdraw"
		When I visit the registry page
		And I press button "BUY" on the registry page
		And I wait until all Ajax requests are complete
		And I wait for "1" seconds
		Then I should see "requests unfortunately cannot be handled simultaneously. Please remove some requests in your cart so that we can process your order." in frame "ifr-popup"	

  @javascript
  Scenario: View error message when we trying to contribute the item for someone from registry page, but in the cart already have an item for withdraw how authorized user
		Given I am an authenticated registrant
		And I have "1" "available" "catalogue" gift in my registry with names how "registrant"
		When I sign out
		And I wait for "1" seconds
		Given I have "1" "purchased" product in cart how "registrant giver" from manage registry for "withdraw"
		When I visit the registry page
		And I press button "BUY" on the registry page
		And I wait until all Ajax requests are complete
		And I wait for "1" seconds
		Then I should see "requests unfortunately cannot be handled simultaneously. Please remove some requests in your cart so that we can process your order." in frame "ifr-popup"	
	
#-------------------------
# Buy for himself
#-------------------------

# How not authenticated user
  @javascript
  Scenario: View error message when we trying to buy the item for himself, but in the cart already have an item to buy for someone how not authenticated user
		Given I have "1" product in cart how "buyer" for "buy" to someone from the "item" page
		Given I have a product named "MY PRODUCT"
		When I go to the catalog page
		And I follow "MY PRODUCT"
		And I wait for "1" seconds
		And I press button "BUY"
		And I wait until all Ajax requests are complete
		And I wait for "1" seconds
		Then I should see "requests unfortunately cannot be handled simultaneously. Please remove some requests in your cart so that we can process your order." in frame "ifr-popup"	

  @javascript
  Scenario: View error message when we trying to buy the item for himself, but in the cart already have an item to contribute for someone how not authenticated user
		Given I have "1" product in cart how "buyer" for "contribute" to someone from the "item" page
		Given I have a product named "MY PRODUCT"
		When I go to the catalog page
		And I follow "MY PRODUCT"
		And I wait for "1" seconds
		And I press button "BUY"
		And I wait until all Ajax requests are complete
		And I wait for "1" seconds
		Then I should see "requests unfortunately cannot be handled simultaneously. Please remove some requests in your cart so that we can process your order." in frame "ifr-popup"
	
# How authorized user	

#when buy to someone
  @javascript
  Scenario: View error message when we trying to buy the item for himself, but in the cart already have an item to buy for someone how authorized user
		Given I have "1" product in cart how "registrant" for "buy" to someone from the "item" page
		Given I have a product named "MY PRODUCT"
		When I go to the catalog page
		And I follow "MY PRODUCT"
		And I wait for "1" seconds
		And I press button "BUY"
		And I wait until all Ajax requests are complete
		And I wait for "1" seconds
		Then I should see "requests unfortunately cannot be handled simultaneously. Please remove some requests in your cart so that we can process your order." in frame "ifr-popup"	

  @javascript
  Scenario: View error message when we trying to buy the item for himself, but in the cart already have an item to contribute for someone how authorized user
		Given I have "1" product in cart how "registrant" for "contribute" to someone from the "item" page
		Given I have a product named "MY PRODUCT"
		When I go to the catalog page
		And I follow "MY PRODUCT"
		And I wait for "1" seconds
		And I press button "BUY"
		And I wait until all Ajax requests are complete
		And I wait for "1" seconds
		Then I should see "requests unfortunately cannot be handled simultaneously. Please remove some requests in your cart so that we can process your order." in frame "ifr-popup"
	
#when withdraw	
  @javascript
  Scenario: View error message when we trying to buy the item for himself, but in the cart already have an item for withdraw how authorized user
		Given I have "1" "purchased" product in cart how "registrant" from manage registry for "withdraw"
		Given I have a product named "MY PRODUCT"
		When I go to the catalog page
		And I follow "MY PRODUCT"
		And I wait for "1" seconds
		And I press button "BUY"
		And I wait until all Ajax requests are complete
		And I wait for "1" seconds
		Then I should see "requests unfortunately cannot be handled simultaneously. Please remove some requests in your cart so that we can process your order." in frame "ifr-popup"	
	
#-------------------------
# Withdraw cash
#-------------------------

#when buy to someone
  @javascript
  Scenario: View error message when we trying to withdraw money from the item, but in the cart already have an item to buy for someone
		Given I have "1" product in cart how "registrant" for "buy" to someone from the "item" page
		And I wait for "1" seconds
		And I have "1" "purchased" "catalogue" gift in my registry with names how "registrant giver"
		When I go to the manage_registry page
		And I wait for "1" seconds
		And I click "Exchange For Cash" for product "MY PRODUCT (0)"
		And I wait for "1" seconds
		Then I should see "requests unfortunately cannot be handled simultaneously. Please remove some requests in your cart so that we can process your order." in frame "ifr-popupBuy"
	
  @javascript
  Scenario: View error message when we trying to withdraw money from the item, but in the cart already have an item to contribute for someone
		Given I have "1" product in cart how "registrant" for "contribute" to someone from the "item" page
		And I wait for "1" seconds
		And I have "1" "purchased" "catalogue" gift in my registry with names how "registrant giver"
		When I go to the manage_registry page
		And I wait for "1" seconds
		And I click "Exchange For Cash" for product "MY PRODUCT (0)"
		Then I should see "requests unfortunately cannot be handled simultaneously. Please remove some requests in your cart so that we can process your order." in frame "ifr-popupBuy"
	
#when buy to himself	

  @javascript
  Scenario: View error message when we trying to withdraw money from the item, but in the cart already have an item to buy for himself
		Given I have "1" product in cart how "registrant" for buy
		And I wait for "1" seconds
		And I have "1" "purchased" "catalogue" gift in my registry with names how "registrant"
		When I go to the manage_registry page
		And I wait for "1" seconds
		And I click "Exchange For Cash" for product "MY PRODUCT (0)"
		Then I should see "requests unfortunately cannot be handled simultaneously. Please remove some requests in your cart so that we can process your order." in frame "ifr-popupBuy"
	
#-------------------------
# Delete form cart
#-------------------------	
#buy to himself
  @javascript
  Scenario: Delete 2 products from cart for buy how not authenticated user
		Given I have "2" products in cart how "buyer" for buy
		Then I should be on "Cart"
	  And I should see "2" items in my cart
		When I click "DELETE ITEM" for item "MY PRODUCT (0)"
		And I should see "1" item in my cart
		When I click "DELETE ITEM" for item "MY PRODUCT (1)"
		Then I should see empty cart

  @javascript
  Scenario: Delete 2 products from cart for buy how authorized user
		Given I have "2" products in cart how "registrant" for buy
		Then I should be on "Cart"
	  And I should see "2" items in my cart
		When I click "DELETE ITEM" for item "MY PRODUCT (0)"
		And I should see "1" item in my cart
		When I click "DELETE ITEM" for item "MY PRODUCT (1)"
		Then I should see empty cart

#buy to someone	
  @javascript
  Scenario: Delete 2 products to cart for buy to someone how not authenticated user
    Given I have "2" products in cart how "buyer" for "buy" to someone from the "item" page
    Then I should be on "Cart"
    And I should see "2" items in my cart
    When I click "DELETE ITEM" for item "Test product 1"
    And I should see "1" item in my cart
    When I click "DELETE ITEM" for item "Test product 2"
    Then I should see empty cart

  @javascript
  Scenario: Delete 2 products to cart for contribute to someone how not authenticated user
		Given I have "2" products in cart how "buyer" for "contribute" to someone from the "item" page
		Then I should be on "Cart"
	  And I should see "2" items in my cart
		When I click "DELETE ITEM" for item "Test product 1"
		And I should see "1" item in my cart
		When I click "DELETE ITEM" for item "Test product 2"
		Then I should see empty cart
	
  @javascript
  Scenario: Delete 2 products to cart for buy to someone how authorized user
		Given I have "2" products in cart how "registrant" for "buy" to someone from the "item" page
		Then I should be on "Cart"
	  And I should see "2" items in my cart
		When I click "DELETE ITEM" for item "Test product 1"
		And I should see "1" item in my cart
		When I click "DELETE ITEM" for item "Test product 2"
		Then I should see empty cart	

  @javascript
  Scenario: Delete 2 products to cart for contribute to someone how authorized user
		Given I have "2" products in cart how "registrant" for "contribute" to someone from the "item" page
		Then I should be on "Cart"
	  And I should see "2" items in my cart
		When I click "DELETE ITEM" for item "Test product 1"
		And I should see "1" item in my cart
		When I click "DELETE ITEM" for item "Test product 2"
		Then I should see empty cart	
	
#withdraw cash	

  @javascript
  Scenario: Delete 2 products to cart from manage registry for buy
		Given I have "2" "available" products in cart how "registrant" from manage registry for "buy"
		Then I should be on "Cart"
		And I should see "2" items in my cart
		When I click "DELETE ITEM" for item "MY PRODUCT (0)"
		And I should see "1" item in my cart
		When I click "DELETE ITEM" for item "MY PRODUCT (1)"
		Then I should see empty cart

  @javascript
  Scenario: Delete Withdraw cash from 2 producs
		Given I have "2" "purchased" products in cart how "registrant" from manage registry for "withdraw"
		Then I should be on "Cart"
		And I should see "1" item in my cart
		And I should see "$20"
		When I click "DELETE ITEM" for item "Withdraw cash"
		Then I should see empty cart	
	
#-------------------------
# Empty cart
#-------------------------	

#buy to himself
  @javascript
  Scenario: Empty cart 2 products from cart for buy how not authenticated user
		Given I have "2" products in cart how "buyer" for buy
		Then I should be on "Cart"
	  And I should see "2" items in my cart
		When I press button "EMPTY CART"
		Then I should see empty cart
	
  @javascript
  Scenario: Empty cart 2 products from cart for buy how authorized user
		Given I have "2" products in cart how "registrant" for buy
		Then I should be on "Cart"
	  And I should see "2" items in my cart
		When I press button "EMPTY CART"
		Then I should see empty cart
	
#buy to someone	
  @javascript
  Scenario: Empty cart 2 products to cart for buy to someone how not authenticated user
		Given I have "2" products in cart how "buyer" for "buy" to someone from the "item" page
		Then I should be on "Cart"
	  And I should see "2" items in my cart
		When I press button "EMPTY CART"
		Then I should see empty cart	

  @javascript
  Scenario: Empty cart 2 products to cart for contribute to someone how not authenticated user
		Given I have "2" products in cart how "buyer" for "contribute" to someone from the "item" page
		Then I should be on "Cart"
	  And I should see "2" items in my cart
		When I press button "EMPTY CART"
		Then I should see empty cart

  @javascript
  Scenario: Empty cart 2 products to cart for buy to someone how authorized user
		Given I have "2" products in cart how "registrant" for "buy" to someone from the "item" page
		Then I should be on "Cart"
	  And I should see "2" items in my cart
		When I press button "EMPTY CART"
		Then I should see empty cart	

  @javascript
  Scenario: Empty cart 2 products to cart for contribute to someone how authorized user
		Given I have "2" products in cart how "registrant" for "contribute" to someone from the "item" page
		Then I should be on "Cart"
	  And I should see "2" items in my cart
		When I press button "EMPTY CART"
		Then I should see empty cart	

#withdraw cash	

  @javascript
  Scenario: Empty cart 2 products to cart from manage registry for buy
		Given I have "2" "available" products in cart how "registrant" from manage registry for "buy"
		Then I should be on "Cart"
		And I should see "2" items in my cart
		When I press button "EMPTY CART"
		Then I should see empty cart

  @javascript
  Scenario: Empty cart Withdraw cash from 2 producs
		Given I have "2" "purchased" products in cart how "registrant" from manage registry for "withdraw"
		Then I should be on "Cart"
		And I should see "1" item in my cart
		And I should see "$20"
		When I press button "EMPTY CART"
		Then I should see empty cart