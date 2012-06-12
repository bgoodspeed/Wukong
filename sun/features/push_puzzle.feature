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
