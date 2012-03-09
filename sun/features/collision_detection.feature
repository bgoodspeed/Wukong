Feature: Collision Detection
  In order to play the game
  As a player
  I want to be able to interact with the game world

  Scenario: Blocking Collisions Stopped By North Wall
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.png"
    And I set the player step size to 10
    And I set the game clock to 60 fps
    When I simulate "Gosu::KbUp,Gosu::KbLeft"
    And I run the game loop 2 times
    Then the player should be at position 36,36

  Scenario: Projectile Collisions not yet Destroyed
    Given I load the game on level "trivial" with screen size 640, 480
    And I create the path following manager
    And I set the player avatar to "avatar.png"
    And I set the player direction to 180
    And I set the player step size to 10
    And I set the player weapon with image "weapon.png"
    And I set the player weapon type to "projectile"
    And I set the game clock to 60 fps
    When I simulate "Gosu::KbSpace"
    And I run the game loop 1 times
    Then there should be projectiles at:
      | expected_position |
      | 36,46             |

  Scenario: Projectile Collisions Destroyed By South Wall
    Given I load the game on level "trivial" with screen size 640, 480
    And I create the path following manager
    And I set the player avatar to "avatar.png"
    And I set the player step size to 10
    And I set the player direction to 180
    And I set the player weapon with image "weapon.png"
    And I set the player weapon type to "projectile"
    And I set the game clock to 60 fps
    When I simulate "Gosu::KbSpace"
    And I run the game loop 44 times and clear the state after run 1
    Then there should be no projectiles

  Scenario: Projectile Collisions Destroyed By Collision With Enemy
    Given I load the game on level "trivial" with screen size 640, 480
    And I create the path following manager
    And I set the player avatar to "avatar.png"
    And I set the player step size to 10
    And I set the player direction to 180
    And I set the enemy avatar to "enemy_avatar.png"
    And I set the enemy position 36,300
    And I set the player weapon with image "weapon.png"
    And I set the player weapon type to "projectile"
    And I set the game clock to 60 fps
    When I simulate "Gosu::KbSpace"
    And I run the game loop 22 times and clear the state after run 1
    Then there should be no projectiles

  Scenario: Player collisions with Enemy damages both
    Given I load the game on level "trivial" with screen size 640, 480
    And I create the path following manager
    And I set the player avatar to "avatar.png"
    And I set the player position to 51,60
    And I set the player step size to 10
    And I set the player direction to 180
    And I set the player health to 10
    And I set the enemy avatar to "enemy_avatar.png"
    And I set the enemy position 50,300
    And I set the enemy health to 5
    And I set the game clock to 60 fps
    When I simulate "Gosu::KbUp"
    And I run the game loop 17 times
    And the player health should be 9
    And the enemy health should be 4

  Scenario: Player collisions with Enemy damages both
    Given I load the game on level "trivial" with screen size 640, 480
    And I create the path following manager
    And I set the player avatar to "avatar.png"
    And I set the player position to 49,60
    And I set the player step size to 10
    And I set the player direction to 180
    And I set the player health to 10
    And I set the enemy avatar to "enemy_avatar.png"
    And I set the enemy position 50,300
    And I set the enemy health to 5
    And I set the game clock to 60 fps
    When I simulate "Gosu::KbUp"
    And I run the game loop 17 times
    And the player health should be 9
    And the enemy health should be 4



