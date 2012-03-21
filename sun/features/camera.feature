Feature: Camera Description
  In order to move around
  As a player
  I want to be able to see what is in a level

  Scenario: Trivial Level centered
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I create a game camera tracking the player
    And I set the player position to 320,240
    Then the level should measure 640, 480
    And the camera should be centered at 320, 240
    And the camera offset should be 0,0
    And the player screen coordinates should be 320, 240

  Scenario: Trivial Level offset
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a game camera tracking the player
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 100,200
    Then the level should measure 640, 480
    And the camera should be centered at 100, 200
    And the camera offset should be -220,-40
    And the player screen coordinates should be 320, 240

  Scenario: Trivial Level enemy
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a game camera tracking the player
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 320,240
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy position 400,300
    Then the level should measure 640, 480
    And the camera should be centered at 320, 240
    And the camera offset should be 0,0
    And the enemy screen coordinates should be 400,300
    
  Scenario: Trivial Level enemy offset
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a game camera tracking the player
    And I set the player avatar to "avatar.bmp"
    And I set the player position to 400,300
    And I set the enemy avatar to "enemy_avatar.bmp"
    And I set the enemy position 400,400
    Then the level should measure 640, 480
    And the camera should be centered at 400, 300
    And the camera offset should be 80,60
    And the enemy screen coordinates should be 320,340


