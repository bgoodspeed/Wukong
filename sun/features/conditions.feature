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
    

