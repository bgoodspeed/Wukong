Feature: Events
  In order to make the game respond
  As a player
  I want to have events triggered by proximity

  Scenario: Event Emitters
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a sound controller
    And I add a sound effect from "weapon.wav" called "foo"
    And I create an event emitter to play the "foo" sound
    When I trigger the event emitter
    And handle events
    Then the play count for sound effect "foo" should be 1
    
  Scenario: Spawn Events
    Given I load the game on level "simple" with screen size 640, 480
    And I create a condition controller
    And I stub "foo" on game to return "false"
    When I add a fake condition that checks "foo" on game named "COND"
    And I run the game loop 1 times
    And handle events
    Then there should be 1 enemies
