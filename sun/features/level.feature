Feature: Level Description
  In order to play a level
  As a player
  I want to be able to know what is in a level

  Scenario: Trivial Level
    Given I load the level "trivial"
    When the level is examined
    Then the level should measure 640, 480
    Then there should be 4 line segments
    And there should be 0 triangles
    And there should be 0 circles
    And there should be 0 rectangles
    And the minimum x is 0
    And the maximum x is 640
    And the minimum y is 0
    And the maximum y is 480

  Scenario: Large Level
    Given I load the level "large"
    When the level is examined
    Then the level should measure 1280, 960
    Then there should be 4 line segments
    And the minimum x is 0
    And the maximum x is 1280
    And the minimum y is 0
    And the maximum y is 960

  Scenario: Huge Level
    Given I load the level "huge"
    When the level is examined
    Then the level should measure 2560, 1920
    Then there should be 4 line segments
    And the minimum x is -1280
    And the maximum x is 1280
    And the minimum y is -960
    And the maximum y is 960
