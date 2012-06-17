Feature: Physics Integration
  In order to build the scene
  As a programmer
  I want to be able to inspect the physical space

  Scenario: Physics Wrapper Expectations
    Given I expect calls to the physics engine
    Given I load the game on level "physics" with screen size 640, 480
    Then expectations should be met

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
    Then the game property "level.physics.enemies_killed.size" should be "0"
    Then the game property "level.physics.bullets_to_remove.size" should be "0"
    Then the game property "level.physics.bases_destroyed.size" should be "0"
    Then the game property "level.physics.payloads_to_add.size" should be "0"
    Then the game property "level.physics.payloads_to_remove.size" should be "0"

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
    Then the game property "level.physics.turret.x" should be "30"
    Then the game property "level.physics.turret.y" should be "450"

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

  Scenario: Physics Turret Firing
    Given I load the game on level "physics" with screen size 640, 480
    Then the game property "level.physics.bullets.size" should be "0"
    When I fire the turret
    Then the game property "level.physics.bullets.size" should be "1"

  Scenario: Physics Drop Line
    Given I load the game on level "physics" with screen size 640, 480
    Then the game property "level.physics.drop_line_location" should be "120"
    Then the game property "level.physics.drop_line.nil?" should be "false"

  Scenario: Physics Enemy Ship
    Given I load the game on level "physics" with screen size 640, 480
    Then the game property "level.physics.enemies.size" should be "1"
    Then the game property "level.physics.enemies.first.shape.body.m" should be "10.0"
    Then the game property "level.physics.enemies.first.shape.body.i" should be "250.0"
    Then the game property "level.physics.enemies.first.shape.body.p.x" should be "570"
    Then the game property "level.physics.enemies.first.shape.body.p.y" should be "90"
    Then the game property "level.physics.enemies.first.shape.body.v.x" should be "-0.0005"
    Then the game property "level.physics.enemies.first.shape.body.v.y" should be "0"

  Scenario: Physics Payloads
    Given I load the game on level "physics" with screen size 640, 480
    Then the game property "level.physics.payloads.size" should be "0"

  Scenario: Physics Update - Updates Enemy
    Given I load the game on level "physics" with screen size 640, 480
    Then the game property "level.physics.enemies.first.shape.body.p.x" should be "570"
    Then the game property "level.physics.enemies.first.shape.body.p.y" should be "90"
    When I step the physics simulation 2 times
    Then the game property "level.physics.enemies.first.shape.body.p.x" should be greater than "570"
    Then the game property "level.physics.enemies.first.shape.body.p.y" should be less than "89.95"

  Scenario: Physics Update - Updates Bullet
    Given I load the game on level "physics" with screen size 640, 480
    When I fire the turret
    When I step the physics simulation 1 times
    Then the game property "level.physics.bullets.size" should be "1"
    When I step the physics simulation 22 times
    Then the game property "level.physics.bullets.size" should be "0"

  Scenario: Physics Collisions - Bullet Vs Enemy
    Given I load the game on level "physics" with screen size 640, 480
    When I fire the turret
    When I step the physics simulation 1 times
    Then the game property "level.physics.enemies.first.health" should be "10"
    When I set the position of the first physical bullet to 50, 50
    When I set the position of the first physical enemy to 50, 50
    When I step the physics simulation 1 times
    Then the game property "level.physics.enemies.first.health" should be "4"

  Scenario: Physics Collisions - Bullet Vs Enemy - Death - Respawn
    Given I load the game on level "physics" with screen size 640, 480
    When I fire the turret
    When I step the physics simulation 1 times
    Then the game property "level.physics.enemies.first.health" should be "10"
    When I set the position of the first physical bullet to 50, 50
    When I set the position of the first physical enemy to 50, 50
    When I step the physics simulation 1 times
    Then the game property "level.physics.enemies.first.health" should be "4"
    When I fire the turret
    When I set the position of the first physical bullet to 50, 50
    When I set the position of the first physical enemy to 50, 50
    When I step the physics simulation 1 times
    Then the game property "level.physics.enemies.size" should be "0"
    When I step the physics simulation 1 times
    Then the game property "level.physics.enemies.size" should be "1"

  Scenario: Physics Collisions - Bullet Vs Wall
    Given I load the game on level "physics" with screen size 640, 480
    When I fire the turret
    When I step the physics simulation 1 times
    When I set the position of the first physical bullet to 0, 0
    When I step the physics simulation 2 times
    Then the game property "level.physics.bullets.size" should be "0"

  Scenario: Physics Collisions - Bullet Vs Enemy Base
    Given I load the game on level "physics" with screen size 640, 480
    When I fire the turret
    When I step the physics simulation 1 times
    Then the game property "level.physics.enemy_base.stats.health" should be "200"
    When I set the position of the first physical bullet to 50, 50
    When I set the position of the physical enemy base to 50, 50
    When I step the physics simulation 1 times
    Then the game property "level.physics.enemy_base.stats.health" should be "194"

  Scenario: Physics Collisions - Bullet Vs Player Base
    Given I load the game on level "physics" with screen size 640, 480
    When I fire the turret
    When I step the physics simulation 1 times
    Then the game property "level.physics.player_base.stats.health" should be "200"
    When I set the position of the first physical bullet to 50, 50
    When I set the position of the physical player base to 50, 50
    When I step the physics simulation 1 times
    Then the game property "level.physics.player_base.stats.health" should be "194"

  Scenario: Physics Collisions - Payload Vs Enemy Base
    Given I load the game on level "physics" with screen size 640, 480
    When I add a payload at 50,50 with mass 5
    When I step the physics simulation 1 times
    Then the game property "level.physics.payloads.size" should be "1"
    Then the game property "level.physics.player_base.stats.health" should be "200"
    When I set the position of the physical player base to 50, 50
    When I step the physics simulation 1 times
    Then the game property "level.physics.player_base.stats.health" should be "194"

  Scenario: Physics Collisions - Payload Vs Wall
    Given I load the game on level "physics" with screen size 640, 480
    When I add a payload at 0,0 with mass 5
    When I step the physics simulation 4 times
    Then the game property "level.physics.payloads.size" should be "0"

  Scenario: Physics Collisions - Enemy Vs Drop Line
    Given I load the game on level "physics" with screen size 640, 480
    Then the game property "level.physics.drop_line_location" should be "120"
    When I set the position of the first physical enemy to 120, 50
    When I step the physics simulation 1 times
    Then the game property "level.physics.enemies.size" should be "0"






