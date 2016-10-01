Feature: Archives JulySoundcheck tweets

  @vcr @tweet_search
  Scenario: Downloads new JulySoundcheck tweets
    When I download new JulySoundcheck tweets
    And I visit the home page
    Then I see the newly downloaded tweet
