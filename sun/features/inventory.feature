Feature: Inventory
  In order to have items and equipment
  As a player
  I want to see have an inventory of items

  Scenario: Inventory on Player
    Given I load the game "new_game_load_screen"
    Then the game property "player.inventory.class" should be "Inventory"

  Scenario: Game Inventory Controller Empty
    Given I load the game "new_game_load_screen"
    Then the game property "inventory_controller.class" should be "InventoryController"
    Then the game property "inventory_controller.items.size" should be "0"

  Scenario: Game Inventory Controller From Player
    Given I load the game "demo_weapon"
    Then the game property "inventory_controller.items.size" should be "1"

  Scenario: Game Inventory Controller From File
    Given I load the game "demo_inventory"
    Then the game property "inventory_controller.items.size" should be "3"
    