Feature: Game Description
  In order to play the game
  As a player
  I want to be able to see myself in a level

  Scenario: Trivial Level
    Given I load the game on level "trivial" with screen size 640, 480
    When I see the first frame
    Then I should be at 36,36 in the game space

  Scenario: Full Game Loading
    Given I load the game "game"
    When I see the first frame
    Then I should be at 200,300 in the game space
