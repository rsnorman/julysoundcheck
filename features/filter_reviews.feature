Feature: Filtering reviews

  Background:
    Given a review exists with a 3 rating
    And a review exists with a 2- rating
    And a review exists with a 1+ rating
    And a review exists with a 0 rating
    And I am signed in through Twitter
    And I visit the home page

  Scenario: Filtering essential reviews
    When I filter "Essential" reviews
    Then I only see reviews with "Essential" ratings

  Scenario: Filtering multiple listen reviews
    When I filter "Multiple Listens" reviews
    Then I only see reviews with "Multiple Listens" ratings

  Scenario: Filtering listen once reviews
    When I filter "Listen Once" reviews
    Then I only see reviews with "Listen Once" ratings

  Scenario: Filtering unlistenable reviews
    When I filter "Unlistenable" reviews
    Then I only see reviews with "Unlistenable" ratings

  Scenario: Clearing filter
    Given I filter "Essential" reviews
    When I clear the filter
    Then I see all the reviews
