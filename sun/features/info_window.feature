Feature: Info Window
  In order to explain goals
  As a player
  I want to see an info window about any event areas

  Scenario: Player outside area
    Given I load the game "new_game_load_screen"
    When I run the game loop 1 times
    Then the game property "player.position" should be "[320, 240]"
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

  Scenario: Player in area
    Given I load the game "new_game_load_screen"
    And I set the player position to 400,100
    When I run the game loop 1 times
    Then there should be 1 active event areas
    And the event area info window description should contain "monkeys"
    And the event area info window position should be "[1,2]"

    