Feature: Customization
  In order to improve items and equipment
  As a player
  I want to be able to combine items into better ones

  Scenario: Customization of Two Weapons
    Given I load the game "demo_inventory"
    When the player takes reward "test-data/equipment/weapon.yml"
    Then the game property "player.inventory.items.first.last.item.stats.strength" should be "10"
    When the player takes reward "test-data/equipment/weapon_sound.yml"
    Then the game property "player.inventory.items.size" should be "2"
    When I combine the inventory items named "test-data/equipment/weapon.yml" and "test-data/equipment/weapon_sound.yml"
    Then the game property "player.inventory.items.size" should be "1"
    Then the game property "player.inventory.items.first.last.item.stats.strength" should be "20"

  Scenario: Customization of Two Weapons Quantity Issues
    Given I load the game "demo_inventory"
    When the player takes reward "test-data/equipment/weapon.yml"
    When the player takes reward "test-data/equipment/weapon.yml"
    When the player takes reward "test-data/equipment/weapon.yml"
    Then the game property "player.inventory.items.size" should be "1"
    When I combine the inventory items named "test-data/equipment/weapon.yml" and "test-data/equipment/weapon.yml"
    Then the game property "player.inventory.items.size" should be "2"

  Scenario: Customization of Two Weapons
    Given I load the game on level "customization" with screen size 640, 480
    Then the game property "level.customization_renderables.size" should be "2"
    Then the game property "level.customization_renderables.size" should be "2"


