Feature: Conditions
  In order to make the game respond
  As a player
  I want to have conditions by name that are met by the game

  Scenario: Condition Manager
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a condition manager
    And I stub "foo" on game to return "true"
    And I stub "bar" on game to return "false"
    When I add a fake condition that checks "foo" on game named "COND1"
    When I add a fake condition that checks "bar" on game named "COND2"
    Then asking if game condition "COND1" is met should be "true"
    Then asking if game condition "COND2" is met should be "false"
    
  Scenario Outline: Conditions being checked
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a condition manager
    And I stub "<final_prop>" on games "<game_prop>" to return "<final_value>"
    And I update the game state
    Then asking if game condition "<condition>" with arg "<condition_argument>" is met should be "<expected>"
  Examples:
   | final_prop      | game_prop    | final_value  | condition               | condition_argument | expected |
   | health          | player       | 4            | player_health_at_least  | 3                  | true     |
   | health          | player       | 4            | player_health_at_least  | 4                  | true     |
   | health          | player       | 4            | player_health_at_least  | 5                  | false    |
   | frames_rendered | clock        | 12           | number_of_frames        | 13                 | false    |
   | frames_rendered | clock        | 12           | number_of_frames        | 12                 | true     |
   | frames_rendered | clock        | 12           | number_of_frames        | 11                 | true     |
   | enemies_killed  | player       | 12           | enemies_killed_at_least | 13                 | false    |
   | enemies_killed  | player       | 12           | enemies_killed_at_least | 12                 | true     |
   | enemies_killed  | player       | 12           | enemies_killed_at_least | 11                 | true     |
   | position        | player       | 2, 3         | player_near             | 200, 200           | false    |
   | position        | player       | 200, 200     | player_near             | 200, 200           | true     |


