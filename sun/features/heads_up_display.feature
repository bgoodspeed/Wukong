Feature: Heads Up Display
  In order to see information about the game
  As a player
  I want to be able to read info from the HUD

  Scenario: HUD Display
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I set the HUD text to:
    """
    line one
    line two
    etc
    last line
    """
    When I see the first frame
    Then the hud should contain:
    | hud text |
    | line one |
    | line two |
    | etc |
    | last line |


