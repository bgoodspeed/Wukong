Feature: Player Details
  In order to play the game
  As a player
  I want to be able to see myself in a level

  Scenario: Player Avatar
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.png"
    When I see the first frame
    Then the player should be in the scene
    And the player should be at position 0,0