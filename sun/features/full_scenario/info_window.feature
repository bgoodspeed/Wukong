@needs_full_gosu
Feature: Info Window
  In order to explain goals
  As a player
  I want to see an info window about any event areas

  Scenario: Player outside area
    Given I load the game "new_game_load_screen"
    When I run the game loop 1 times
    Then the game property "player.position" should be "GVector.xy(320, 240)"
    Then there should be 0 active event areas

  Scenario: Player in area
    Given I load the game "new_game_load_screen"
    And I set the player position to 50,50
    When I run the game loop 1 times
    Then there should be 1 active event areas
    And the event area info window description should contain "foo bar"
    And the event area info window position should be nil
    And the event area info window description should contain "baz quz"
    And the event area info window description should contain "afterblank"

  Scenario: Player in area 2
    Given I load the game "new_game_load_screen"
    And I set the player position to 400,100
    When I run the game loop 1 times
    Then there should be 1 active event areas
    And the event area info window description should contain "monkeys"
    And the event area info window position should be "[1,2]"

  Scenario: Images in info windows Unspecified
    Given I load the game "new_game_load_screen"
    And I set the player position to 400,100
    When I run the game loop 1 times
    Then there should be 1 active event areas
    And the event area info window images size should be "0"

  Scenario: Images in info windows Specified
    Given I load the game "with_images"
    And I set the player position to 400,100
    When I run the game loop 1 times
    Then there should be 1 active event areas
    And the event area info window images size should be "1"

  Scenario: Game Formattable Info Window Labels Line 1
    Given I load the game on level "info_window_formatting" with screen size 640, 480
    And I set the player position to 50,50
    When I run the game loop 1 times
    Then there should be 1 active event areas
    Then the game property "level.event_areas.first.info_window.descriptions_formatted.first" should be "'640,480,1'"
    When I run the game loop 1 times
    Then the game property "level.event_areas.first.info_window.descriptions_formatted.first" should be "'640,480,2'"

  Scenario: Game Formattable Info Window Labels Line 2
    Given I load the game on level "info_window_formatting" with screen size 640, 480
    And I mark the level "a" as completed
    And I set the player position to 50,50
    When I run the game loop 1 times
    Then there should be 1 active event areas
    Then the game property "level.event_areas.first.info_window.descriptions_formatted.last" should be "'a:completed,b:available,c:closed'"
    And I mark the level "b" as completed
    Then the game property "level.event_areas.first.info_window.descriptions_formatted.last" should be "'a:completed,b:completed,c:available'"


  Scenario: Info Window Validation
    Given I create a valid info window
    Then the info window should be valid

  Scenario Outline: Info Window Validation - Requirements
    Given I create a valid info window
    When I unset the info window property "<property>"
    Then the info window should not be valid
  Examples:
    | property     |
    | description |
