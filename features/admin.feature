@admin_twitter_user
Feature: Administrator

  Background:
    Given I am signed in as admin through Twitter
    And a non-admin user exists

  Scenario: Admin creates review from tweet
    Given a JulySoundcheck tweet with rating exists from a different user
    And I visit the home page
    When I edit the tweet
    And I add the review details to the tweet
    And I create the tweet review
    Then I see the added review details to the tweet
    And I see the original user on the tweet review

  Scenario: Admin updates review
    Given a JulySoundcheck tweet review exists from a different user
    And I visit the home page
    When I edit the tweet review
    And I set the genre to "Indie Rock/Noise Pop"
    And I save the tweet review
    Then I see the tweet review with a genre "Indie Rock/Noise Pop"
    And I see the original user on the tweet review
