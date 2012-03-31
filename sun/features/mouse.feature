Feature: Mouse
  In order to play a level
  As a player
  I want to be able to click on things in the game

  Scenario: Left Click
    Given I load the game on level "demo" with screen size 640, 480
    When the level is examined
    When I simulate "Gosu::MsLeft"
    And I update the key state
    And I set the mouse position to 100, 200 in screen coords
    And the following keys should be active: "MouseClick"
    
  Scenario: Off Screen
    Given I load the game on level "demo" with screen size 640, 480
    When the level is examined
    When I simulate "Gosu::MsLeft"
    And I update the key state
    And I set the mouse position to 0, 0 in screen coords
    Then the mouse should be considered off screen

  Scenario: In Screen
    Given I load the game on level "demo" with screen size 640, 480
    When the level is examined
    When I simulate "Gosu::MsLeft"
    And I update the key state
    And I set the mouse position to 1, 1 in screen coords
    Then the mouse should be considered on screen

    