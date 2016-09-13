Feature: View JulySoundcheck Reviews

  Scenario: No reviews yet
    When I visit the home page
    Then I see no reviews message

  Scenario: Viewing reviews, tweet reviews, and tweets
    Given a review exists
    When I visit the home page
    Then I see the review

  Scenario: Viewing reviews, tweet reviews, and tweets
    Given a review exists
    And a tweet review exists
    And a tweet exists
    When I visit the home page
    Then I see the review
    And I see the tweet review
    And I see the tweet

  Scenario: Logging in through Twitter
    When I visit the home page
    And I click the Twitter Sign In button
    And I login with my Twitter credentials
    Then I see my recent tweets

  Scenario: Viewing second page
    Given a second page of reviews exist
    When I visit the home page
    And I click "2" in the pagination links
    Then I see the second page of tweets
