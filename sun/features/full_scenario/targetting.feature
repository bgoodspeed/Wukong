@needs_full_gosu
Feature: Targetting
  In order to play strategically
  As a player
  I want to be able to enter targetting mode and choose from a list of targets

  Scenario: Targetting Controller Off
    Given I load the game "new_game_load_screen"
    Then the game property "targetting_controller.class" should be "TargettingController"
    Then the game property "targetting_controller.active" should be "false"

  Scenario: Targetting Controller On
    Given I load the game "new_game_load_screen"
    When I enter targetting mode
    Then the game property "targetting_controller.active" should be "true"
    Then the game property "targetting_controller.target_list.size" should be "0"

  Scenario: Targetting Controller Target List
    Given I load the game "demo"
    And I add an enemy from "enemy.yml"
    When I enter targetting mode
    Then the game property "targetting_controller.active" should be "true"
    Then the game property "targetting_controller.target_list.size" should be "1"
    Then the game property "targetting_controller.target_list.first.target.name" should be "'Test Enemy'"
    Then the game property "player.accuracy" should be "100"
    And the enemy should be at position 25,25
    And the player should be at position 36,36
    Then the game property "targetting_controller.target_list.first.vector_to_target" should be "GVector.xy( -11, -11 )"
    Then the game property "targetting_controller.target_list.first.distance_to_target" should be approximately "15.556"
    Then the game property "targetting_controller.target_list.first.hit_odds_for_target" should be approximately "97"

  Scenario: Hit Odd Calculation
    Given I create an odds calculator
    Then the hit odds for distance 0 with distance threshold 100 should be 99%
    Then the hit odds for distance 1 with distance threshold 100 should be 98%
    Then the hit odds for distance 10 with distance threshold 100 should be 98%
    Then the hit odds for distance 20 with distance threshold 100 should be 97%
    Then the hit odds for distance 30 with distance threshold 100 should be 96%
    Then the hit odds for distance 40 with distance threshold 100 should be 93%
    Then the hit odds for distance 50 with distance threshold 100 should be 90%
    Then the hit odds for distance 60 with distance threshold 100 should be 85%
    Then the hit odds for distance 70 with distance threshold 100 should be 76%
    Then the hit odds for distance 80 with distance threshold 100 should be 63%
    Then the hit odds for distance 90 with distance threshold 100 should be 42%
    Then the hit odds for distance 100 with distance threshold 100 should be 9%


  Scenario: Targetting Controller Target List - Multiple Targets
    Given I load the game "demo"
    And I add an enemy from "enemy.yml"
    And I add an enemy from "enemy2.yml"
    When I enter targetting mode
    Then the game property "targetting_controller.target_list.size" should be "2"
    Then the game property "targetting_controller.target_index" should be "0"
    Then the game property "player.accuracy" should be "100"

  Scenario: Targetting Controller Target List - Multiple Targets
    Given I load the game "demo"
    And I add an enemy from "enemy.yml"
    And I add an enemy from "enemy2.yml"
    And I add an enemy from "enemy3.yml"
    When I enter targetting mode
    Then the game property "targetting_controller.target_list.size" should be "3"
    Then the game property "targetting_controller.current_target.target.name" should be "'Test Enemy'"
    When I move to the next lower target
    Then the game property "targetting_controller.target_index" should be "2"
    Then the game property "targetting_controller.current_target.target.name" should be "'Test Enemy3'"
    When I move to the next higher target
    When I move to the next higher target
    Then the game property "targetting_controller.target_index" should be "1"
    Then the game property "targetting_controller.current_target.target.name" should be "'Test Enemy2'"
