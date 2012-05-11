@needs_full_gosu
Feature: Player Details
  In order to play the game
  As a player
  I want to be able to see myself in a level

  Scenario: Player Avatar
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    When I see the first frame
    Then the player should be in the scene
    And the player should be at position 36,36
    And the player should be facing "north"

  Scenario: Player Movement
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I set the player step size to 5
    When I see the first frame
    And I turn to the right 90 degrees
    And I move forward 1 step
    Then the player should be at position 41,36
    And the player radius should be 36
    And the player should be facing "east"

  Scenario: Player YAML loading
    Given I load the game on level "trivial" with screen size 640, 480
    And I load a player from "player.yml"
    When I see the first frame
    Then the player should be in the scene
    And the player should be at position 36,36
    And the player should be facing "north"
    And the player radius should be 36

  Scenario: Player weapon YAML loading
    Given I load the game on level "trivial" with screen size 640, 480
    And I create an animation controller with a ratio of one animation tick to 1 game ticks
    And I create a sound controller from file "sound_config.yml"
    And I load a player from "player_with_weapon.yml"
    When I use the weapon
    When I see the first frame
    And I run the game loop 1 times
    Then the player should be in the scene
    And the player should be at position 36,36
    And the player should be facing "north"
    And the player radius should be 36
    Then the weapon should be in use and on frame 1
    And the weapon sound should be played

  Scenario: Player YAML saving
    Given I load the game on level "trivial" with screen size 640, 480
    And I load a player from "player.yml"
    When I see the first frame
    Then the player should have yaml matching "expected_player.yml"

  Scenario: Player YAML saving 2
    Given I load the game on level "trivial" with screen size 640, 480
    And I load a player from "gd_load_player.yml"
    When I see the first frame
    Then the player should have yaml matching "expected_gd_player.yml"

  Scenario: Player Sound Effect Names
    Given I load the game "new_game_load_screen"
    And I set the player property "damage_sound_effect_name" to "wound"
    When I invoke the damage action
    Then the play count for sound effect "wound" should be 1

  Scenario: Player Validation
    Given I create a valid player
    Then the player should be valid

  Scenario Outline: Player Validation - Requirements
    Given I create a valid player
    When I unset the player property "<property>"
    Then the player should not be valid
  Examples:
    | property            |
    | menu_action_delay |
    | direction          |
