Feature: Player Controls
  In order to play the game
  As a player
  I want to be able to control myself in a level

  Scenario: Mapping input to movements and actions
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.png"
    And I set the player step size to 25
    When I press "Right"
    And I press "Up"
    And I update the game
    Then the player should be at position 25,0
    And the following keys should be active: "Right,Up"
