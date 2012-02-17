Feature: Game Description
  In order to play the game
  As a player
  I want to be able to see myself in a level

  Scenario: Trivial Level
    Given I load the game on level "trivial" with screen size 640, 480
    When I see the first frame
    Then I should be at 0,0 in the game space
