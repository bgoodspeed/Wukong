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
    And I update the game state
    Then the player should be at position 61,36
    And the following keys should be active: "Right,Up"

  Scenario: Mocking Gosu Input
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.png"
    And I set the player step size to 25
    When I simulate "Gosu::KbLeft,Gosu::KbDown"
    And I update the key state
    And the following keys should be active: "Left,Down"
