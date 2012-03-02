Feature: Collision Detection
  In order to play the game
  As a player
  I want to be able to interact with the game world

  Scenario: Blocking Collisions Stopped By North Wall
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.png"
    And I set the player step size to 10
    And I set the game clock to 60 fps
    When I simulate "Gosu::KbUp,Gosu::KbLeft"
    And I run the game loop 2 times
    Then the player should be at position 36,36

