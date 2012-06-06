Feature: Game Progression
  In order to see the game evolve
  As a player
  I want to be able to progress through the game

  Scenario: Game Has Progression Controller
    Given I load the game "game"
    Then the game property "progression_controller" should not be nil

  Scenario: Player Has Game Progression
    Given I load the game "game"
    Then the game property "player.progression" should not be nil

  Scenario: Progression Defines Level Background Rank
    Given I load the game "game"
    Then the game property "player.progression.level_background_rank" should be "0"
    Then the game property "level.name" should be "'demo'"
    Then the game property "level.backgrounds_defined" should be "1"
    Then the game property "level.current_background.width" should be "680"

  Scenario: Multiple Level Backgrounds
    Given I load the game on level "multiple_backgrounds" with screen size 640, 480
    Then the game property "player.progression.level_background_rank" should be "0"
    Then the game property "level.name" should be "'multiple_backgrounds'"
    Then the game property "level.backgrounds_defined" should be "3"

  Scenario: Progression Controls Level Progress
    Given I load the game on level "multiple_backgrounds" with screen size 640, 480
    When I set the player level progress rank to 0
    Then the game property "level.current_background.width" should be "680"
    When I set the player level progress rank to 1
    Then the game property "level.current_background.width" should be "681"
    When I set the player level progress rank to 2
    Then the game property "level.current_background.width" should be "682"
    When I set the player level progress rank to 3
    Then the game property "level.current_background.width" should be "682"



