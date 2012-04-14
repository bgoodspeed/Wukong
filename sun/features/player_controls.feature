Feature: Player Controls
  In order to play the game
  As a player
  I want to be able to control myself in a level

  Scenario: Mapping input to movements and actions
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I set the player step size to 25
    When I press "Right"
    And I press "Up"
    And I update the game state
    Then the player should be at position 61,36
    And the following keys should be active: "Right,Up"

  Scenario: Mocking Gosu Input
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I set the player step size to 25
    When I simulate "Graphics::KbLeft,Graphics::KbDown"
    And I update the key state
    And the following keys should be active: "Left,Down"

  Scenario: Mocking Gosu Input Weapons
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I set the player step size to 25
    When I simulate "Graphics::KbSpace"
    And I update the key state
    And the following keys should be active: "Fire"

  Scenario: Mapping input to movements and actions firing weapons
    Given I load the game on level "trivial" with screen size 640, 480
    And I create an animation controller with a ratio of one animation tick to 1 game ticks
    And I create the path following controller
    And I set the player avatar to "avatar.bmp"
    And I set the player step size to 25
    And I set the player weapon with image "weapon.png"
    And I set the player weapon type to "projectile"
    When I press "Fire"
    And I update the game state
    Then the player weapon should be in use
    Then there should be projectiles at:
      | expected_position |
      | 36,26             |

  Scenario: Mapping Q to quit
    Given I load the game on level "trivial" with screen size 640, 480
    When I simulate "Graphics::KbQ"
    And I update the key state
    And the following keys should be active: "Quit"

  Scenario: Mapping quit to exit game
    Given I load the game on level "trivial" with screen size 640, 480
    When I press "Quit"
    And I update the game state
    Then the game should call quit

  Scenario: Mapping M to menu
    Given I load the game on level "trivial" with screen size 640, 480
    When I simulate "Graphics::KbM"
    And I update the key state
    And the following keys should be active: "Menu"

  Scenario: Mapping menu to enter menu
    Given I load the game on level "trivial" with screen size 640, 480
    And I create the HUD
    And I create a menu controller
    And I create a new menu called "fake":
      """
      menu:
        menu_id: pick_slot
        entries:
          - display_text: Alpha
            action: choose_slot
      """
    And I set the main menu name to "fake"
    When I press "Menu"
    And I update the game state
    Then the game should be in menu mode

  Scenario: Mapping Enter to menu_enter
    Given I load the game on level "trivial" with screen size 640, 480
    When I simulate "Graphics::KbEnter"
    And I update the key state
    And the following keys should be active: "MenuEnter"

  Scenario: Mapping menu to enter menu
    Given I load the game on level "trivial" with screen size 640, 480
    And I create the HUD
    And I create a menu controller
    And I register a fake action to return triple the argument called "choose_slot"
    And I create a new menu called "fake":
      """
      menu:
        menu_id: pick_slot
        entries:
          - display_text: Alpha
            action: choose_slot
            action_argument: 7
      """
    And I set the main menu name to "fake"
    When I press "Menu"
    And I update the game state
    When I press "MenuEnter"
    And I update the game state
    Then the breadcrumb trail should have the following:
      | menu_id   | action      | action_argument | action_result |
      | pick_slot | choose_slot | 7               | 21            |


   Scenario: Input controller from Yaml
     Given I load the game on level "trivial" with screen size 640, 480
     And I create an input controller from config file "input_config.yml"
     Then the input controllers mapping should contain:
       | api_keysym  | keyaction      |
       | Graphics::KbUp  | KeyActions::UP |


  Scenario: Mapping menu to exit menu
    Given I load the game on level "trivial" with screen size 640, 480
    And I create the HUD
    And I create a menu controller
    And I register a fake action to return triple the argument called "choose_slot"
    And I create a new menu called "fake":
      """
      menu:
        menu_id: pick_slot
        entries:
          - display_text: Alpha
            action: choose_slot
            action_argument: 7
      """
    And I set the main menu name to "fake"
    When I simulate "Graphics::KbM"
    And I run the game loop 5 times
    Then the game should be in menu mode
    When I simulate "Graphics::KbM"
    And I run the game loop 1 times
    Then the game should not be in menu mode
