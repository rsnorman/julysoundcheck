Feature: Recommendation callout

  Scenario: Review highlights recommendation
    Given a review exists that was recommended by someone else
    And I visit the home page
    When I click the the recommender's screen name on the review
    Then I see the recommender's profile

  Scenario: Tweet review highlights recommendation
    Given a tweet review exists that was recommended by someone else
    And I visit the home page
    When I click the the recommender's screen name on the tweet review
    Then I see the recommender's profile

  Scenario: Tweet highlights recommendation
    Given a tweet exists that was recommended by someone else
    And I visit the home page
    When I click the the recommender's screen name on the tweet
    Then I see the recommender's profile
