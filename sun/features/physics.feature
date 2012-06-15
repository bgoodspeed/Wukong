Feature: Physics Integration
  In order to build the scene
  As a programmer
  I want to be able to inspect the physical space

  Scenario: Physics Wrapper Space
    Given I load the game on level "physics" with screen size 640, 480
    Then the game property "level.name" should be "'physics'"
    Then the game property "level.physical?" should be "true"
    Then the game property "level.physics.space.gravity.x" should be "5"
    Then the game property "level.physics.space.gravity.y" should be "0"
    Then the game property "level.physics.space.damping" should be "0.8"
    Then the game property "level.physics.drop_line_location" should be "120"
    Then the game property "level.physics.steps" should be "9"
    Then the game property "level.physics.space.nil?" should be "false"
    Then the game property "level.physics.space.damping" should be "0.8"
    Then the game property "level.physics.top_wall_body.nil?" should be "false"
    Then the game property "level.physics.bullets.size" should be "0"

  Scenario: Physics Bases
    Given I load the game on level "physics" with screen size 640, 480
    Then the game property "level.physics.bases.size" should be "2"
    Then the game property "level.physics.enemy_base.nil?" should be "false"
    Then the game property "level.physics.player_base.nil?" should be "false"
    Then the game property "level.physics.enemy_base.shape.body.p.x" should be "390"
    Then the game property "level.physics.enemy_base.shape.body.p.y" should be "430"
    Then the game property "level.physics.enemy_base.shape.body.m" should be "10.0"
    Then the game property "level.physics.enemy_base.shape.body.i" should be "250.0"
    Then the game property "level.physics.player_base.shape.body.p.x" should be "120.0"
    Then the game property "level.physics.player_base.shape.body.p.y" should be "430"
    Then the game property "level.physics.player_base.shape.body.m" should be "11.0"
    Then the game property "level.physics.player_base.shape.body.i" should be "251.0"

  Scenario: Physics Turret Config
    Given I load the game on level "physics" with screen size 640, 480
    Then the game property "level.physics.turret.nil?" should be "false"
    Then the game property "level.physics.turret.angle_delta" should be "1"
    Then the game property "level.physics.turret.angle_max" should be "90"
    Then the game property "level.physics.turret.angle_min" should be "0"
    Then the game property "level.physics.turret.angle" should be "45"
    Then the game property "level.physics.turret.power_delta" should be "1"
    Then the game property "level.physics.turret.power_max" should be "110"
    Then the game property "level.physics.turret.power_min" should be "20"
    Then the game property "level.physics.turret.power" should be "65"

  Scenario: Physics Turret Movement Angle
    Given I load the game on level "physics" with screen size 640, 480
    Then the game property "level.physics.turret.angle" should be "45"
    When I increase the turret angle
    Then the game property "level.physics.turret.angle" should be "46"
    When I decrease the turret angle
    When I decrease the turret angle
    Then the game property "level.physics.turret.angle" should be "44"

  Scenario: Physics Turret Power Changing
    Given I load the game on level "physics" with screen size 640, 480
    Then the game property "level.physics.turret.power" should be "65"
    When I increase the turret power
    Then the game property "level.physics.turret.power" should be "66"
    When I decrease the turret power
    When I decrease the turret power
    Then the game property "level.physics.turret.power" should be "64"



