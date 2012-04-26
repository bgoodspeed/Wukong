@needs_full_gosu
Feature: Camera Description
  In order to move around
  As a player
  I want to be able to see what is in a level

  Scenario: Huge Level centered
    Given I load the game on level "huge" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I create a game camera tracking the player
    And I set the player position to 320,240
    Then the camera should be centered at 320, 240
    And the camera offset should be 0,0
    And the player screen coordinates should be 320, 240

  Scenario: Huge Level offset
    Given I load the game on level "huge" with screen size 640, 480
    And I create a game camera tracking the player
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 100,200
    Then the camera should be centered at 100, 200
    And the camera offset should be -220,-40
    And the player screen coordinates should be 320, 240

  Scenario: Huge Level enemy
    Given I load the game on level "huge" with screen size 640, 480
    And I create a game camera tracking the player
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 320,240
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy position 400,300
    Then the camera should be centered at 320, 240
    And the camera offset should be 0,0
    And the enemy screen coordinates should be 400,300
    
  Scenario: Huge Level enemy offset
    Given I load the game on level "huge" with screen size 640, 480
    And I create a game camera tracking the player
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 400,300
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy position 400,400
    Then the camera should be centered at 400, 300
    And the camera offset should be 80,60
    And the enemy screen coordinates should be 320,340

  Scenario: Trivial Level centered
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I create a game camera tracking the player
    And I set the player position to 320,240
    Then the camera should be centered at 320, 240
    And the camera offset should be 0,0
    And the player screen coordinates should be 320, 240

  Scenario: Trivial Level offset low
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I create a game camera tracking the player
    And I set the player position to 50,50
    Then the camera should be centered at 320, 240
    And the camera offset should be 0,0
    And the player screen coordinates should be 50, 50

  Scenario: Trivial Level offset high
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I create a game camera tracking the player
    And I set the player position to 500,400
    Then the camera should be centered at 320, 240
    And the camera offset should be 0,0
    And the player screen coordinates should be 500, 400

  Scenario: Screen coordinate to world coordinate mapping
    Given I load the game on level "huge" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I create a game camera tracking the player
    And I set the player position to 320,240
    And I set the mouse position to 320, 240 in screen coords
    Then the camera should be centered at 320, 240
    And the camera offset should be 0,0
    And the player screen coordinates should be 320, 240
    And the mouse world coordinates should be 320, 240

  Scenario: Screen coordinate to world coordinate mapping 2
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I create a game camera tracking the player
    And I set the player position to 500,400
    And I set the mouse position to 100, 200 in screen coords
    When I simulate "Graphics::MsLeft"
    Then the camera should be centered at 320, 240
    And the camera offset should be 0,0
    And the player screen coordinates should be 500, 400
    And the mouse world coordinates should be 100, 200

 Scenario: Screen coordinate to world coordinate mapping 3
    Given I load the game on level "huge" with screen size 640, 480
    And I create a game camera tracking the player
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 100,200
    And I set the mouse position to 320, 240 in screen coords
    Then the camera should be centered at 100, 200
    And the camera offset should be -220,-40
    And the player screen coordinates should be 320, 240
    And the mouse world coordinates should be 100, 200


