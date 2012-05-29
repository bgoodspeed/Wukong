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
    Then the game property "targetting_controller.target_list.first.hit_odds_for_target" should be approximately "98"

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


  Scenario: Targetting Controller Target List - Multiple Targets 2
    Given I load the game "demo"
    And I add an enemy from "enemy.yml"
    And I add an enemy from "enemy2.yml"
    When I enter targetting mode
    Then the game property "targetting_controller.target_list.size" should be "2"
    Then the game property "targetting_controller.target_index" should be "0"
    Then the game property "player.accuracy" should be "100"

  Scenario: Targetting Controller Target List - Multiple Targets 3
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

  Scenario: Energy Points Distributed to Player on Game Tick
    Given I load the game "demo"
    Then the game property "player.energy_points" should be "0"
    When I set the player max energy points to 3
    When I run the game loop 3 times
    Then the game property "player.energy_points" should be "3"
    When I run the game loop 3 times
    Then the game property "player.energy_points" should be "3"

  Scenario: Targetting Controller Target List - Action Queue Damaging Enemies
    Given I load the game "demo"
    And I add an enemy from "enemy.yml"
    And I add an enemy from "enemy2.yml"
    And I set the property "position" to "GVector.xy(100,100)" on enemy named "Test Enemy"
    And I set the property "position" to "GVector.xy(100,100)" on enemy named "Test Enemy2"
    Then the enemy named "Test Enemy" should have "health" equal to "15"
    Then the enemy named "Test Enemy2" should have "health" equal to "15"
    When I set the player max energy points to 200
    When I set the player energy points to 200
    And I set the player position to 80,80
    And I stub hit odds for all targets to be 100 percent
    Then the game property "targetting_controller.action_queue.size" should be "0"
    When I enter targetting mode
    When I queue an attack on the current target
    When I move to the next higher target
    When I queue an attack on the current target
    When I invoke the current attack queue
    Then the game property "targetting_controller.active" should be "false"
    Then the enemy named "Test Enemy" should have "health" equal to "9"
    Then the enemy named "Test Enemy2" should have "health" equal to "9"
    Then the attack queue results should contain "6" for enemy named "Test Enemy"


  Scenario: Targetting Controller Target List - Action Queue Limits
    Given I load the game "demo"
    And I add an enemy from "enemy.yml"
    And I add an enemy from "enemy2.yml"
    When I set the player max energy points to 200
    When I set the player energy points to 200
    And I set the player position to 80,80
    Then the game property "targetting_controller.action_queue.size" should be "0"
    When I enter targetting mode
    Then the game property "targetting_controller.current_target.target.name" should be "'Test Enemy'"
    When I queue an attack on the current target
    Then the game property "targetting_controller.action_queue.size" should be "1"
    Then the game property "player.energy_points" should be "200"
    Then the game property "targetting_controller.action_queue_cost" should be "100"
    When I move to the next higher target
    Then the game property "targetting_controller.current_target.target.name" should be "'Test Enemy2'"
    When I queue an attack on the current target
    Then the game property "targetting_controller.action_queue.size" should be "2"
    Then the game property "player.energy_points" should be "200"
    Then the game property "targetting_controller.action_queue_cost" should be "200"
    When I queue an attack on the current target
    Then the game property "targetting_controller.action_queue.size" should be "2"
    Then the game property "player.energy_points" should be "200"
    Then the game property "targetting_controller.action_queue_cost" should be "200"

  Scenario: Targetting Controller Target List - Action Queue Misses
    Given I load the game "demo"
    And I add an enemy from "enemy.yml"
    And I set the property "position" to "GVector.xy(100,100)" on enemy named "Test Enemy"
    Then the enemy named "Test Enemy" should have "health" equal to "15"
    When I set the player max energy points to 200
    When I set the player energy points to 200
    And I set the player position to 80,80
    And I stub hit odds for all targets to be 0 percent
    Then the game property "targetting_controller.action_queue.size" should be "0"
    When I enter targetting mode
    When I queue an attack on the current target
    When I queue an attack on the current target
    Then the game property "targetting_controller.action_queue.size" should be "2"
    When I invoke the current attack queue
    Then the enemy named "Test Enemy" should have "health" equal to "15"
    Then the attack queue results should contain "'miss'" for enemy named "Test Enemy"

  Scenario: Targetting Controller Target List - Killing enemies in target mode gives credit to player
    Given I load the game "demo"
    And I add an enemy from "enemy.yml"
    And I set the property "position" to "GVector.xy(100,100)" on enemy named "Test Enemy"
    Then the enemy named "Test Enemy" should have "health" equal to "15"
    When I set the player max energy points to 400
    When I set the player energy points to 400
    And I set the player position to 80,80
    And I stub hit odds for all targets to be 100 percent
    Then the game property "targetting_controller.action_queue.size" should be "0"
    When I enter targetting mode
    When I queue an attack on the current target
    When I queue an attack on the current target
    When I queue an attack on the current target
    When I invoke the current attack queue
    And I run the game loop 1 times
    Then the game property "targetting_controller.active" should be "false"
    Then the game property "player.enemies_killed" should be "1"
    Then the game property "level.enemies.size" should be "0"

  Scenario: Targetting Controller Target List - Killing enemies in target mode gives credit to player
    Given I load the game "demo"
    And I add an enemy from "enemy.yml"
    And I add an enemy from "enemy2.yml"
    And I set the property "position" to "GVector.xy(100,100)" on enemy named "Test Enemy"
    And I set the property "position" to "GVector.xy(100,100)" on enemy named "Test Enemy2"
    Then the enemy named "Test Enemy" should have "health" equal to "15"
    When I set the player max energy points to 600
    When I set the player energy points to 600
    And I set the player position to 80,80
    And I stub hit odds for all targets to be 100 percent
    Then the game property "targetting_controller.action_queue.size" should be "0"
    When I enter targetting mode
    When I queue an attack on the current target
    When I queue an attack on the current target
    When I queue an attack on the current target
    When I move to the next higher target
    When I queue an attack on the current target
    When I queue an attack on the current target
    When I queue an attack on the current target
    When I invoke the current attack queue
    And I run the game loop 1 times
    Then the game property "targetting_controller.active" should be "false"
    Then the game property "player.enemies_killed" should be "2"
    Then the game property "level.enemies.size" should be "0"
