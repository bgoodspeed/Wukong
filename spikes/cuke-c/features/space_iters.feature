Feature: Space Iterations
  In order to control the framerate
  As a programmer
  I want to be able to get the number of iterations

  Scenario: Get Iterations from Space
    Given I create a space
    When I ask for the number of iterations
    Then I should get 10