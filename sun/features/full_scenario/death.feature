@needs_full_gosu
Feature: Death Events
  In order to have challenges
  As a player
  I want to be able to kill enemies

  Scenario: Enemy Death
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player health to 400
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy health to 1
    When I damage the enemy
    And I see the first frame
    Then the enemy should be dead
    And there should be a death event

  Scenario: Death Event Handling
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the property "upgrade_point_value" to "4" on enemy named "DefaultEnemyName"
    Then the level should have 2 dynamic elements
    When I create an enemy death event
    And I update the game state
    Then enemy should not be in scene
    And the player property "enemies_killed" should be "1"
    Then the level should have 1 dynamic elements
    And the game property "player.upgrade_points" should be "4"

  Scenario: Death Event Handling Drops Inventory Pickup
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player position to 500,500
    And I add an enemy from "enemy_inventory.yml"
    Then the level should have 2 dynamic elements
    When I create an enemy death event
    And I update the game state
    Then enemy should not be in scene
    Then the level should have 2 dynamic elements
    When I run the game loop 1 times



  Scenario: Player Death
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player health to 1
    When I damage the player
    And I see the first frame
    Then the player should be dead
    And there should be a death event

  Scenario: Player Death Event Handling
    Given I load the game "new_game_load_screen"
    When I create a player death event
    And I update the game state
    Then the game should be over
    And the game property "level.name" should be "'game_over'"
