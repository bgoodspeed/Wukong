@needs_full_gosu
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
      | display_text   | action         | action_argument |
      | Load Game 1    | load_game_slot | 1               |
    And I register a fake action to return triple the argument called "load_game_slot"
    When I invoke the current menu action
    Then the menu action result should be 3
    
  Scenario: Loading a game loads level, player etc
    Given I load the game "new_game_load_screen"
    Given I set the temporary message to "foo"
    Then the game property "level.name" should be "'load_screen'"
    Then the game property "player.position.x" should be "320"
    Then the game property "player.position.y" should be "240"
    And I load slot 1
    Then the game property "level.name" should be "'demo'"
    Then the game property "player.position.x" should be "300"
    Then the game property "player.position.y" should be "200"
    And the animation position for player "weapon" should be 300, 200
    And the temporary message should be ""

  Scenario: Saving a game saves level, player etc - position
    Given I load the game "new_game_load_screen"
    And I set the property "game_load_path" to "test-data/loadarea"
    And I set the player position to 350,200
    And I save slot 8
    Then the save file should match "expected_savedata.yml"
    And the animation position for player "weapon" should be 350, 200

  Scenario: Saving a game saves level, player etc - inventory empty
    Given I load the game "new_game_load_screen"
    And I set the property "game_load_path" to "test-data/loadarea"
    And I set the player position to 350,200
    And I save slot 7
    Then the save file should match "expected_savedata_inventory.yml"
    And the animation position for player "weapon" should be 350, 200

  Scenario: Saving a game saves level, player etc - inventory non empty
    Given I load the game "demo_inventory"
    And I set the property "game_load_path" to "test-data/loadarea"
    When the player takes reward "test-data/equipment/weapon.yml"
    And I set the player position to 350,200
    And I save slot 6
    Then the save file should match "expected_savedata_inventory2.yml"
    And the animation position for player "weapon" should be 350, 200

  Scenario: Saving a game saves player animation
    Given I load the game "demo_inventory"
    And I load a player from "gd_load_player.yml"
    And I set the property "game_load_path" to "test-data/loadarea"
    And I save slot 5
    Then the save file should match "expected_savedata_animation.yml"

  Scenario: Loading a game loads player inventory - empty
    Given I load the game "demo_inventory"
    And I load slot 3
    Then the game property "player.inventory.items.size" should be "0"

  Scenario: Loading a game loads player inventory - non-empty
    Given I load the game "demo_inventory"
    And I load slot 4
    Then the game property "player.inventory.items.size" should be "2"

  Scenario: Loading a game loads player animation
    Given I load the game "demo_inventory"
    And I load slot 5
    Then the game property "player.animation_width" should be "32"
    Then the game property "player.animation_height" should be "16"
    When I use the weapon
    And I run the game loop 1 times


  Scenario: Loading a game loads player inventory - non-empty
    Given I load the game "demo_inventory"
    And I load slot 6
    Then the game property "player.inventory.items.size" should be "2"
    Then the game property "player.inventory.weapon.nil?" should be "false"

  Scenario: Menu Save Slot Filtering Unsaved
    Given I load the game "demo_inventory"
    And I create a menu controller
    And I load the main menu "save_game.yml"
    When I enter the menu
    When I stub the last saved time for slot 1 to be "nil"
    Then the current menu entry should have:
      | display_text                               | formatted_display_text        | action         | action_argument |
      | Save Game 1 {{last_save_time_for_slot}}    | Save Game 1 (empty)           | save_game_slot | 1               |

 Scenario: Menu Save Slot Filtering Saved
    Given I load the game "demo_inventory"
    And I create a menu controller
    And I load the main menu "save_game.yml"
    When I enter the menu
    When I stub the last saved time for slot 1 to be "'foobar'"
    Then the current menu entry should have:
      | display_text                               | formatted_display_text        | action         | action_argument |
      | Save Game 1 {{last_save_time_for_slot}}    | Save Game 1 (foobar)          | save_game_slot | 1               |



