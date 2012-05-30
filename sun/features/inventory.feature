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

  Scenario: Player Inventory Filtered
    Given I load the game "demo_inventory"
    Then the player inventory filtered by "nil" should have size 0
    Then the game property "inventory_controller.items.size" should be "4"
    When the player takes reward "test-data/equipment/weapon.yml"
    When the player takes reward "test-data/equipment/weapon_sound.yml"
    When the player takes reward "test-data/equipment/weapon_swung.yml"
    Then the player inventory filtered by "nil" should have size 3
    Then the player inventory filtered by "InventoryTypes::WEAPON" should have size 3
    Then the player inventory filtered by "InventoryTypes::ARMOR" should have size 0
    Then the player inventory filtered by "InventoryTypes::POTION" should have size 0

  Scenario: Player Inventory Filtered 2
    Given I load the game "demo_inventory"
    Then the player inventory filtered by "nil" should have size 0
    Then the game property "inventory_controller.items.size" should be "4"
    When the player takes reward "test-data/equipment/weapon.yml"
    When the player takes reward "test-data/equipment/weapon_sound.yml"
    When the player takes reward "test-data/equipment/potion.yml"
    Then the player inventory filtered by "nil" should have size 3
    Then the player inventory filtered by "InventoryTypes::WEAPON" should have size 2
    Then the player inventory filtered by "InventoryTypes::ARMOR" should have size 0
    Then the player inventory filtered by "InventoryTypes::POTION" should have size 1

  Scenario: Player Inventory Yaml
    Given I load the game "demo_inventory"
    Then the player inventory filtered by "nil" should have size 0
    Then the game property "inventory_controller.items.size" should be "4"
    When the player takes reward "test-data/equipment/weapon.yml"
    When the player takes reward "test-data/equipment/weapon_sound.yml"
    When the player takes reward "test-data/equipment/weapon_swung.yml"
    Then the player stats should have property "strength" equal to "10"
    Then the equipment stats should have property "strength" equal to "0"
    Then the effective player stats should have property "strength" equal to "10"
    When the player equips the weapon "test-data/equipment/weapon_sound.yml"
    Then the player inventory weapon should not be nil
    And the player inventory yaml should match "weapon:"
    Then the player stats should have property "strength" equal to "10"
    Then the equipment stats should have property "strength" equal to "10"
    Then the effective player stats should have property "strength" equal to "20"

  Scenario: Inventory Acquisition
    Given I load the game "demo_inventory"
    And I add an enemy from "enemy_inventory.yml"
    Then the player inventory filtered by "InventoryTypes::WEAPON" should have size 0
    When the player acquires the enemy inventory
    Then the player inventory filtered by "InventoryTypes::WEAPON" should have size 1

  Scenario: Player Inventory Armor Equipping
    Given I load the game "demo_inventory_larger"
    Then the game property "inventory_controller.items.size" should be "5"
    When the player takes reward "test-data/equipment/armor.yml"
    Then the player stats should have property "defense" equal to "5"
    Then the equipment stats should have property "defense" equal to "0"
    Then the effective player stats should have property "defense" equal to "5"
    When the player equips the armor "test-data/equipment/armor.yml"
    Then the player inventory armor should not be nil
    Then the player stats should have property "defense" equal to "5"
    Then the equipment stats should have property "defense" equal to "10"
    Then the effective player stats should have property "defense" equal to "15"
