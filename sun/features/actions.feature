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
   | action                        | game_prop                  | game_value_init                        | game_value_final                | stubs                                           | expects | set                          |
   | EventTypes::DEATH             | player.enemies_killed      | 0                                      | 1                               | argument                                        |         |                              |
   | KeyActions::DOWN              | player.position            | [320, 240]                             | [320.0, 242.0]                  |                                                 |         | gameplay_behaviors           |
   | EventTypes::START_NEW_GAME    | level.name                 | 'load_screen'                          | 'demo'                          | argument:test-data/levels/demo/demo.yml         |         | event_actions                |
   | EventTypes::LOAD_LEVEL        | level.name                 | 'load_screen'                          | 'demo'                          | argument:test-data/levels/demo/demo.yml         |         | event_actions                |
   | BehaviorTypes::UPGRADE_PLAYER | player.image_path          | 'test-data/sprites/player20120411.png' | 'test-data/sprites/avatar2.bmp' | argument:test-data/sprites/avatar2.bmp          |         | always_available_behaviors   |
   | BehaviorTypes::EQUIPMENT_MENU | menu_mode?                 | false                                  | true                            | argument:SOMEEQUIPMENTTYPE                      |         | always_available_behaviors   |

  Scenario Outline: Actions being invoked event and keys with inventory
    Given I load the game "demo_inventory"
    Then the game property "<game_prop>" should be "<game_value_init>"
    When I invoke the action "<action>" with argument stubbing "<stubs>" and expecting "<expects>" and set "<set>"
    Then the game property "<game_prop>" should be "<game_value_final>"
  Examples:
   | action                        | game_prop                    | game_value_init                        | game_value_final                | stubs                                                        | expects | set                          |
   | BehaviorTypes::EQUIP_ITEM     | player.inventory.weapon.nil? | true                                   | false                           | argument:test-data/equipment/weapon_swung.yml   |         | menu_actions                 |

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
    