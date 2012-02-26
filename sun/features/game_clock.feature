Feature: Game Clock
  In order to play the game
  As a player
  I want to be able to see a certain framerate of updates

  Scenario: Game Clock
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.png"
    And I set the game clock to 60 fps
    When I run the game loop 1 times
    Then the elapsed clock time should be between 15 and 20 milliseconds
    And the number of frames render should be 1

  Scenario: Game Clock Averaged
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.png"
    And I set the game clock to 60 fps
    When I run the game loop 30 times
    Then the elapsed clock time should be between 450 and 550 milliseconds
    And the number of frames render should be 30
