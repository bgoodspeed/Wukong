Feature: Physics Integration
  In order to build the scene
  As a programmer
  I want to be able to inspect the physical space

  Scenario: Get Static bodies from Space
    Given I load the level "trivial"
    When I ask for the static bodies
    Then I should have 4 bodies