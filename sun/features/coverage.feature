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

  Scenario: Clock current elapsed time
    Given I create a game clock
    And I tick the game clock
    Then the elapsed time should be less than 22 ms

  Scenario: Removing Tracking
    Given I create a path following controller
    When I add tracking
    Then the path following controller should be tracking 1
    When I remove tracking
    Then the path following controller should be tracking 0

  Scenario: Weapon stopping
    Given I create a player with a mock inventory
    And I activate the weapon
    Then the weapon should active
    When I stop the weapon

  Scenario: Level completion conditions
    Given I create a level
    And I add a fake completion condition to both and and or
    Then expectations should be met


  Scenario: Using CPP code from shared object
    Given I require the dll or shared object "ripmunk"
    When I create a sample class which includes the module
    Then the method "primitive_circle_line_segment_intersection_cpp" should be defined on the sample
