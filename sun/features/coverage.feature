Feature: CodeCoverage
  In Order to Cover random bits of 3rd party
  As a developer
  I want to be able to mock out objects and test 3rd party integrations

  Scenario: GameWindow Update all
    Given I create a GameWindow mocking game
    And I expect "update_all" on game mock
    When "update" is called on the GameWindow
    Then expectations should be met

  Scenario: GameWindow draw
    Given I create a GameWindow mocking game
    And I expect "draw" on game mock
    When "draw" is called on the GameWindow
    Then expectations should be met

  Scenario: Screen draw
    Given I create a screen mocking game window
    And I expect "draw" on game window mock
    When "draw" is called on the screen
    Then expectations should be met

  Scenario: Screen show
    Given I create a screen mocking game window
    And I expect "show" on game window mock
    When "show" is called on the screen
    Then expectations should be met

  Scenario: Collider Lineseg vs Circle
    Given I create a collider
    Given I make a line segment from [0,0] to [10, 10]
    Given I make a circle at [0,0] radius 10
    When I check collision between the line segment and the circle i should get true