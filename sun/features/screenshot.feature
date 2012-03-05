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
    And I move forward 1 step
    And I see the first frame
    And I take a screenshot named "movement-capture.png"
    Then the player should be at position 86,36
    And I it should match the goldmaster "movement.png"

  Scenario: Trivial Level HUD
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the HUD text to:
    """
    line one
    line two
    etc
    last line
    """
    When I see the first frame
    And I take a screenshot named "hud-capture.png"
    Then I it should match the goldmaster "hud.png"

  Scenario: Trivial Level Animation
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.png"
    And I create an animation manager with a ratio of one animation tick to 1 game ticks
    And I set the player attack animation to "animation.png"
    And I set the game clock to 60 fps
    When I run the game loop 1 times
    And I take a screenshot named "animation-capture.png"
    Then I it should match the goldmaster "animation.png"

  Scenario: Trivial Level Animation After 3 Steps
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.png"
    And I create an animation manager with a ratio of one animation tick to 1 game ticks
    And I set the player attack animation to "animation.png"
    And I set the game clock to 60 fps
    When I run the game loop 3 times
    And I take a screenshot named "animation3-capture.png"
    Then I it should match the goldmaster "animation3.png"

  Scenario: Trivial Level Weapon
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.png"
    And I create an animation manager with a ratio of one animation tick to 1 game ticks
    And I set the player weapon with image "weapon.png"
    And I set the player weapon start to -45
    And I set the player weapon sweep to 90
    And I set the game clock to 60 fps
    When I simulate "Gosu::KbSpace"
    And I run the game loop 3 times
    And I take a screenshot named "weapon-fire-capture.png"
    Then I it should match the goldmaster "weapon-fire.png"

