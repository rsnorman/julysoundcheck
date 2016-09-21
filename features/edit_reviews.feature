Feature: Edit JulySoundcheck Reviews

  Scenario: Create review from tweet
    Given I am signed in through Twitter
    And I have a JulySoundcheck tweet with rating
    And I visit the home page
    When I edit the tweet
    And I add the review details to the tweet
    And I create the tweet review
    Then I see the added review details to the tweet

  Scenario: Update review

  Scenario: Sync review

  Scenario: Admin review edit
