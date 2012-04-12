Feature: Loading
  In order to have continue my progress
  As a player
  I want to be able to load a saved game

  Scenario: New Game Loading Level Invoke Event Area - Load Game
    Given I load the game "new_game_load_screen"
    And I set the player position to 350,20
    When I simulate "Graphics::KbO"
    When I run the game loop 1 times
    Then the current menu entry should have:
      | display_text   | action         | argument |
      | Load Game 1    | load_game_slot | 1        |
    And I register a fake action to return triple the argument called "load_game_slot"
    When I invoke the current menu action
    Then the menu action result should be 3
    
  Scenario: Loading a game loads level, player etc
    Given I load the game "new_game_load_screen"
    Then the game property "level.name" should be "'load_screen'"
    Then the game property "player.position" should be "[320, 240]"
    And I load slot 1
    Then the game property "level.name" should be "'demo'"
    Then the game property "player.position" should be "[300, 200]"

  Scenario: Saving a game saves level, player etc
    Given I load the game "new_game_load_screen"
    And I set the property "game_load_path" to "test-data/loadarea"
    And I set the player position to 350,200
    And I save slot 8
    Then the save file should match "expected_savedata.yml"

    




