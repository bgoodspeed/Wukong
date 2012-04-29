
Feature: Animation Details
  In order to play the game
  As a player
  I want to see animations

  Scenario: Animation Timelines
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I create an animation controller with a ratio of one animation tick to 1 game ticks
    And I set the player attack animation to "animation.png"
    And I set the game clock to 60 fps
    When I run the game loop 1 times
    Then the number of frames render should be 1
    And the animation index for the player attack animation should be 1
    And the animation position for player "weapon" should be 36, 36

  Scenario: Animation Timelines 2
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I create an animation controller with a ratio of one animation tick to 1 game ticks
    And I set the player attack animation to "ball4-280x70.png"
    And I set the game clock to 60 fps
    When I run the game loop 1 times
    Then the number of frames render should be 1
    And the animation index for the player attack animation should be 1
    And the animation position for player "weapon" should be 36, 36

  Scenario: Animation Timelines Stopping
    Given I load the game on level "trivial" with screen size 640, 480
    And I set the player avatar to "avatar.bmp"
    And I create an animation controller with a ratio of one animation tick to 1 game ticks
    And I set the player attack animation to "ball4-280x70.png"
    And I set the game clock to 60 fps
    When I run the game loop 1 times
    Then the number of frames render should be 1
    And the animation index for the player attack animation should be 1
    And the player attack animation should be active
    When I stop the player animation
    And the player attack animation should not be active

  Scenario: Animation In Level One active
    Given I load the game "with_images"
    When I set the player position to 100,100
    When I run the game loop 1 times
    And the level animation "levelanim1" should be active
    And the level animation "levelanim2" should not be active

  Scenario: Animation In Level None active
    Given I load the game "with_images"
    When I set the player position to 600,440
    When I run the game loop 1 times
    And the level animation "levelanim1" should not be active
    And the level animation "levelanim2" should not be active

