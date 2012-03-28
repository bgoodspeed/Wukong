Feature: Menu
  In order to play the game
  As a player
  I want to be able to save, load and set options through a menu

  Scenario: Simple Menu
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a menu manager
    And I create a new menu called "menu":
      """
      menu:
        menu_id: main_menu
        entries:
          - display_text: Start New Game
            action: start_new_game
      """
    And I set the main menu name to "menu"
    When I enter the menu
    Then the menu named "menu" should be active
    And the current menu entry should have:
      | display_text   | action         |
      | Start New Game | start_new_game |

  Scenario: Simple Menu Selection
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a menu manager
    And I create a new menu called "pick_slot":
      """
      menu:
        menu_id: pick_slot
        entries:
          - display_text: 1
            action: choose_slot
            action_argument: 1
          - display_text: 2
            action: choose_slot
            action_argument: 2
      """
    And I set the main menu name to "pick_slot"
    When I enter the menu
    And I move down in the menu
    Then the current menu entry should have:
      | display_text   | action         | action_argument |
      | 2              | choose_slot    | 2               |

  Scenario: Simple Menu Invocation
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a menu manager
    And I register a fake action to return triple the argument called "choose_slot"
    And I create a new menu called "pick_slot":
      """
      menu:
        menu_id: pick_slot
        entries:
          - display_text: 1
            action: choose_slot
            action_argument: 1
      """
    And I set the main menu name to "pick_slot"
    When I enter the menu
    And I move down in the menu
    Then the current menu entry should have:
      | display_text   | action         | action_argument |
      | 1              | choose_slot    | 1               |
    When I invoke the current menu action
    Then the menu action result should be 3

