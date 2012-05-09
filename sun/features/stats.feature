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
