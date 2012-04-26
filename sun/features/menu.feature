Feature: Menu
  In order to play the game
  As a player
  I want to be able to save, load and set options through a menu

  Scenario: Simple Menu
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a menu controller
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
    And I create a menu controller
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
    Then the current menu entry should have:
      | display_text   | action         | action_argument |
      | 1              | choose_slot    | 1               |

  Scenario: Simple Menu Selection Movement
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a menu controller
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
    And I move up in the menu
    Then the current menu entry should have:
      | display_text   | action         | action_argument |
      | 1              | choose_slot    | 1               |

  Scenario: Simple Menu Invocation
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a menu controller
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
    Then the game property "image_controller.images.size" should be "2"
    Then the game property "menu_controller.current_menu.image_menu?" should be "false"


  Scenario: Image Menu
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a menu controller
    And I load the main menu "image_menu.yml"
    When I enter the menu
    Then the game property "image_controller.images.size" should be "4"
    Then the game property "menu_controller.current_menu.image_menu?" should be "true"

  Scenario: Image Menu Drawing
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a menu controller
    And I load the main menu "image_menu.yml"
    When I enter the menu
    And I run the game loop 1 times

  Scenario: Equipment Menu - Empty
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a menu controller
    When I enter the menu "equipment" with filter "nil"
    Then the game property "player.inventory.items.size" should be "0"
    Then the game property "menu_controller.current_menu.lines.size" should be "0"



  Scenario: Equipment Menu - Non Empty
    Given I load the game "demo_inventory"
    When I enter the menu "equipment" with filter "nil"
    When the player takes reward "test-data/equipment/weapon.yml"
    Then the game property "player.inventory.items.size" should be "1"
    Then the game property "menu_controller.current_menu.lines.size" should be "1"
    Then the current menu entry should have:
      | display_text    | action         | argument                |
      | TestWeaponAlpha | equip_item     | test-data/equipment/weapon.yml |

  Scenario: Equipment Menu - Invocation
    Given I load the game "demo_inventory"
    When I enter the menu "equipment" with filter "nil"
    When the player takes reward "test-data/equipment/weapon_swung.yml"
    Then the game property "player.inventory.items.size" should be "1"
    Then the game property "menu_controller.current_menu.lines.size" should be "1"
    Then the game property "player.inventory.weapon.nil?" should be "true"
    When I invoke the current menu action
    Then the game property "player.inventory.weapon.display_name" should be "'TestWeaponSwung'"

 Scenario: Menu Configuration
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a menu controller
    And I load the main menu "positioned_menu.yml"
    When I enter the menu
    Then the menu's "x_spacing" should be "15"
    