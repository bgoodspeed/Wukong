Feature: Loading
  In order to have continue my progress
  As a player
  I want to be able to load a saved game

  Scenario: New Game Loading Level Invoke Event Area - Load Game
    Given I load the game "new_game_load_screen"
    And I set the player position to 350,20
    When I simulate "Gosu::KbO"
    When I run the game loop 1 times
    Then the current menu entry should have:
      | display_text   | action         | argument |
      | Load Game 1    | load_game_slot | 1        |

    




