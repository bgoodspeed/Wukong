Feature: Level Description
  In order to play a level
  As a player
  I want to be able to know what is in a level

  Scenario: Trivial Level
    Given I load the level "trivial"
    When the level is examined
    Then the level should measure 640, 480
    Then there should be 4 line segments
    And there should be 0 triangles
    And there should be 0 circles
    And there should be 0 rectangles
    And the minimum x is 0
    And the maximum x is 640
    And the minimum y is 0
    And the maximum y is 480
    And the background image is named "grass.jpg"

  Scenario: Large Level
    Given I load the level "large"
    When the level is examined
    Then the level should measure 1280, 960
    Then there should be 4 line segments
    And the minimum x is 0
    And the maximum x is 1280
    And the minimum y is 0
    And the maximum y is 960
    And the background image is named "grass.jpg"

  Scenario: Huge Level
    Given I load the level "huge"
    When the level is examined
    Then the level should measure 2560, 1920
    Then there should be 4 line segments
    And the minimum x is -1280
    And the maximum x is 1280
    And the minimum y is -960
    And the maximum y is 960
    And the background image is named "grass.jpg"

  Scenario: Event Emitter Level
    Given I load the level "emitter"
    When the level is examined
    Then there should be 1 event emitter
    And the event emitters are:
      | position | radius  | event_name | event_argument |
      | 100,200  | 5       | play_sound | land_mine_boom |

  Scenario: Obstacle Level
    Given I load the game on level "obstacle" with screen size 640, 480
    When the level is examined
    Then the level should measure 640, 480
    Then there should be 5 line segments
    And wayfinding should not be nil

  Scenario: Demo Level
    Given I load the game on level "demo" with screen size 640, 480
    When the level is examined
    Then the level should measure 640, 480
    Then there should be 5 line segments
    Then there should be be 3 enemies defined
    And there should be 2 spawn points

  Scenario: Level Completion
    Given I load the game on level "completion_at_frame_two" with screen size 640, 480
    When I run the game loop 1 times
    Then the level completion status should be "false"
    When I run the game loop 1 times
    Then the level completion status should be "true"

  Scenario: Level Completion Combined
    Given I load the game on level "combined" with screen size 640, 480
    And I set the player health to 100
    When I run the game loop 1 times
    Then the level completion status should be "false"
    When I run the game loop 1 times
    Then the level completion status should be "false"
    And I set the player position to 100,100
    When I run the game loop 1 times
    Then the level completion status should be "true"
    