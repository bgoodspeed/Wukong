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

  Scenario: Path Following
    Given I load the game "demo"


