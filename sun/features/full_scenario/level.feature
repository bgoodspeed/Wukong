@needs_full_gosu
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
    And the background music is named "music.wav"
    And the reward level is "foo"

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

  Scenario: Reward Level Save Menu
    Given I load the game "demo"
    Then the game property "menu_for_save_game" should be "'test-data/menus/save_game.yml'"


  Scenario: Reward Level HUD
    Given I load the game "game_with_level_hud"
    Then the game property "hud.lines.first" should be "'(HUD2)Player HP: 5/6'"
    
  Scenario: Demo Level starting position
    Given I load the game "demo_start"
    Then the game property "level.player_start_position" should be "[320, 240]"
    Then the game property "player.position" should be "[320, 240]"

  Scenario: Player avatar changing
    Given I load the game "reward"
    And I set the player position to 500,100
    When I run the game loop 1 times
    Then there should be 4 event areas
    Then there should be 1 active event areas
    And the active event area action should be "upgrade_player"
    And the active event area action argument should be "foo/bar/player42.yml"

  Scenario: Equip Level
    Given I load the game on level "equip" with screen size 640, 480
    When the level is examined
    Then there should be 2 event areas
    When I set the player position to 100,100
    Then there should be 1 active event areas
    And the active event area action should be "equipment_menu"
    And the active event area action argument should be "weapon"

  Scenario: Equip Level - Back Button
    Given I load the game on level "equip" with screen size 640, 480
    When the level is examined
    Then there should be 2 event areas
    When I set the player position to 100,400
    Then there should be 1 active event areas
    And the active event area action should be "back_to_level"
    