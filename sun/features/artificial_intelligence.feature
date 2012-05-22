Feature: AI Details
  In order to play the game
  As a player
  I want to be able to compete against computer controlled agents

  Scenario: AI State Machine
    Given I create a new AI Strategy called "strategy":
      """
      strategy:
        start_state: wait
        states:
          - wait:
            - enemy_sighted: chase
          - chase:
            - enemy_in_range: attack
            - enemy_lost: wait
          - attack:
            - enemy_too_far: chase 
      """
    When the event "enemy_sighted" occurs
    Then the start state is "wait"
    And the current state is "chase"
    And attempting an event "somethingfake" generates an error and stay in state "chase"

# TODO line of sight
#  Scenario: AI Enemy State Changes
#    Given I load the game on level "simple" with screen size 640, 480
#    And I add an enemy from "enemy_ai.yml"
#    When I see the first frame
#    Then there should be 1 enemies
#    Given I tell the enemy to track the player
#    Given I register the enemy in the path following controller using wayfinding
#    Then the game property "level.enemies.first.position.x" should be "25"
#    Then the game property "level.enemies.first.position.y" should be "25"
#    Then the game property "player.position.x" should be "36"
#    Then the game property "player.position.y" should be "36"
#    Then the game property "level.enemies.first.artificial_intelligence.current_state" should be ":wait"
#    When I run the game loop 1 times
#    Then the game property "level.enemies.first.artificial_intelligence.current_state" should be ":chase"
#    When I set the property "level.enemies.first.position.x" to "35"
#    When I set the property "level.enemies.first.position.y" to "36"
#    When I run the game loop 1 times
#    Then the game property "level.enemies.first.artificial_intelligence.current_state" should be ":attack"

