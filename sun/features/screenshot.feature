@slow
Feature: Game Description
  In order to play the game
  As a player
  I want to be able to see myself in a level

  Scenario: Trivial Level
    Given I load the game on level "trivial" with screen size 640, 480
    When I see the first frame
    And I take a screenshot named "trivial-capture.png"
    Then I it should match the goldmaster "trivial.png"

  Scenario: Trivial Level Movement
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.png"
    And I set the player step size to 50
    When I turn to the right 90 degrees
    And I move forward one step
    And I see the first frame
    And I take a screenshot named "movement-capture.png"
    Then the player should be at position 50,0
    And I it should match the goldmaster "movement.png"
