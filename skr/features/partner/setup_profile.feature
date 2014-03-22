# language: en
Feature: Partner profile.

  @javascript
  Scenario Outline: Setup partner profile (required fields)
    Given I am an authenticated partner
    When I go to the partner profile page
    And I fill in the following:
    | store_Name    		| <store_name>   			|
    | store_Street  		| <store_street> 			|
    | store_City    		| <store_city>   			|
    | store_ZIP     		| <store_zip>    			|
	| partner_BillingCity   | <billing_city>    		|
	| partner_BillingZIP   	| <billing_zip>     		|		
    When I select Alabama from store State select box
	And I select Alabama from partner State select box
#    And I attach the file "stocks/stock1.png" to "fuploadLogo"
    And I press "Save"
    Then I should be on <next_page>
    And I should see "<message>"

  Scenarios: All States and Types
    | store_name  | store_street   | store_city   | store_zip   | billing_city     | billing_zip    | next_page                | message                    	    |
    |            | First        | Benton     | 36785     | Benton		 | 36785	   | the partner profile page | can't be blank                  |
    | Partner    |              | Benton     | 36785     | Benton		 | 36785	   | the partner profile page | can't be blank                  |
    | Partner    | First        |            | 36785     | Benton		 | 36785	   | the partner profile page | can't be blank                  |
    | Partner    | First        | Benton     |           | Benton		 | 36785	   | the partner profile page | You must provide a valid ZIP    |
    | Partner    | First        | Benton     | abcde     | Benton		 | 36785	   | the partner profile page | You must provide a valid ZIP    |
    | Partner    | First        | Benton     | 3678      | Benton		 | 36785	   | the partner profile page | You must provide a valid ZIP    |
    | Partner    | First        | Benton     | (`</\>')  | Benton		 | 36785	   | the partner profile page | You must provide a valid ZIP    |
    | Partner    | First        | Benton     | 367851    | Benton		 | 36785	   | the partner profile page | You must provide a valid ZIP    |
    |            |              |            |           | Benton		 | 36785	   | the partner profile page | can't be blank                  |
    