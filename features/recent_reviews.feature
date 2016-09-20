Feature: View JulySoundcheck Reviews

  Scenario: No reviews yet
    When I visit the home page
    Then I see no reviews message

  Scenario: Viewing reviews, tweet reviews, and tweets
    Given a review exists
    And a review exists with no listen URL
    And a tweet review exists
    And a two-part tweet review exists
    And a tweet exists
    And a tweet exists with a review
    And a tweet exists with a reply
    When I visit the home page
    Then I see the review
    And I see the limited review
    And I see the tweet review
    And I see the two-part tweet review
    And I see the tweet
    And I see the tweet with a review
    And I see the tweet with a reply

  @vcr @mechanize
  Scenario: Logging in through Twitter
    Given I have 4 recent tweets
    When I visit the home page
    And I click the Twitter Sign In button
    And I login with my Twitter credentials
    Then I see my recent tweets

  Scenario: Viewing second page
    Given a second page of reviews exist
    When I visit the home page
    And I click "2" in the pagination links
    Then I see the second page of tweets
