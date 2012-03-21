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

  Scenario: Large Level
    Given I load the level "large"
    When the level is examined
    Then the level should measure 1280, 960
    Then there should be 4 line segments
