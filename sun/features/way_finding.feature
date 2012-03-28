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

  Scenario: Wayfinding Data Layer Best Worse Than Current2
    Given I create a new Wayfinding Layer:
      """
      layer:
        points:
          - [ 10, 10 ]
          - [ 10, 50 ]
          - [ 10, 90 ]
      """
    When the agent in the scene is at 10,50
    Then the best point for target 50,50 should be undefined

  Scenario: Wayfinding Data Layer Best Worse Than Current3
    Given I create a new Wayfinding Layer:
      """
      layer:
        points:
          - [ 10, 10 ]
          - [ 10, 50 ]
          - [ 10, 90 ]
      """
    When the agent in the scene is at 12,51
    Then the best point for target 50,50 should be undefined

 Scenario: Wayfinding Data Peaks At Middle
    Given I create a new Wayfinding Layer:
      """
      layer:
        points:
          - [ 50, 50 ]
          - [ 100, 50 ]
          - [ 200, 50 ]
          - [ 300, 50 ]
          - [ 400, 50 ]
      """
    When the agent in the scene is at 303,49
    Then the nearest point should be at 300,50
    And the best point for target 300,300 should be undefined