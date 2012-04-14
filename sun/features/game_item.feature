Feature: GameItems
  In order to play the game
  As a player
  I want to be able to see myself in a level


  Scenario: Game Has Item Controller
    Given I load the game "game"
    Then the game property "game_item_controller" should not be nil
    Then the game property "game_item_controller.registered.size" should be "0"

  Scenario: Game Has Item Controller Registration
    Given I load the game "game"
    When I register a game item named "foo" with type "GameItemTypes::EQUIPPABLE" subtype "EquipmentTypes::SWORD" and power level "1"
    Then the game property "game_item_controller.registered.size" should be "1"

