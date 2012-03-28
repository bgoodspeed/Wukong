Feature: Weapons
  In order to play the game
  As a player
  I want to be able to use weapons

  Scenario: Weapon use
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I create an animation manager with a ratio of one animation tick to 1 game ticks
    And I create a sound manager
    And I set the player weapon with image "weapon.png"
    And I set the player weapon start to -45
    And I set the player weapon sweep to 90
    And I set the player weapon sound effect to "weapon.wav"
    When I use the weapon
    And I run the game loop 1 times
    Then the weapon should be in use and on frame 1
    And the weapon sound should be played


