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

  Scenario: Stats Summation Clamped
    Given I create a stats object called "a"
    Given I create a stats object called "b"
    And I set the stat "max_health" on "b" to "0"
    When stats "a" and "b" are added with clamping
    Then the stats result should have property "strength" equal to "20"
    Then the stats result should have property "health" equal to "12"

  Scenario: Stats Summation Clamped 2
    Given I create a stats object called "a"
    Given I create a stats object called "b"
    And I set the stat "max_health" on "b" to "1"
    When stats "a" and "b" are added with clamping
    Then the stats result should have property "strength" equal to "20"
    Then the stats result should have property "health" equal to "13"
    Then the stats result should have property "max_health" equal to "13"

  Scenario: Damage Calculation
    Given I create a stats object called "a"
    Given I create a stats object called "b"
    And I set the stat "strength" on "a" to "10"
    And I set the stat "defense" on "a" to "10"
    And I set the stat "strength" on "b" to "5"
    And I set the stat "defense" on "b" to "5"
    Then the effective damage "a" can do to "b" is "6"
    Then the effective damage "b" can do to "a" is "0"

  Scenario: Stats Hash Equivalence
    Given I create a stats object called "a"
    Given I create a stats object called "b"
    And I set the stat "strength" on "a" to "5"
    And I set the stat "strength" on "b" to "5"
    Then the inventory hash of stats "a" should be "5,5,10,12,5,5,"
    Then the inventory hash of stats "b" should be "5,5,10,12,5,5,"
    Given I set the stat "strength" on "a" to "99"
    Then the inventory hash of stats "a" should be "99,5,10,12,5,5,"
    Then the inventory hash of stats "b" should be "5,5,10,12,5,5,"

  Scenario: Stats mapping direct
    Given I set the stat range to 0, 100
    Given I set the target range to 0, 10
    Then the direct mapping for stat 0 should be 0
    Then the direct mapping for stat 100 should be 10
    Then the direct mapping for stat 90 should be 9

  Scenario: Stats mapping inverse
    Given I set the stat range to 0, 100
    Given I set the target range to 0, 10
    Then the inverse mapping for stat 0 should be 10
    Then the inverse mapping for stat 100 should be 0
    Then the inverse mapping for stat 90 should be 1