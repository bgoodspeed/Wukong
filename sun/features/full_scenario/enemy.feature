@needs_full_gosu
Feature: Enemy Built
  In order to have challenges
  As a player
  I want to have an enemy to fight

  Scenario: Enemy Avatar
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the enemy avatar to "enemy_avatar.bmp"
    When I see the first frame
    Then the enemy should be in the scene
    And the enemy should be at position 25,25.0
    And the enemy should have hud message "Enemy : 15HP"

  Scenario: Enemy Chasing Player
    Given I load the game on level "trivial" with screen size 640, 480
    And I load wayfinding layer "trivial"
    And I create the path following controller
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 300,300
    And I tell the enemy to track the player
    And I tell the enemy velocity to 5
    And I register the enemy in the path following controller using wayfinding
    When I see the first frame
    And I step the path following controller
    Then the enemy should be in the scene
    And the player should be at position 300,300
    And the path following controller should be tracking the enemy
    And the next wayfinding point for enemy should be 50,50
    And the next wayfinding direction for enemy should be 0.7071, 0.7071
    And the enemy should be at position 28.5355,28.5355
    Then the enemy direction should be 45

  Scenario: Enemy Chasing Player B
    Given I load the game on level "trivial" with screen size 640, 480
    And I load wayfinding layer "trivial"
    And I create the path following controller
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy position 40,40
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 300,300
    And I tell the enemy to track the player
    And I tell the enemy velocity to 10
    And I register the enemy in the path following controller using wayfinding
    When I see the first frame
    And I step the path following controller 51 times
    Then the enemy should be in the scene
    And the player should be at position 300,300
    And the path following controller should be tracking the enemy
    And the enemy should be at position 299.9998,299.9818
    Then the enemy direction should be 89.311

  Scenario: Enemy Too Far Away
    Given I load the game on level "trivial" with screen size 640, 480
    And I load wayfinding layer "trivial"
    And I create the path following controller
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 3000,3000
    And I tell the enemy to track the player
    And I tell the enemy velocity to 5
    And I register the enemy in the path following controller using wayfinding
    When I see the first frame
    And I step the path following controller
    Then the enemy should be in the scene
    And the path following controller should be tracking the enemy
    And the next wayfinding point for enemy should be 50,50
    And the next wayfinding direction for enemy should be 0.7071, 0.7071
    And the enemy should be at position 25,25
    Then the enemy direction should be 0

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

  Scenario: Animated Enemy
    Given I load the game on level "trivial" with screen size 640, 480
    And I add an enemy from "enemy_animated.yml"
    When I see the first frame
    Then there should be 1 enemies
    And there should be be 2 animations registered

  Scenario: Enemy tracking North
    Given I create an enemy in isolation
    When I tick tracking with vector "[0,1]"
    Then the enemy direction should be 0

  Scenario: Enemy tracking East
    Given I create an enemy in isolation
    When I tick tracking with vector "[1,0]"
    Then the enemy direction should be 90

  Scenario: Enemy tracking South
    Given I create an enemy in isolation
    When I tick tracking with vector "[0,-1]"
    Then the enemy direction should be 180

  Scenario: Enemy tracking West
    Given I create an enemy in isolation
    When I tick tracking with vector "[-1,0]"
    Then the enemy direction should be 270

  Scenario: Enemy tracking NE
    Given I create an enemy in isolation
    When I tick tracking with vector "[1,1]"
    Then the enemy direction should be 45

  Scenario: Enemy tracking SE
    Given I create an enemy in isolation
    When I tick tracking with vector "[1,-1]"
    Then the enemy direction should be 315

  Scenario: Enemy tracking SW
    Given I create an enemy in isolation
    When I tick tracking with vector "[-1,-1]"
    Then the enemy direction should be 225

  Scenario: Enemy tracking NW
    Given I create an enemy in isolation
    When I tick tracking with vector "[-1,1]"
    Then the enemy direction should be 135

  Scenario: Animated Enemy Needs Update
    Given I load the game on level "trivial" with screen size 640, 480
    And I add an enemy from "enemy_animated.yml"
    When I see the first frame
    Then there should be 1 enemies
    And the animation for the enemy should not be active
    And the animation for the enemy should need an update


  Scenario: Enemy Validation
    Given I create a valid enemy
    Then the enemy should be valid

  Scenario Outline: Enemy Validation - Requirements
    Given I create a valid enemy
    When I unset the enemy property "<property>"
    Then the enemy should not be valid
  Examples:
    | property            |
    | direction          |