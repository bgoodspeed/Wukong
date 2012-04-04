Feature: Death Events
  In order to have challenges
  As a player
  I want to be able to kill enemies

  Scenario: Enemy Death
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy health to 1
    When I damage the enemy
    And I see the first frame
    Then the enemy should be dead
    And there should be a death event

  Scenario: Death Event Handling
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the enemy avatar to "enemy_avatar.bmp"
    When I create an enemy death event
    And I update the game state
    Then enemy should not be in scene
    And the player property "enemies_killed" should be "1"

