Feature: Action
  In order to respond to events
  As a programmer
  I want to be able to invoke events

  Scenario Outline: Actions being invoked event and keys
    Given I load the game "new_game_load_screen"
    Then the game property "<game_prop>" should be "<game_value_init>"
    When I invoke the action "<action>" with argument stubbing "<stubs>" and expecting "<expects>" and set "<set>"
    Then the game property "<game_prop>" should be "<game_value_final>"
  Examples:
   | action                               | game_prop                  | game_value_init                        | game_value_final                               | stubs                                           | expects | set                          |
   | EventTypes::DEATH                    | player.enemies_killed      | 0                                 | 1                                              | argument                                        |         |                              |
   | KeyActions::DOWN                     | player.position            | GVector.xy(320, 240)             | GVector.xy(320.0, 242.0)                   |                                                 |         | gameplay_behaviors           |
   | EventTypes::START_NEW_GAME           | level.name                 | 'load_screen'                          | 'demo'                                         | argument:test-data/levels/demo/demo.yml         |         | event_actions                |
   | EventTypes::LOAD_LEVEL               | level.name                 | 'load_screen'                          | 'demo'                                         | argument:test-data/levels/demo/demo.yml         |         | event_actions                |
   | EventTypes::LOAD_LEVEL               | old_level_name             | nil                                    | 'test-data/levels/load_screen/load_screen.yml' | argument:test-data/levels/demo/demo.yml         |         | event_actions                |
   | BehaviorTypes::UPGRADE_PLAYER        | player.image_path          | 'test-data/sprites/player20120411.png' | 'test-data/sprites/avatar2.bmp'                | argument:test-data/sprites/avatar2.bmp          |         | always_available_behaviors   |
   | BehaviorTypes::EQUIPMENT_MENU        | menu_mode?                 | false                                  | true                                           | argument:SOMEEQUIPMENTTYPE                      |         | always_available_behaviors   |
   | EventTypes::PICK                     | nil?                       | false                                  | false                                          | argument:SOMEEQUIPMENTTYPE                      |         |                              |
   | BehaviorTypes::QUEUE_SAVE_GAME_EVENT | menu_mode?                 | false                                  | true                                           |                                                 |         | always_available_behaviors   |

  Scenario Outline: Actions being invoked event and keys with inventory
    Given I load the game "demo_inventory"
    Then the game property "<game_prop>" should be "<game_value_init>"
    When I invoke the action "<action>" with argument stubbing "<stubs>" and expecting "<expects>" and set "<set>"
    Then the game property "<game_prop>" should be "<game_value_final>"
  Examples:
   | action                        | game_prop                    | game_value_init                        | game_value_final                | stubs                                                        | expects | set                          |
   | BehaviorTypes::EQUIP_ITEM     | player.inventory.weapon.nil? | true                                   | false                           | argument:test-data/equipment/weapon_swung.yml                |         | menu_actions                 |
   | BehaviorTypes::TAKE_REWARD    | player.inventory.items.size  | 0                                      | 1                               | argument:test-data/equipment/weapon_swung.yml                |         | menu_actions                 |

  Scenario Outline: Actions being invoked collision response
    Given I load the game on level "trivial" with screen size 640, 480
    Then the game property "<game_prop>" should be "<game_value_init>"
    When I setup a collision between stubs "<c1stubs>", expects "<c1expects>" and stubs "<c2stubs>", expects "<c2expects>"
    When I invoke the action "<action>" on collision with set "<set>"
    Then the game property "<game_prop>" should be "<game_value_final>"
  Examples:
   | action                         | game_prop             | game_value_init | game_value_final | c1stubs | c1expects | c2stubs | c2expects      | set                  |
   | ResponseTypes::BLOCKING2       | player.enemies_killed | 0               | 0                |         |           |         | undo_last_move | collision_responses  |
   | ResponseTypes::TRIGGER_EVENT1  | player.enemies_killed | 0               | 0                |         | trigger   |         |                | collision_responses  |


  Scenario: Menu Actions being invoked event Load
    Given I load the game "new_game_load_screen"
    When I invoke the action "BehaviorTypes::LOAD_GAME_SLOT" with argument "'1'"
    Then the game property "level.name" should be "'demo'"

  Scenario: Menu Actions being invoked event Save
    Given I load the game "new_game_load_screen"
    And I set the property "game_load_path" to "test-data/loadarea"
    Then the last saved time should be nil
    When I invoke the action "BehaviorTypes::SAVE_GAME_SLOT" with argument "'9'"
    Then the last saved time should not be nil

  Scenario: Going back to a given level
    Given I load the game "new_game_load_screen"
    Then the game property "level.name" should be "'load_screen'"
    And I set the property "old_level_name" to "test-data/levels/demo/demo.yml"
    When I invoke the action "EventTypes::BACK_TO_LEVEL"
    Then the game property "level.name" should be "'demo'"

  Scenario: Continuing Last Saved Game A
    Given I load the game "new_game_load_screen"
    And I set the property "game_load_path" to "test-data/loadarea_continue_a"
    When I invoke the action "BehaviorTypes::CONTINUE_LAST_GAME"
    Then the game property "level.name" should be "'demo'"

  Scenario: Continuing Last Saved Game B
    Given I load the game "new_game_load_screen"
    And I set the property "game_load_path" to "test-data/loadarea_continue_b"
    When I invoke the action "BehaviorTypes::CONTINUE_LAST_GAME"
    Then the game property "level.name" should be "'reward'"

  Scenario: Continuing Last Saved Game None Saved
    Given I load the game "new_game_load_screen"
    And I set the property "game_load_path" to "test-data/loadarea_continue_none"
    When I invoke the action "BehaviorTypes::CONTINUE_LAST_GAME"
    Then the game property "level.name" should be "'load_screen'"

  Scenario: Taking Damage on player with sufficient health does not render anything only level fade in
    Given I load the game "new_game_load_screen"
    Then there should be 1 temporary renderings

  Scenario: Taking Damage on player causes full screen damage effect
    Given I load the game "new_game_load_screen"
    When I set the player health to 1
    When I set the player max health to 10
    And I run the game loop 1 times
    Then there should be 2 temporary renderings
    When I set the player health to 10
    And I run the game loop 1 times
    Then there should be 1 temporary renderings

