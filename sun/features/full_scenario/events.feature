@needs_full_gosu
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
    And there should be 1 temporary renderings
    And I run the game loop 1 times
    And handle events
    Then there should be 1 enemies
    And the path following controller should be tracking 1 element
    Then the enemy named "Test Enemy" should have "age" equal to "0"
    And I run the game loop 1 times
    Then the enemy named "Test Enemy" should have "age" equal to "1"

  Scenario: Event Areas Validation
    Given I create a valid event area
    Then the event area should be valid

  Scenario Outline: Event Areas Validation - Requirements
    Given I create a valid event area
    When I unset the event area property "<property>"
    Then the event area should not be valid
    Examples:
    | property |
    | rect     |
    | action   |

  Scenario: Event Emitter Validation
    Given I create a valid event emitter
    Then the event emitter should be valid

  Scenario Outline: Event Areas Validation - Requirements
    Given I create a valid event emitter
    When I unset the event emitter property "<property>"
    Then the event emitter should not be valid
  Examples:
    | property              |
    | event_name           |
    | event_argument       |
    | collision_primitive |
