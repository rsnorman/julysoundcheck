Feature: Login

  @wip @vcr @mechanize @twitter_user
  Scenario: Logging in through Twitter
    Given I have 4 recent tweets
    When I visit the home page
    And I click the Twitter Sign In button
    And I login with my Twitter credentials
    Then I see my recent tweets
