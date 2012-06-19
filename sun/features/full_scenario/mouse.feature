@needs_full_gosu
Feature: Mouse
  In order to play a level
  As a player
  I want to be able to click on things in the game

  Scenario: Left Click
    Given I load the game on level "demo" with screen size 640, 480
    When the level is examined
    When I simulate "Graphics::MsLeft"
    And I update the key state
    And I set the mouse position to 100, 200 in screen coords
    And the following keys should be active: "MouseClick"
    
  Scenario: Off Screen
    Given I load the game on level "demo" with screen size 640, 480
    When the level is examined
    When I simulate "Graphics::MsLeft"
    And I update the key state
    And I set the mouse position to 0, 0 in screen coords
    Then the mouse should be considered off screen

  Scenario: In Screen
    Given I load the game on level "demo" with screen size 640, 480
    When the level is examined
    When I simulate "Graphics::MsLeft"
    And I update the key state
    And I set the mouse position to 1, 1 in screen coords
    Then the mouse should be considered on screen

  Scenario: Left Click in Menu
    Given I load the game on level "demo" with screen size 640, 480
    And I set the mouse position to 30, 50 in screen coords
    And I create a menu controller
    And I load the main menu "main.yml"
    And I create the HUD from file "hud_config.yml"   
    When I enter the menu
    When I simulate "Graphics::MsLeft"
    And I update the key state
    And the following keys should be active: "MouseClick"

  Scenario: Left Click in Menu 2
    Given I load the game on level "demo" with screen size 640, 480
    And I set the mouse position to 30, 40 in screen coords
    And I create a menu controller
    And I load the main menu "noop.yml"
    And I create the HUD from file "hud_config.yml"
    When I enter the menu
    When I press "MouseClick"
    And I update the game state
    Then the current mouse menu entry should have:
      | display_text   |
      | Option One     |

  Scenario: Left Click in Image Menu 
    Given I load the game on level "demo" with screen size 640, 480
    And I set the mouse position to 30, 40 in screen coords
    And I create a menu controller
    And I load the main menu "image_menu.yml"
    And I create the HUD from file "hud_config.yml"
    When I enter the menu
    When I press "MouseClick"
    And I update the game state
    Then the current mouse menu entry should have:
      | display_text   |
      | Jelly 1        |

  Scenario: Left Click in Menu Miss
    Given I load the game on level "demo" with screen size 640, 480
    And I set the mouse position to 300, 400 in screen coords
    And I create a menu controller
    And I load the main menu "noop.yml"
    And I create the HUD from file "hud_config.yml"
    When I enter the menu
    When I press "MouseClick"
    And I update the game state
    Then the current mouse menu entry should be nil

  Scenario: Equipment Menu - Mouse Miss
    Given I load the game "demo_inventory"
    And I set the mouse position to 300, 400 in screen coords
    When I enter the menu "equipment" with filter "nil"
    When I press "MouseClick"
    And I update the game state
    Then the current mouse menu entry should be nil

  Scenario: Equipment Menu - Mouse Hit
    Given I load the game "demo_inventory"
    When the player takes reward "test-data/equipment/weapon_swung.yml"
    When the player takes reward "test-data/equipment/weapon.yml"
    And I set the mouse position to 30, 50 in screen coords
    When I enter the menu "equipment" with filter "nil"
    And I update the game state
    Then the current mouse menu entry should have:
      | display_text    |
      | TestWeaponAlpha |


  Scenario: Picking - Nothing
    Given I load the game on level "simple" with screen size 640, 480
    And I set the mouse position to 360, 360 in screen coords
    And I load a player from "player.yml"
    And I create a condition controller
    And I stub "foo" on game to return "true"
    When I add a fake condition that checks "foo" on game named "COND"
    When I see the first frame
    When I press "MouseClick"
    And I update the game state
    Then the player should be in the scene
    And the player should be at position 36,36
    And there should be no events queued

   Scenario: Picking - Player
    Given I load the game on level "demo" with screen size 640, 480
    And I set the mouse position to 36, 36 in screen coords
    And I load a player from "player.yml"
    When I see the first frame
    When I press "MouseClick"
    And I update the game state
    Then the player should be in the scene
    And the player should be at position 36,36
    And a "EventTypes::PICK" event should be queued
    And the "EventTypes::PICK" event should have "argument.class" equal to "Player"
    


   Scenario: Picking - Enemy
    Given I load the game on level "demo" with screen size 640, 480
    And I set the mouse position to 200, 200 in screen coords
    And I load a player from "player.yml"
    And I add an enemy from "enemyp.yml"
    Then the enemy named "DefaultEnemyName" should have "position" equal to "GVector.xy(200,200)"
    When I see the first frame
    When I press "MouseClick"
    And I update the game state
    Then the player should be in the scene
    And the player should be at position 36,36
    And a "EventTypes::PICK" event should be queued
    And the "EventTypes::PICK" event should have "argument.class" equal to "Enemy"
