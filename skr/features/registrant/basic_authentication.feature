# language: en
Feature: Basic Authentication
  In order to ensure that no one else can mess with my registry
  And for the system to know who I am
  As a Registrant
  I want to be able to log in as a user.


  Scenario: sign in
    Given I am a registered user with email "user@test.com" and password "swordfish"
    When I go to the signin page
    And I enter the credentials: email "user@test.com" and password "swordfish"
    Then I should be on the manage_registry page

  Scenario: sign out
    Given I am an authenticated registrant
    When I go to the signout page
    Then I should be on the home page
    And I should see "Sign In"

  Scenario: sign in to a specific page after being redirected to the login page.
    Given I am a registered user with email "user@test.com" and password "swordfish"
    When I go to the links page
    Then I should be on the signin page
    When I enter the credentials: email "user@test.com" and password "swordfish"
    Then I should be on the links page

  Scenario: forgot password with correct email
    Given I am a registered user with email "example@example.com" and password "swordfish"
    When I go to the Forgot Password page
    And I fill in "registrant_Email" with "example@example.com"
    And I press "Submit"
    Then I should be on the Forgot Password page
    And I should see "Instructions for resetting your password have been sent to example@example.com"
    #And I should receive an email
    #When I open the email with subject "Reset password"
    #And I follow "Reset Password" in the email
    #Then I should be on "Forgot Password"
    #And I should see "Your Password has been reset"

  Scenario: forgot password with invalid email
    Given I am a registered user with email "example@example.com" and password "swordfish"
    When I go to the Forgot Password page
    And I fill in "registrant_Email" with "fake@fake.com"
    And I press "Submit"
    Then I should be on the Forgot Password page
    And I should see "No matching email address was found"

  Scenario: forgot password with facebook email
    Given I am a registered facebook user with email "example@example.com"
    When I go to the Forgot Password page
    And I fill in "registrant_Email" with "example@example.com"
    And I press "Submit"
    Then I should be on the Forgot Password page
    And I should see "This email belongs to a Facebook account"

  Scenario: sign in fails
    Given I am a registered user with email "user@test.com" and password "swordfish"
    When I go to the signin page
    And I enter the credentials: email "WRONG" and password "WRONG"
    Then I should be on the signin page
    And I should see "Invalid login or password"

  Scenario: system warns facebook user if they attempt to log-in with the standard form
    Given I am a registered facebook user with email "test@testuser.com"
    When I go to the signin page
    And I enter the credentials: email "test@testuser.com" and password "WRONG"
    Then I should be on the signin page
    And I should see "Please log-in using the Facebook log-in button."

  Scenario: Users should be taken to the invite_friends page if they have not seen it yet
    Given I am a new user who has not seen the invite friends page
    When I log in
    Then I should be on the invite_friends page
    When I log out
    And I log in
    Then I should be on the manage_registry page

#MISSING: Remember me
#MISSING: Facebook Login
#MISSING: Login through form with facebook credentials



