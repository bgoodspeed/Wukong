Feature: Wayfinding Details
  In order to play the game
  As a player
  I want computer controlled agents to be able to follow paths

  Scenario: Wayfinding Data Layer Nearest
    Given I create a new Wayfinding Layer:
      """
      layer:
        points:
          - [ 10, 10 ]
          - [ 20, 20 ]
          - [ 30, 30 ]
      """
    When the agent in the scene is at 0,0
    Then the nearest point should be at 10,10

  Scenario: Wayfinding Data Layer Best
    Given I create a new Wayfinding Layer:
      """
      layer:
        points:
          - [ 10, 10 ]
          - [ 20, 20 ]
          - [ 30, 30 ]
      """
    When the agent in the scene is at 12,12
    Then the nearest point should be at 10,10
    And the best point for target 40,40 should be at 20,20

  Scenario: Wayfinding Data Layer Best Worse Than Current
    Given I create a new Wayfinding Layer:
      """
      layer:
        points:
          - [ 10, 10 ]
          - [ 20, 20 ]
          - [ 30, 30 ]
      """
    When the agent in the scene is at 30,30
    Then the best point for target 40,40 should be undefined