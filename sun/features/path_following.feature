Feature: Path Following Details
  In order to play the game
  As a player
  I want entities to follow paths

  Scenario: Path Following - Projectile
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I create the path following controller
    And I add a projectile starting at 0,0 from angle 180 at speed 1
    When I step the path following controller
    Then the projectile should be at 0,1
    And the projectile collision radius should be 1
    And the projectile collision center should be 0,1

  Scenario: Path Following - Projectile Positions
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I create the path following controller
    And I add a projectile starting at 0,0 from angle 180 at speed 5
    And I add a projectile starting at 0,0 from angle 90 at speed 10
    When I step the path following controller
    Then there should be projectiles at:
      | expected_position |
      | 0,5               |
      | 10,0              |

  Scenario: Path Following - Line Of Sight - Available
    Given I load the game on level "empty" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I create the path following controller
    And I add an enemy from "enemy_ai.yml"
    When I see the first frame
    Then there should be 1 enemies
    Given I tell the enemy to track the player
    Given I register the enemy in the path following controller using wayfinding
    When I run the game loop 1 times
#    Then the game property "level.enemies.first.artificial_intelligence.current_state" should be ":chase"

#TODO enable line of sight state machine transitions
#  Scenario: Path Following - Line Of Sight - Blocked
#    Given I load the game on level "trivial" with screen size 640, 480
#    And I set the player avatar to "avatar.bmp"
#    And I create the path following controller
#    And I add an enemy from "enemy_ai.yml"
#    When I see the first frame
#    Then there should be 1 enemies
#    When I set the property "level.enemies.first.position.x" to "275"
#    When I set the property "level.enemies.first.position.y" to "275"
#    When I set the property "player.position.x" to "275"
#    When I set the property "player.position.y" to "75"
#    Given I tell the enemy to track the player
#    Given I register the enemy in the path following controller using wayfinding
#    When I run the game loop 1 times
#    Then the game property "level.enemies.first.artificial_intelligence.current_state" should be ":wait"

