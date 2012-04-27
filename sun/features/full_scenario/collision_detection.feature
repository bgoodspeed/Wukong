@slow
@needs_full_gosu
Feature: Collision Detection
  In order to play the game
  As a player
  I want to be able to interact with the game world

  Scenario: Blocking Collisions Stopped By North Wall
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I set the player step size to 10
    And I set the game clock to 60 fps
    When I simulate "Graphics::KbUp,Graphics::KbLeft"
    And I run the game loop 2 times
    Then the player should be at position 36,36

  Scenario: Projectile Collisions not yet Destroyed
    Given I load the game on level "trivial" with screen size 640, 480
    And I create the path following controller
    And I set the player avatar to "avatar.bmp"
    And I set the player direction to 180
    And I set the player step size to 10
    And I set the player weapon with image "weapon.png"
    And I set the player weapon type to "projectile"
    And I set the game clock to 60 fps
    When I simulate "Graphics::KbSpace"
    And I run the game loop 1 times
    Then there should be projectiles at:
      | expected_position |
      | 36,46             |

 Scenario: Projectile Collisions not yet Destroyed - Reload
    Given I load the game on level "trivial" with screen size 640, 480
    And I create the path following controller
    And I set the player avatar to "avatar.bmp"
    And I set the player direction to 180
    And I set the player step size to 10
    And I set the player weapon with image "weapon.png"
    And I set the player weapon type to "projectile"
    And I set the game clock to 60 fps
    When I simulate "Graphics::KbSpace"
    And I run the game loop 1 times
    Then there should be projectiles at:
      | expected_position |
      | 36,46             |
    And I reload the level "demo"
    Then the weapon should not be in use

  Scenario: Projectile Collisions Destroyed By South Wall
    Given I load the game on level "trivial" with screen size 640, 480
    And I create the path following controller
    And I set the player avatar to "avatar.bmp"
    And I set the player step size to 10
    And I set the player direction to 180
    And I set the player weapon with image "weapon.png"
    And I set the player weapon type to "projectile"
    And I set the game clock to 60 fps
    When I simulate "Graphics::KbSpace"
    And I run the game loop 44 times and clear the state after run 1
    Then there should be no projectiles

  Scenario: Projectile Collisions Destroyed By Collision With Enemy
    Given I load the game on level "trivial" with screen size 640, 480
    And I create the path following controller
    And I set the player avatar to "avatar.bmp"
    And I set the player step size to 10
    And I set the player direction to 180
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy position 36,300
    And I set the player weapon with image "weapon.png"
    And I set the player weapon type to "projectile"
    And I set the game clock to 60 fps
    When I simulate "Graphics::KbSpace"
    And I run the game loop 22 times and clear the state after run 1
    Then there should be no projectiles

  Scenario: Player collisions with Enemy damages both
    Given I load the game on level "trivial" with screen size 640, 480
    And I create the path following controller
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 51,60
    And I set the player step size to 10
    And I set the player direction to 180
    And I set the player health to 10
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy position 50,300
    And I set the enemy health to 5
    And I set the game clock to 60 fps
    When I simulate "Graphics::KbUp"
    And I run the game loop 17 times
    And the player health should be 9
    And the enemy health should be 4

  Scenario: Player collisions with Enemy damages both ghost
    Given I load the game on level "trivial" with screen size 640, 480
    And I create the path following controller
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 49,60
    And I set the player step size to 10
    And I set the player direction to 180
    And I set the player health to 10
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy position 50,300
    And I set the enemy health to 5
    And I set the game clock to 60 fps
    When I simulate "Graphics::KbUp"
    And I run the game loop 17 times
    And the player health should be 9
    And the enemy health should be 4

  Scenario: Event Emitting Collisions
    Given I load the game on level "emitter" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 100,200
    And I create a sound controller
    And I add a sound effect from "weapon.wav" called "land_mine_boom"
    And I set the game clock to 60 fps
    When I simulate ""
    And I run the game loop 2 times
    Then there should be 1 collisions
    And the play count for sound effect "land_mine_boom" should be 1


  Scenario: Projectile Collisions Destroyed By Collision With Wall
    Given I load the game on level "obstacle" with screen size 640, 480
    And I create the path following controller
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 200,200
    And I set the player step size to 10
    And I set the player direction to 0
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy position 200,100
    And I set the enemy health to 12
    And I set the player weapon with image "weapon.png"
    And I set the player weapon type to "projectile"
    And I set the game clock to 60 fps
    When I simulate "Graphics::KbSpace"
    And I run the game loop 12 times and clear the state after run 1
    Then there should be no projectiles
    And the enemy should have 12 hp

  Scenario: Projectile Collisions Destroyed By Collision With Wall On angle
    Given I load the game on level "obstacle" with screen size 640, 480
    And I create the path following controller
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 200,200
    And I set the player step size to 10
    And I set the player direction to 45
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy position 300,100
    And I set the enemy health to 12
    And I set the player weapon with image "weapon.png"
    And I set the player weapon type to "projectile"
    And I set the game clock to 60 fps
    When I simulate "Graphics::KbSpace"
    And I run the game loop 60 times and clear the state after run 1
    Then there should be no projectiles
    And the enemy should have 12 hp

  Scenario: Projectile Collisions Destroyed Enemy On angle
    Given I load the game on level "trivial" with screen size 640, 480
    And I create the path following controller
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 200,200
    And I set the player step size to 10
    And I set the player direction to 45
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy position 300,100
    And I set the enemy health to 12
    And I set the player weapon with image "weapon.png"
    And I set the player weapon type to "projectile"
    And I set the game clock to 60 fps
    When I simulate "Graphics::KbSpace"
    And I run the game loop 55 times and clear the state after run 1
    Then there should be no projectiles
    And the enemy should have 11 hp

  Scenario: Shooting bug wall
    Given I load the game on level "level_1" with screen size 640, 480
    And I create the path following controller
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 267,394
    And I set the player direction to 145
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy position 360,500
    And I set the enemy health to 12
    And I set the player weapon with image "weapon.png"
    And I set the player weapon type to "projectile"
    And I set the game clock to 60 fps
    When I simulate "Graphics::KbSpace"
    And I run the game loop 60 times and clear the state after run 1
    Then there should be no projectiles
    And the enemy should have 12 hp

  Scenario: Shooting bug enemy
    Given I load the game on level "trivial" with screen size 640, 480
    And I create the path following controller
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 267,394
    And I set the player direction to 145
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy position 360,500
    And I set the enemy health to 12
    And I set the player weapon with image "weapon.png"
    And I set the player weapon type to "projectile"
    And I set the game clock to 60 fps
    When I simulate "Graphics::KbSpace"
    And I run the game loop 60 times and clear the state after run 1
    Then there should be no projectiles
    And the enemy should have 11 hp

  Scenario: Shooting bug wall2
    Given I load the game on level "level_1" with screen size 640, 480
    And I create the path following controller
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 236,484
    And I set the player direction to 25
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy position 340,259
    And I set the enemy health to 12
    And I set the player weapon with image "weapon.png"
    And I set the player weapon type to "projectile"
    And I set the game clock to 60 fps
    When I simulate "Graphics::KbSpace"
    And I run the game loop 60 times and clear the state after run 1
    Then there should be no projectiles
    And the enemy should have 12 hp

  Scenario: Shooting bug enemy2
    Given I load the game on level "trivial" with screen size 640, 480
    And I create the path following controller
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 236,484
    And I set the player direction to 25
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy position 340,259
    And I set the enemy health to 12
    And I set the player weapon with image "weapon.png"
    And I set the player weapon type to "projectile"
    And I set the game clock to 60 fps
    When I simulate "Graphics::KbSpace"
    And I run the game loop 60 times and clear the state after run 1
    Then there should be no projectiles
    And the enemy should have 11 hp

  Scenario: Shooting bug wall3
    Given I load the game on level "level_1" with screen size 640, 480
    And I create the path following controller
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 257,384
    And I set the player direction to 70
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy position 423,300
    And I set the enemy health to 12
    And I set the player weapon with image "weapon.png"
    And I set the player weapon type to "projectile"
    And I set the game clock to 60 fps
    When I simulate "Graphics::KbSpace"
    And I run the game loop 60 times and clear the state after run 1
    Then there should be no projectiles
    And the enemy should have 12 hp

  Scenario: Shooting bug enemy3
    Given I load the game on level "trivial" with screen size 640, 480
    And I create the path following controller
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 257,384
    And I set the player direction to 70
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy position 423,300
    And I set the enemy health to 12
    And I set the player weapon with image "weapon.png"
    And I set the player weapon type to "projectile"
    And I set the game clock to 60 fps
    When I simulate "Graphics::KbSpace"
    And I run the game loop 60 times and clear the state after run 1
    Then there should be no projectiles
    And the enemy should have 11 hp

  Scenario: Shooting bug wall4
    Given I load the game on level "level_1" with screen size 640, 480
    And I create the path following controller
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 224,385
    And I set the player direction to 70
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy position 450,292
    And I set the enemy health to 12
    And I set the player weapon with image "weapon.png"
    And I set the player weapon type to "projectile"
    And I set the game clock to 60 fps
    When I simulate "Graphics::KbSpace"
    And I run the game loop 60 times and clear the state after run 1
    Then there should be no projectiles
    And the enemy should have 12 hp

  Scenario: Shooting bug enemy4
    Given I load the game on level "trivial" with screen size 640, 480
    And I create the path following controller
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 224,385
    And I set the player direction to 70
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy position 450,292
    And I set the enemy health to 12
    And I set the player weapon with image "weapon.png"
    And I set the player weapon type to "projectile"
    And I set the game clock to 60 fps
    When I simulate "Graphics::KbSpace"
    And I run the game loop 60 times and clear the state after run 1
    Then there should be no projectiles
    And the enemy should have 11 hp
