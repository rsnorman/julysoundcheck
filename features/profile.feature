Feature: View profile

  Scenario: Viewing profile with Twitter
    Given a user exists with a Twitter account
    And the user has a review
    And the user has a tweet review
    And the user has a tweet
    And a review exists from another user
    When I visit the user's profile page
    Then I see their recent reviews and tweets
    And I see they have "2" reviews
    And I see they have an average rating of "2"
    And I see they have a review streak of "1"
    And I see a link to their Twitter profile
    But I don't see other user's reviews

  Scenario: View profile not hooked into Twitter
    Given a user exists without a Twitter account
    And the user has a review
    And a review exists from another user
    When I visit the user's profile page
    Then I see their recent reviews
    And I see they have "1" review
    And I see they have an average rating of "1"
    And I see they have a review streak of "1"
    And I don't see a link to their Twitter profile
    But I don't see other user's reviews

  Scenario: View profile for uncreated user
    When I visit a profile for a non-user
    Then I see no recent reviews for the user
    And I see they have "0" reviews
    And I see they have an average rating of "N/A"
    And I see they have a review streak of "0"

  Scenario: Viewing second page
    Given a user exists with a Twitter account
    And the user has second page of feed items
    When I visit the user's profile page
    And I click "2" in the profile pagination links
    Then I see the second page of user's tweets
