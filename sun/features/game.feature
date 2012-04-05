Feature: Game
  In order to play the game
  As a player
  I want to be able to see myself in a level

  Scenario: Trivial Level
    Given I load the game on level "trivial" with screen size 640, 480
    When I see the first frame
    Then I should be at 36,36 in the game space

  Scenario: Full Game Loading
    Given I load the game "game"
    When I see the first frame
    Then I should be at 200,300 in the game space

  Scenario: New Game Loading Level
    Given I load the game "new_game_load_screen"
    When I see the first frame
    Then I should be at 320,240 in the game space
    And there should be 4 event areas
    And the event areas should be:
        | rectangle_to_s                                        | label          | action                      |
        | Rectangle [10, 10]:[10, 180]:[280, 180]:[280, 10]     | Start New Game | queue_start_new_game_event  |
        | Rectangle [360, 10]:[360, 180]:[630, 180]:[630, 10]   | Load Game      | queue_load_game_event       |
        | Rectangle [10, 280]:[10, 470]:[280, 470]:[280, 280]   | Settings       | queue_settings_event        |
        | Rectangle [360, 280]:[360, 470]:[630, 470]:[630, 280] | Continue       | queue_continue_event        |

  Scenario: New Game Loading Level Invoke Event Area - New Game
    Given I load the game "new_game_load_screen"
    And I set the player position to 100,100
    When I simulate "Gosu::KbO"
    When I run the game loop 1 times
    And a "StartNewGameEvent" event should be queued

  Scenario: New Game Loading Level Off Event Area
    Given I load the game "new_game_load_screen"
    And I set the player position to 320,240
    When I simulate "Gosu::KbO"
    When I run the game loop 1 times
    And there should be no events queued

  Scenario: New Game Loading Level Invoke Event Area - Load Game
    Given I load the game "new_game_load_screen"
    And I set the player position to 350,20
    When I simulate "Gosu::KbO"
    When I run the game loop 1 times
    And a "LoadGameEvent" event should be queued
