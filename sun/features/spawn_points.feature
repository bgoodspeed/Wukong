Feature: Spawn Points
  In order to play a level
  As a player
  I want to be fight off enemies that are spawned at given points

  Scenario: Spawn Point
    Given I load the game on level "demo" with screen size 640, 480
    When the level is examined
    Then there should be 2 spawn points
    Then the spawn points should be:
      | point    | name           | spawn_schedule                   | spawn_argument |
      | 50, 50   | fiftyfifty     | once                             | e1             |
      | 100, 100 | hundredhundred | every 2 ticks for 10 ticks       | e2, e3         |

