@needs_full_gosu
Feature: Weapons
  In order to play the game
  As a player
  I want to be able to use weapons

  Scenario: Weapon use
    Given I load the game on level "trivial" with screen size 640, 480
    And I create an animation controller with a ratio of one animation tick to 1 game ticks
    And I set the player avatar to "avatar.bmp"
    And I create a sound controller
    And I set the player weapon with image "weapon.png"
    And I set the player weapon start to -45
    And I set the player weapon sweep to 90
    And I set the player weapon sound effect to "weapon.wav"
    When I use the weapon
    And I run the game loop 1 times
    Then the weapon should be in use and on frame 1
    And the weapon sound should be played

  Scenario: Weapons in YAML
    Given I load the game on level "trivial" with screen size 640, 480
    And I create an animation controller with a ratio of one animation tick to 1 game ticks
    And I set the player avatar to "avatar.bmp"
    And I create a sound controller
    And I add a sound effect from "weapon.wav" called "player_weapon_sound"
    And I load and equip the weapon defined in "weapon.yml"
    When I use the weapon
    And I run the game loop 1 times
    Then the weapon should be in use and on frame 1
    And the weapon sound should be played

  Scenario: Weapons in YAML - Non Projectile
    Given I load the game on level "trivial" with screen size 640, 480
    And I create an animation controller with a ratio of one animation tick to 1 game ticks
    And I set the player avatar to "avatar.bmp"
    And I create a sound controller
    Then the level should have 1 dynamic elements
    And I add a sound effect from "weapon.wav" called "player_weapon_sound"
    And I load and equip the weapon defined in "weapon_swung.yml"
    When I use the weapon
    And I run the game loop 1 times
    Then the weapon should be in use and on frame 1
    And the weapon sound should be played
    And there should be no projectiles
    And a timed event should be queued
    And the level should have 2 dynamic elements

  Scenario: Weapons - Unequipped
    Given I load the game on level "trivial" with screen size 640, 480
    And I create an animation controller with a ratio of one animation tick to 1 game ticks
    And I set the player avatar to "avatar.bmp"
    When I use the weapon
    And I run the game loop 1 times
    Then the weapon should not be in use


  Scenario: Weapons in YAML Equipment Image
    Given I load the game on level "equip" with screen size 640, 480
    And I create an animation controller with a ratio of one animation tick to 1 game ticks
    And I create a sound controller
    And I set the player avatar to "avatar.bmp"
    And I add a sound effect from "weapon.wav" called "player_weapon_sound"
    And I load and equip the weapon defined in "weapon_equipment_image.yml"
    Then the game property "player.inventory.weapon.equipment_image_path" should be "'test-data/equipment/weapon.png'"
    When I use the weapon
    And I run the game loop 1 times
    Then the weapon should be in use and on frame 1

