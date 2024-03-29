Feature: Push Puzzle
  In order to broaden the appeal of the game
  As a player
  I want to be able to solve puzzles

  Scenario: Push Puzzle Elements
    Given I load the game on level "push_puzzle" with screen size 640, 480
    Then the game property "level.pushable_elements.size" should be "2"
    Then the game property "level.pushable_elements.first.position" should be "GVector.xy(50,50)"
    Then the game property "level.pushable_elements.first.width" should be "10"
    Then the game property "level.pushable_elements.first.height" should be "5"
    Then the game property "level.pushable_elements.last.height" should be "7"
    Then the game property "level.push_targets.size" should be "2"
    Then the game property "level.push_targets.first.position" should be "GVector.xy(200,200)"

  Scenario: Push Puzzle Elements Collision Conf - No Collisions
    Given I load the game on level "push_puzzle" with screen size 640, 480
    When I set the player position to 600,400
    And I run the game loop 1 times
    And I run the game loop 1 times

  Scenario: Push Puzzle - Pushing
    Given I load the game on level "push_puzzle" with screen size 640, 480
    When I set the player position to 50,92
    And I simulate "Graphics::KbUp"
    And I run the game loop 1 times
    Then the player should be at position 50,91
    And the game property "level.pushable_elements.first.position" should be "GVector.xy(50,49)"

  Scenario: Push Puzzle - Blocked Push Fizzles Element
    Given I load the game on level "push_puzzle_blocked" with screen size 640, 480
    When I set the player position to 37,96
    And I simulate "Graphics::KbUp"
    And I run the game loop 1 times
    And the game property "level.pushable_elements.first.position" should be "GVector.xy(1,0)"
    Then the player should be at position 37,95
    And I simulate ""
    And I run the game loop 1 times
    Then the game property "level.pushable_elements.size" should be "0"

  Scenario: Push Puzzle - Blocked Double Push
    Given I load the game on level "push_puzzle_blocked" with screen size 640, 480
    When I set the player position to 37,96
    And I simulate "Graphics::KbUp"
    And I run the game loop 1 times
    And the game property "level.pushable_elements.first.position" should be "GVector.xy(1,0)"
    Then the player should be at position 37,95
    And I simulate "Graphics::KbUp"
    And I run the game loop 1 times
    And I simulate ""
    And I run the game loop 1 times
    Then the game property "level.pushable_elements.size" should be "0"

  Scenario: Push Puzzle - Blocked by Other Pushable Push Both Fizzled
    Given I load the game on level "push_puzzle_blocked_by_pushable" with screen size 640, 480
    When I set the player position to 37,96
    And I simulate "Graphics::KbUp"
    And I run the game loop 1 times
    And I simulate ""
    And I run the game loop 1 times
    Then the game property "level.pushable_elements.size" should be "0"
    Then the player should be at position 37,95

  Scenario: Push Puzzle - Blocked by Other Pushable Double Push
    Given I load the game on level "push_puzzle_blocked_by_pushable" with screen size 640, 480
    When I set the player position to 37,96
    And I simulate "Graphics::KbUp"
    And I run the game loop 1 times
    And I simulate "Graphics::KbUp"
    And I run the game loop 1 times
    And I simulate ""
    And I run the game loop 1 times
    Then the game property "level.pushable_elements.size" should be "0"
    Then the player should be at position 37,94

  Scenario: Push Puzzle - Solving
    Given I load the game on level "push_puzzle_solvable" with screen size 640, 480
    And the game property "level.pushable_elements.size" should be "1"
    And the game property "level.push_targets_satisfied.size" should be "0"
    And the game property "level.name" should be "'push puzzle solvable'"
    And I run the game loop 1 times
    And the game property "level.pushable_elements.size" should be "0"
    And the game property "level.push_targets_satisfied.size" should be "1"
    And the game property "level.name" should be "'push puzzle solvable'"
    And I run the game loop 2 times
    And the game property "level.name" should be "'demo'"