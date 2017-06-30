Feature: Login

  Scenario: Registering new user
    When I visit the home page
    And I click the Sign In button
    And I click to sign up
    And I register a new user
    And I click the profile button
    Then I see my profile page
    When I visit the settings page
    And I update my name
    And I click the profile button
    Then I see my profile page with name "Ryan Norman"
