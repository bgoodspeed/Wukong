Feature: Spawn Points
  In order to play a level
  As a player
  I want to be fight off enemies that are spawned at given points

  Scenario: Spawn Point
    Given I load the game on level "demo" with screen size 640, 480
    When the level is examined
    Then there should be 2 spawn points
    Then the spawn points should be:
      | point    | name           | spawn_schedule                                        | spawn_argument | enemy_quantity | frequency | total time | condition |
      | 50, 50   | fiftyfifty     | 2 enemies every 10 ticks for 100 total ticks          | e1             | 2              | 10        | 100        |           |
      | 100, 100 | hundredhundred | 1 enemies every 5 ticks for 0 total ticks until COND  | e2,e3          | 1              | 5         |            | COND      |

  Scenario: Spawn Point - Spawning
    Given I load the game on level "simple" with screen size 640, 480
    And I create a condition controller
    And I stub "foo" on game to return "false"
    When I add a fake condition that checks "foo" on game named "COND"
    When the spawn points are updated
    Then a "EventTypes::SPAWN" event should be queued
    And the "EventTypes::SPAWN" event should have "argument.class" equal to "Enemy"

  Scenario: Spawn Point - Spawning not yet
    Given I load the game on level "simple" with screen size 640, 480
    And I create a condition controller
    And I stub "foo" on game to return "true"
    When I add a fake condition that checks "foo" on game named "COND"
    When the spawn points are updated
    And there should be no events queued

  Scenario: Spawn Point - Spawning Wired into Game tick
    Given I load the game on level "simple" with screen size 640, 480
    And I create a condition controller
    And I stub "foo" on game to return "false"
    When I add a fake condition that checks "foo" on game named "COND"
    And I run the game loop 1 times
    Then a "EventTypes::SPAWN" event should be queued
    And the "EventTypes::SPAWN" event should have "argument.class" equal to "Enemy"




