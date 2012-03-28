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
