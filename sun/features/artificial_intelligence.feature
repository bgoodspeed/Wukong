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
