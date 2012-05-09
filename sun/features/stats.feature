Feature: Stats
  In order to develop my character
  As a player
  I want to be able to increase my stats

  Scenario: Stats
    Given I create a stats object
    Then the stats should have strength 10
    Then the stats should have defense 5
    Then the stats should have health 10
    Then the stats should have max health 12
    Then the stats should have speed 5
    Then the stats should have accuracy 5

  Scenario: Stats Summation
    Given I create a stats object called "a"
    Given I create a stats object called "b"
    When stats "a" and "b" are added
    Then the stats result should have property "strength" equal to "20"
