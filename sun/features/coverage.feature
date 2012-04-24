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

  Scenario: EventArea invocation
    Given I create an event area
    And I expect "invoke" with event area for the argument on the action controller
    When I call "invoke" on the event area
    Then expectations should be met

  Scenario: Menu Behaviors Up
    Given I create an action controller mocking game
    Then I expect the games "menu_controller" to receive "move_up"
    When I invoke the action "KeyActions::UP" with set "menu_behaviors"
    Then expectations should be met

  Scenario: Menu Behaviors Interact
    Given I create an action controller mocking game
    Then I expect the games "menu_controller" to receive "invoke_current"
    When I invoke the action "KeyActions::INTERACT" with set "menu_behaviors"
    Then expectations should be met

  Scenario: Gameplay Behaviors Menu Enter
    Given I create an action controller mocking game
    Then I expect the games "self" to receive "interact"
    When I invoke the action "KeyActions::MENU_ENTER" with set "gameplay_behaviors"
    Then expectations should be met

  Scenario: Details of string method - vector follower
    Given I create a vector follower with start "[0,0]", vector "[2,0]", velocity "5"
    Then the last should match the fragment "current position"
    Then the last should match the fragment "vector"
    Then the last should match the fragment "velocity"

  Scenario: Details of string method - event
    Given I create an event with arg "arg" and event type "type"
    Then the last should match the fragment "type"
    Then the last should match the fragment "arg"

  Scenario: Path following controller deletion
    Given I create a path following controller
    And I add tracking
    Then the path following controller should be tracking 1
    And I remove tracking
    Then the path following controller should be tracking 0