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

  Scenario: Mocking Gosu Input Weapons
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.png"
    And I set the player step size to 25
    When I simulate "Gosu::KbSpace"
    And I update the key state
    And the following keys should be active: "Fire"

  Scenario: Mapping input to movements and actions firing weapons
    Given I load the game on level "trivial" with screen size 640, 480
    And I create an animation manager with a ratio of one animation tick to 1 game ticks
    And I create the path following manager
    And I set the player avatar to "avatar.png"
    And I set the player step size to 25
    And I set the player weapon with image "weapon.png"
    And I set the player weapon start to -45
    And I set the player weapon sweep to 90
    When I press "Fire"
    And I update the game state
    Then the player weapon should be in use
    Then there should be projectiles at:
      | expected_position |
      | 36,46             |

