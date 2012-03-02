Feature: Weapons
  In order to play the game
  As a player
  I want to be able to use weapons

  Scenario: Weapon use
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.png"
    And I set the player weapon with image "weapon.png"
    And I set the player weapon start to -45
    And I set the player weapon sweep to 90
    And I set the player weapon frames to 60
    When I use the weapon
    And I run the game loop 1 times
    Then the weapon should be in use and on frame 1

