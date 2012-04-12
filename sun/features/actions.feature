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
   | action                     | game_prop             | game_value_init | game_value_final | stubs                                           | expects | set                          |
   | EventTypes::DEATH          | player.enemies_killed | 0               | 1                | argument                                        |         |                              |
   | EventTypes::SPAWN          | enemies.size          | 0               | 1                | argument                                        |         |                              |
   | EventTypes::SPAWN          | enemies.size          | 0               | 1                | argument                                        |         |                              |
   | KeyActions::DOWN           | player.position       | [320, 240]      | [320.0, 242.0]   |                                                 |         | gameplay_behaviors           |
   | EventTypes::START_NEW_GAME | level.name            | 'load_screen'   | 'demo'           | argument:test-data/levels/demo/demo.yml         |         | event_actions                |

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


