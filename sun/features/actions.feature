Feature: Action
  In order to respond to events
  As a programmer
  I want to be able to invoke events

  Scenario Outline: Actions being invoked
    Given I load the game on level "trivial" with screen size 640, 480
    Then the game property "<game_prop>" should be "<game_value_init>"
    When I invoke the action "<action>" with argument stubbing "<stubs>" and expecting "<expects>"
    Then the game property "<game_prop>" should be "<game_value_final>"
  Examples:
   | action            | game_prop             | game_value_init | game_value_final | stubs    | expects |
   | EventTypes::DEATH | player.enemies_killed | 0               | 1                | argument |         |
   | EventTypes::SPAWN | enemies.size          | 0               | 1                | argument |         |
   | EventTypes::SPAWN | enemies.size          | 0               | 1                | argument |         |

