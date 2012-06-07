Feature: Game
  In order to play the game
  As a player
  I want to be able to see myself in a level

  Scenario: Trivial Level
    Given I load the game on level "trivial" with screen size 640, 480
    When I see the first frame
    Then I should be at 36,36 in the game space

  Scenario: Full Game Loading
    Given I load the game "game"
    When I see the first frame
    Then I should be at 200,300 in the game space

  Scenario: New Game Loading Level
    Given I load the game "new_game_load_screen"
    When I see the first frame
    Then I should be at 320,240 in the game space
    And there should be 4 event areas
    And the event areas should be:
        | label          | action                      | description joined       |
        | Start New Game | queue_start_new_game_event  | foo barbaz quzafterblank |
        | Load Game      | queue_load_game_event       | monkeys                  |
        | Settings       | queue_settings_event        | Mystery?                 |
        | Continue       | continue_last_game        | Mystery?                 |

  Scenario: Reward Level
    Given I load the game "reward"
    When I see the first frame
    Then I should be at 320,240 in the game space
    And there should be 4 event areas
    And the event areas should be:
        | label                 | action                      | action_argument      |
        | Reward                | take_reward                 |                      |
        | Upgrade Player Avatar | upgrade_player              | foo/bar/player42.yml |
        | Save                  | queue_save_game_event       |                      |
        | Load Level            | LOAD_LEVEL                  | some/level.yml       |

  Scenario: Equip Level
    Given I load the game "equip"
    When I see the first frame
    And there should be 2 event areas
    And the event areas should be:
        | label                 | action                      | action_argument      |
        | Equip Weapon         | equipment_menu             | weapon                |
    And the game property "level.equipment_renderables.size" should be "2"

  Scenario: Multiple Event Area Actions
    Given I load the game "multiple_event_area_actions"
    When I see the first frame
    And there should be 1 event areas
    And the event areas should be:
        | label                 | action                        | action_argument      |
        | Start New Game       | queue_start_new_game_event |                        |
    And the game property "level.event_areas.first.extra_actions.size" should be "2"
    And the game property "level.event_areas.first.access_allowed?" should be "true"

  Scenario: Event Area Access Control
    Given I load the game "event_area_access"
    When I see the first frame
    And there should be 2 event areas
    And the game property "level.event_areas.first.conditions.size" should be "1"
    And the game property "level.event_areas.first.access_allowed?" should be "false"
    And the game property "level.event_areas.last.conditions.size" should be "2"
    And the game property "level.event_areas.last.access_allowed?" should be "true"

  Scenario: One-Time Event Area Actions Invocation
    Given I load the game "one_time_event_area_actions"
    And I set the player position to 100,100
    Then the game property "player.upgrade_points" should be "0"
    And the game property "level.event_areas.first.one_time" should be "true"
    And the game property "level.event_areas.first.active?" should be "true"
    When I simulate "Graphics::KbO"
    When I run the game loop 1 times
    And the game property "player.upgrade_points" should be "77"
    And the game property "level.event_areas.first.active?" should be "false"

  Scenario: Event Area Image
    Given I load the game "event_area_image"
    When I run the game loop 1 times
    And the game property "level.event_areas.first.image_file.nil?" should be "false"


  Scenario: Multiple Event Area Actions Invocation 1
    Given I load the game "multiple_event_area_actions"
    And I set the player position to 100,100
    Then the game property "player.upgrade_points" should be "0"
    And the game property "level.event_areas.first.one_time" should be "false"
    When I simulate "Graphics::KbO"
    When I run the game loop 1 times
    Then a "EventTypes::START_NEW_GAME" event should be queued
    And the game property "player.upgrade_points" should be "77"
    And the game property "level.event_areas.size" should be "1"
    And the game property "level.event_areas.first.image_file.nil?" should be "true"

  Scenario: Multiple Event Area Actions Invocation 2
    Given I load the game "multiple_event_area_actions2"
    And I set the player position to 100,100
    Then the game property "player.progression.level_background_rank" should be "0"
    When I simulate "Graphics::KbO"
    When I run the game loop 1 times
    Then the game property "player.progression.level_background_rank" should be "1"



  Scenario: New Game Loading Level Invoke Event Area - New Game
    Given I load the game "new_game_load_screen"
    And I set the player position to 100,100
    When I simulate "Graphics::KbO"
    When I run the game loop 1 times
    And a "EventTypes::START_NEW_GAME" event should be queued

  Scenario: New Game Loading Level Off Event Area
    Given I load the game "new_game_load_screen"
    And I set the player position to 320,240
    When I simulate "Graphics::KbO"
    When I run the game loop 1 times
    And there should be no events queued

  Scenario: New font settings
    Given I load the game "demo_font_config"
    Then the game property "font_controller.font_size" should be "18"


  Scenario: Game Validation
    Given I create a valid game
    Then the game should be valid

  Scenario Outline: Game Validation - Requirements
    Given I create a valid game
    When I unset the game property "<property>"
    Then the game should not be valid
  Examples:
    | property              |
    | new_game_level      |