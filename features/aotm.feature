Feature: Album Of The Month

  Background:
    Given I am signed in through Twitter

  Scenario: Mark review as Album of the Month
    Given I have a JulySoundcheck tweet review
    And I visit the home page
    When I edit the tweet review
    And I set as Album of the Month
    And I save the tweet review
    Then I see the review was updated
    And I see the tweet review is Album of the Month

  Scenario: Filter Album of the Month reviews
    Given I have an Album of the Month review
    And a review exists with a 3 rating
    And a review exists with a 2- rating
    And I visit the home page
    When I filter "AOTM" reviews
    Then I only see Album of the Month reviews
