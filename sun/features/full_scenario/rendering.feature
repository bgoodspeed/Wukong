Feature: Rendering
  In order to see effects
  As a designer
  I want to be able to add temporary elements to a rendering queue

  Scenario: Rendering Temporary TTL 3
    Given I load the game "demo"
    When I add a temporary rendering mock with type "RenderingTypes::DAMAGE" and duration 3
    When I run the game loop 1 times
    Then there should be 1 temporary renderings
    When I run the game loop 1 times
    Then there should be 1 temporary renderings
    When I run the game loop 1 times
    Then there should be 0 temporary renderings

  Scenario: Rendering Temporary TTL 4
    Given I load the game "demo"
    When I add a temporary rendering mock with type "RenderingTypes::DAMAGE" and duration 4
    When I run the game loop 1 times
    Then there should be 1 temporary renderings
    When I run the game loop 1 times
    Then there should be 1 temporary renderings
    When I run the game loop 1 times
    Then there should be 1 temporary renderings
    When I run the game loop 1 times
    Then there should be 0 temporary renderings
