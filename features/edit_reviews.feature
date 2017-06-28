@twitter_user
Feature: Edit JulySoundcheck Reviews
  Background:
    Given I am signed in

  Scenario: Create review from tweet
    Given I have a JulySoundcheck tweet with rating
    And I visit the home page
    When I edit the tweet
    And I add the review details to the tweet
    And I create the tweet review
    Then I see the added review details to the tweet

  Scenario: Update review
    Given I have a JulySoundcheck tweet review
    And I visit the home page
    When I edit the tweet review
    And I set the genre to "Indie Rock/Noise Pop"
    And I save the tweet review
    Then I see the tweet review with a genre "Indie Rock/Noise Pop"

  @vcr
  Scenario: Sync a new review
    Given I have a JulySoundcheck tweet with rating
    And a JulySoundcheck Google spreadsheet exists
    And I visit the home page
    When I edit the tweet
    And I add the review details to the tweet
    And I create and sync the tweet review
    Then I see the added review details to the tweet
    And I see the review was created and synced
    And the tweet review is added to the spreadsheet

  @vcr
  Scenario: Sync an existing review
    Given I have a JulySoundcheck tweet review
    And a JulySoundcheck Google spreadsheet exists
    And my tweet review is synced to the spreadsheet
    And I visit the home page
    When I edit the tweet review
    And I set the genre to "Indie Rock/Noise Pop"
    And I save and sync the tweet review
    Then I see the tweet review with a genre "Indie Rock/Noise Pop"
    And I see the review was updated and synced
    And the tweet review was updated to the spreadsheet
