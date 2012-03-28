Feature: Events
  In order to make the game respond
  As a player
  I want to have events triggered by proximity

  Scenario: Event Emitters
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a sound manager
    And I add a sound effect from "weapon.wav" called "foo"
    And I create an event emitter to play the "foo" sound
    When I trigger the event emitter
    Then the play count for sound effect "foo" should be 1
    

