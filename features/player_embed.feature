Feature: Embedding album players

  Scenario: Embedding Bandcamp album
    Given review exists with "Bandcamp" listen URL
    When I visit the home page
    Then I see the Bandcamp album embedded

  Scenario: Embedding Soundcloud album
    Given review exists with "Soundcloud" listen URL
    When I visit the home page
    Then I see the Soundcloud album embedded

  Scenario: Embedding Spotify album
    Given review exists with "Spotify" listen URL
    When I visit the home page
    Then I see the Spotify album embedded

  Scenario: Embedding Youtube album/playlist
    Given review exists with "Youtube" listen URL
    When I visit the home page
    Then I see the Youtube album embedded

  Scenario: Showing link with no embed
    Given review exists with unknown listen URL
    When I visit the home page
    Then I see the listen URL linked
