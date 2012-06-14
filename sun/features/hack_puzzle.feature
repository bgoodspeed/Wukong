Feature: Hack Puzzle
  In order to broaden the appeal of the game
  As a player
  I want to be able to solve puzzles

  Scenario: Hack Puzzle Elements
    Given I load the game on level "hack_puzzle" with screen size 640, 480
    Then the game property "level.event_areas.size" should be "10"
    Then the game property "level.hack_puzzle_key" should be "'AAB'"

  Scenario: Hack Puzzle Progression
    Given I load the game on level "hack_puzzle" with screen size 640, 480
    When I set the player position to 15,15
    Then the game property "level.current_hack_puzzle" should be "''"
    Then the game property "level.active_event_areas.size" should be "1"
    When I simulate "Graphics::KbO"
    And I run the game loop 1 times
    Then the game property "level.current_hack_puzzle" should be "'A'"


  Scenario: Hack Puzzle Progression Repeats
    Given I load the game on level "hack_puzzle" with screen size 640, 480
    When I set the player position to 15,15
    Then the game property "level.current_hack_puzzle" should be "''"
    Then the game property "level.active_event_areas.size" should be "1"
    When I simulate "Graphics::KbO"
    And I run the game loop 1 times
    Then the game property "level.current_hack_puzzle" should be "'A'"
    And I run the game loop 8 times
    When I simulate "Graphics::KbO"
    And I run the game loop 1 times
    Then the game property "level.current_hack_puzzle" should be "'AA'"


  Scenario: Hack Puzzle Progression Longer Length
    Given I load the game on level "hack_puzzle" with screen size 640, 480
    When I set the player position to 15,15
    Then the game property "level.current_hack_puzzle" should be "''"
    Then the game property "level.active_event_areas.size" should be "1"
    When I simulate "Graphics::KbO"
    And I run the game loop 1 times
    Then the game property "level.current_hack_puzzle" should be "'A'"
    When I set the player position to 65,15
    And I run the game loop 8 times
    When I simulate "Graphics::KbO"
    And I run the game loop 1 times
    Then the game property "level.current_hack_puzzle" should be "'AB'"

  Scenario: Hack Puzzle Progression Completion
    Given I load the game on level "hack_puzzle" with screen size 640, 480
    When I set the player position to 15,15
    Then the game property "level.current_hack_puzzle" should be "''"
    Then the game property "level.active_event_areas.size" should be "1"
    When I simulate "Graphics::KbO"
    And I run the game loop 1 times
    Then the game property "level.current_hack_puzzle" should be "'A'"
    And I run the game loop 8 times
    When I simulate "Graphics::KbO"
    And I run the game loop 1 times
    Then the game property "level.current_hack_puzzle" should be "'AA'"
    When I set the player position to 65,15
    And I run the game loop 1 times
    Then the game property "level.current_hack_puzzle" should be "'AAB'"
    Then the game property "level.completed?" should be "true"
    And I run the game loop 1 times
    Then the game property "level.name" should be "'demo'"

