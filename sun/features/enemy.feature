Feature: Enemy Built
  In order to have challenges
  As a player
  I want to have an enemy to fight

  Scenario: Enemy Avatar
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the enemy avatar to "enemy_avatar.bmp"
    When I see the first frame
    Then the enemy should be in the scene
    And the enemy should be at position 35,35.5

  Scenario: Enemy Chasing Player
    Given I load the game on level "trivial" with screen size 640, 480
    And I load wayfinding layer "trivial"
    And I create the path following manager
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 300,300
    And I tell the enemy to track the player
    And I tell the enemy velocity to 5
    And I register the enemy in the path following manager using wayfinding
    When I see the first frame
    And I step the path following manager
    Then the enemy should be in the scene
    And the player should be at position 300,300
    And the path following manager should be tracking the enemy
    And the next wayfinding point for enemy should be 50,50
    And the next wayfinding direction for enemy should be 0.71899, 0.69502
    And the enemy should be at position 38.59494,38.97511

  Scenario: Enemy Chasing Player B
    Given I load the game on level "trivial" with screen size 640, 480
    And I load wayfinding layer "trivial"
    And I create the path following manager
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy position 40,40
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 300,300
    And I tell the enemy to track the player
    And I tell the enemy velocity to 10
    And I register the enemy in the path following manager using wayfinding
    When I see the first frame
    And I step the path following manager 51 times
    Then the enemy should be in the scene
    And the player should be at position 300,300
    And the path following manager should be tracking the enemy
    And the enemy should be at position 299.9998,299.9818

  Scenario: Multiple Enemies
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy avatar to "enemy_avatar.bmp"
    When I see the first frame
    Then there should be 4 enemies
    
  Scenario: Enemies from YAML
    Given I load the game on level "trivial" with screen size 640, 480
    And I add an enemy from "enemy.yml"
    And I add an enemy from "enemy.yml"
    And I add an enemy from "enemy.yml"
    When I see the first frame
    Then there should be 3 enemies
