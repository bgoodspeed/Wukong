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
