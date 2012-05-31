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

  Scenario: Wayfinding A-Star
    Given I create a graph
    Then the graph property "nodes.size" should be "0"
    When I add a node named "A" at position 10, 10
    Then the graph property "nodes.size" should be "1"

  Scenario: Wayfinding A-Star Edge Weights
    Given I create a graph
    When I add a node named "A" at position 1, 2
    When I add a node named "B" at position 1, 10
    When I add a node named "C" at position 3, 2
    When I add an edge from "A" to "B"
    When I add an edge from "A" to "C"
    Then weight of edge "A","B" should be "8"

  Scenario: Wayfinding A-Star Closest Node
    Given I create a graph
    When I add a node named "A" at position 1, 2
    When I add a node named "B" at position 1, 10
    When I add a node named "C" at position 3, 2
    Then the closest node to position 0, 7 should be "B"
    Then the closest node to position 0, 2 should be "A"
    Then the closest node to position 3, 3 should be "C"

  Scenario: Wayfinding A-Star Neighbors
    Given I create a graph
    When I add a node named "A" at position 1, 2
    When I add a node named "B" at position 1, 10
    When I add a node named "C" at position 3, 2
    When I add a node named "D" at position 9, 7
    When I add a node named "E" at position 9, 10
    When I add a node named "F" at position 12, 1
    When I add an edge from "A" to "B"
    When I add an edge from "A" to "C"
    When I add an edge from "A" to "D"
    When I add an edge from "A" to "F"
    Then the neighbors for "A" should be "['B','C','D','F']"

  Scenario: Wayfinding A-Star Implicit Bidirectional Edges
    Given I create a graph
    When I add a node named "A" at position 1, 2
    When I add a node named "B" at position 1, 10
    When I add a node named "C" at position 3, 2
    When I add a node named "D" at position 9, 7
    When I add a node named "E" at position 9, 10
    When I add a node named "F" at position 12, 1
    When I add an edge from "A" to "B"
    When I add an edge from "A" to "C"
    When I add an edge from "A" to "D"
    When I add an edge from "A" to "F"
    When I add an edge from "B" to "E"
    When I add an edge from "C" to "D"
    When I add an edge from "C" to "F"
    When I add an edge from "D" to "E"
    When I add an edge from "D" to "F"
    When I add an edge from "E" to "F"
    Then the neighbors for "F" should be "['A','C','D','E']"

  Scenario: Wayfinding A-Star Algorithm Implementation
    Given I create a graph
    When I add a node named "A" at position 1, 2
    When I add a node named "B" at position 1, 10
    When I add a node named "C" at position 3, 2
    When I add a node named "D" at position 9, 7
    When I add a node named "E" at position 9, 10
    When I add a node named "F" at position 12, 1
    When I add an edge from "A" to "B"
    When I add an edge from "A" to "C"
    When I add an edge from "A" to "D"
    When I add an edge from "A" to "F"
    When I add an edge from "B" to "E"
    When I add an edge from "C" to "D"
    When I add an edge from "C" to "F"
    When I add an edge from "D" to "E"
    When I add an edge from "D" to "F"
    When I add an edge from "E" to "F"
    When I run the A-Star algorithm from start "C" and goal "B"
    Then the A-Star path should be "['C','A','B']"
    When I run the A-Star algorithm from start "D" and goal "B"
    Then the A-Star path should be "['D','E','B']"
    When I run the A-Star algorithm from start "F" and goal "B"
    Then the A-Star path should be "['F','E','B']"

  Scenario: Wayfinding A-Star Algorithm Implementation
    Given I create a graph from yaml "wayfinding/wayfinding.yml"
    When I run the A-Star algorithm from start "c" and goal "b"
    Then the A-Star path should be "['c','a','b']"

  Scenario: Wayfinding A-Star Algorithm Wayfinding
    Given I load wayfinding layer "wayfinding/wayfinding.yml"
    When the agent in the scene is at 14,14
    Then the nearest point should be at 9,10
    And the best point for target 9,9 should be at 9,10

  Scenario: Wayfinding A-Star Algorithm Wayfinding Abandoning Track For Direct
    Given I load wayfinding layer "wayfinding/wayfinding.yml"
    When the agent in the scene is at 11,11
    Then the nearest point should be at 9,10
    And the best point for target 10,10 should be undefined

  Scenario: Wayfinding A-Star Algorithm Wayfinding Abandoning Track For Direct 2
    Given I load wayfinding layer "wayfinding/wayfinding2.yml"
    When the agent in the scene is at 2,4
    Then the nearest point should be at 1,4
    And the best point for target 7,4 should be at 8,4

  Scenario: Wayfinding A-Star Algorithm Wayfinding Abandoning Track For Direct 3
    Given I load wayfinding layer "wayfinding/wayfinding2.yml"
    When I set the wayfinding close enough threshold to 0
    When the agent in the scene is at 2,4
    Then the nearest point should be at 1,4
    And the best point for target 7,4 should be at 4,4
