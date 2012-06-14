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

  Scenario: Customization Controller Manual
    Given I load the game "demo_inventory" on level "customization"
    When I load and equip the weapon defined in "weapon.yml"
    When I load and equip the weapon defined in "weapon_sound.yml"
    When the player takes reward "test-data/equipment/weapon.yml"
    When the player takes reward "test-data/equipment/weapon_sound.yml"
    When I set the customization item to "test-data/equipment/weapon.yml"
    When I set the customization item to "test-data/equipment/weapon_sound.yml"
    When I proceed with customization
    Then the game property "player.inventory.items.size" should be "1"



  Scenario: Customization Controller Automatic
    Given I load the game "demo_inventory" on level "customization"
    When I load and equip the weapon defined in "weapon.yml"
    When I load and equip the weapon defined in "weapon_sound.yml"
    When the player takes reward "test-data/equipment/weapon.yml"
    When the player takes reward "test-data/equipment/weapon_sound.yml"
    When I set the customization item to "test-data/equipment/weapon.yml"
    When I set the customization item to "test-data/equipment/weapon_sound.yml"
    Then the game property "player.inventory.items.size" should be "2"
    Then there should be 1 active event areas
    When I simulate "Graphics::KbO"
    And I run the game loop 1 times
    Then the game property "player.inventory.items.size" should be "1"



