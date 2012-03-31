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
      | 100, 100 | hundredhundred | 1 enemies every 5 ticks for 0 total ticks until COND  | e2, e3         | 1              | 5         |            | COND      |




