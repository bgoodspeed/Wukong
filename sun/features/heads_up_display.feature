Feature: Heads Up Display
  In order to see information about the game
  As a player
  I want to be able to read info from the HUD

  Scenario: HUD Display
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I create the HUD
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


  Scenario: Simple Menu Hud Integration
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a menu controller
    And I register a fake action to return triple the argument called "choose_slot"
    And I create the HUD
    And I create a new menu called "pick_slot":
      """
      menu:
        menu_id: pick_slot
        entries:
          - display_text: 1 - One
            action: choose_slot
            action_argument: 1
          - display_text: 2 - Two
            action: choose_slot
            action_argument: 2
          - display_text: 3 - Three
            action: choose_slot
            action_argument: 3
      """
    And I set the main menu name to "pick_slot"
    When I enter the menu
    And I move down in the menu
    And I move down in the menu
    Then the current menu entry should have:
      | display_text   | action         | action_argument |
      | 3 - Three      | choose_slot    | 3               |
    When I simulate ""
    And I run the game loop 1 times
    Then the hud should be in menu mode
    And the hud cursor position should be 20,60
    And the hud should contain:
    | hud text  |
    | 1 - One   |
    | 2 - Two   |
    | 3 - Three |
    
  Scenario: Simple Menu Hud Integration 2
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a menu controller
    And I register a fake action to return triple the argument called "choose_slot"
    And I create the HUD
    And I create a new menu called "pick_slot":
      """
      menu:
        menu_id: pick_slot
        entries:
          - display_text: 1 - One
            action: choose_slot
            action_argument: 1
          - display_text: 2 - Two
            action: choose_slot
            action_argument: 2
          - display_text: 3 - Three
            action: choose_slot
            action_argument: 3
      """
    And I set the main menu name to "pick_slot"
    When I enter the menu
    And I move down in the menu
    Then the current menu entry should have:
      | display_text   | action         | action_argument |
      | 2 - Two        | choose_slot    | 2               |
    When I simulate ""
    And I run the game loop 1 times
    Then the hud should be in menu mode
    And the hud cursor position should be 20,40
    And the hud should contain:
    | hud text  |
    | 1 - One   |
    | 2 - Two   |
    | 3 - Three |

  Scenario: HUD Player Info
    Given I load the game on level "trivial" with screen size 640, 480
    And I load a player from "player.yml"
    And I create the HUD
    And I set the HUD text to:
    """
    Player HP: {{player.health}}/{{player.max_health}}
    {{temporary_message}}
    """
    When I see the first frame
    Then the hud formatted line 1 should be "Player HP: 5/6"
    Then the hud should contain:
    | hud text       |
    | Player HP: 5/6 |
    |                |

  Scenario: HUD Player From Yaml
    Given I load the game on level "trivial" with screen size 640, 480
    And I load a player from "player.yml"
    And I create the HUD from file "hud_config.yml"
    When I see the first frame
    Then the hud formatted line 1 should be "Player HP: 5/6"
    Then the hud should contain:
    | hud text       |
    | Player HP: 5/6 |
    |                |

  Scenario: HUD Player From Yaml
    Given I load the game on level "trivial" with screen size 640, 480
    And I load a player from "player.yml"
    And I create the HUD from file "hud_config.yml"
    When I see the first frame
    Then the hud formatted line 1 should be "Player HP: 5/6"
    Then the hud should contain:
    | hud text       |
    | Player HP: 5/6 |
    |                |

  Scenario: HUD Player Menu Highlights
    Given I load the game on level "trivial" with screen size 640, 480
    And I load a player from "player.yml"
    And I create a menu controller
    And I load the main menu "main.yml"
    And I create the HUD from file "hud_config.yml"
    And I set the mouse position to 30, 30 in screen coords
    When I enter the menu
    When I see the first frame
    Then there should be 2 regions to check the mouse against
    And highlighted region should be line 0

  Scenario: HUD Player Menu Highlights Second Line
    Given I load the game on level "trivial" with screen size 640, 480
    And I load a player from "player.yml"
    And I create a menu controller
    And I load the main menu "main.yml"
    And I create the HUD from file "hud_config.yml"
    And I set the mouse position to 30, 50 in screen coords
    When I enter the menu
    When I see the first frame
    Then there should be 2 regions to check the mouse against
    And highlighted region should be line 1
