@vcr
Feature: Sync from worksheet

  Scenario: Syncs new review
    Given a JulySoundcheck Google spreadsheet exists
    And an unsynced review exists on the spreadsheet
    When I sync from Google spreadsheet
    And I visit the home page
    Then I see the newly downloaded review

  Scenario: Resyncs existing review
    Given a JulySoundcheck Google spreadsheet exists
    And a synced review exists on the spreadsheet
    And the synced review's genre is updated to "Black Shoegaze" on the spreadsheet
    When I sync from Google spreadsheet
    And I visit the home page
    Then I see the newly updated review's genre is "Black Shoegaze"
