@slow
Feature: Game Clock
  In order to play the game
  As a player
  I want to be able to see a certain framerate of updates

  Scenario: Game Clock Time
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I set the game clock to 60 fps
    When I run the game loop 1 times
    Then the elapsed clock time should be between 0 and 25 milliseconds
    And the number of frames render should be 1

  Scenario: Game Clock Time Demo
    Given I load the game on level "demo" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I set the game clock to 60 fps
    When I run the game loop 1 times
    Then the elapsed clock time should be between 0 and 25 milliseconds
    And the number of frames render should be 1

  Scenario: Game Clock Averaged
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I set the game clock to 60 fps
    When I run the game loop 30 times
    Then the elapsed clock time should be between 0 and 550 milliseconds
    And the number of frames render should be 30


  Scenario: Reloading Levels Profiled
    Given I load the game "demo"
    And I set the game clock to 60 fps
    And I reset the clock
    When I run the game loop 1 times
    And the number of frames render should be 1
    And I reload the level "demo"
    When I run the game loop 1 times
    And the number of frames render should be 1
    Then the elapsed clock time should be between 0 and 25 milliseconds
    

  Scenario: Game Clock Timed Events
    Given I load the game on level "trivial" with screen size 640, 480
    And I load a player from "player.yml"
    And I create the HUD from file "hud_config.yml"
    And I set the game clock to 60 fps
    And I enqueue a timed event named "one_tick_message" and action "temporary_message=" data "foo" for 2 ticks
    When I run the game loop 1 times
    Then the number of frames render should be 1
    Then the hud formatted line 1 should be "Player HP: 5/6"
    Then the hud formatted line 2 should be "foo"
    When I run the game loop 2 times
    Then the hud formatted line 1 should be "Player HP: 5/6"
    Then the hud formatted line 2 should be ""

  Scenario: Game Clock Timed Events used for KeyPress repeat control
    Given I load the game on level "trivial" with screen size 640, 480
    And I load a player from "player.yml"
    And I create the HUD from file "hud_config.yml"
    And I set the game clock to 60 fps
    And I enqueue a timed event with name "dam" and start_action "disable_action" and end_action "enable_action" and data "foo" for 2 ticks
    When I run the game loop 1 times
    Then the action "foo" should be disabled
    Then the action "bar" should be enabled
    When I run the game loop 2 times
    Then the action "foo" should be enabled

  Scenario: Game Clock Timed Events used for KeyPress repeat control Full Scenario
    Given I load the game on level "trivial" with screen size 640, 480
    And I load a player from "player.yml"
    And I create the HUD from file "hud_config.yml"
    And I create a menu manager
    And I load the main menu "three.yml"
    And I set the game clock to 60 fps
    And the player should be at position 36,36
    And I set the player menu action delay to 2
    And I enqueue a timed event with name "dam" and start_action "disable_action" and end_action "enable_action" and data "Down" for 2 ticks
    When I enter the menu
    When I simulate "Graphics::KbDown"
    When I run the game loop 1 times
    Then the action "Down" should be disabled
    Then the action "bar" should be enabled
    Then the current menu entry should have:
      | display_text   | 
      | one            |
    When I simulate "Graphics::KbDown"
    When I run the game loop 2 times
    Then the current menu entry should have:
      | display_text   |
      | two            |


  Scenario: Spawn Events Repeating
    Given I load the game on level "simple" with screen size 640, 480
    And I set the player health to 100
    And I create a condition manager
    And I stub "foo" on game to return "false"
    When I add a fake condition that checks "foo" on game named "COND"
    And I run the game loop 11 times
    Then there should be 10 enemies

  Scenario: Spawn Events Repeating Till Limit
    Given I load the game on level "simple" with screen size 640, 480
    And I load a player from "player_moved.yml"
    And I create a condition manager
    And I stub "foo" on game to return "false"
    When I add a fake condition that checks "foo" on game named "COND"
    And I run the game loop 25 times
    Then there should be 20 enemies
