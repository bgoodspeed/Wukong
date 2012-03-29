Feature: Player Details
  In order to play the game
  As a player
  I want to be able to see myself in a level

  Scenario: Player Avatar
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    When I see the first frame
    Then the player should be in the scene
    And the player should be at position 36,36
    And the player should be facing "north"

  Scenario: Player Movement
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I set the player step size to 5
    When I see the first frame
    And I turn to the right 90 degrees
    And I move forward 1 step
    Then the player should be at position 41,36
    And the player radius should be 36
    And the player should be facing "east"

  Scenario: Player YAML loading
    Given I load the game on level "trivial" with screen size 640, 480
    And I load a player from "player.yml"
    When I see the first frame
    Then the player should be in the scene
    And the player should be at position 36,36
    And the player should be facing "north"
    And the player radius should be 36
