@needs_full_gosu
Feature: Splash
  In order to understand the game
  As a player
  I want to see credit screens

  Scenario: Splash Screens
    Given I load the game "splash"
    Then the game should be in splash mode
    Then the game property "splash_controller.splashes.size" should be "1"

  Scenario: New Game Loading Level Invoke Event Area - New Game
    Given I load the game "splash"
    When I run the game loop 3 times
    Then the game should be in splash mode
    And the splash screen should be "splash_screen.png"
    When I simulate "Graphics::KbO"
    When I run the game loop 1 times
    Then the game should not be in splash mode
    Then the game property "splash_controller.splashes.size" should be "1"

  Scenario: Multiple Splash Screens
    Given I load the game "splash3"
    Then the game should be in splash mode
    Then the game property "splash_controller.splashes.size" should be "3"
    Then the game property "splash_controller.current_splash_index" should be "0"


  Scenario: Multiple Splash Screens Ticking
    Given I load the game "splash3"
    And I set the property "splash_controller.splash_rate" to "3"
    Then the game should be in splash mode
    Then the game property "splash_controller.splashes.size" should be "3"
    Then the game property "splash_controller.current_splash_index" should be "0"
    Then the game property "splash_controller.splash_rate" should be "3"
    When I run the game loop 4 times
    Then the game property "splash_controller.current_splash_index" should be "1"
    When I run the game loop 4 times
    Then the game property "splash_controller.current_splash_index" should be "2"
    When I run the game loop 4 times
    Then the game property "splash_controller.current_splash_index" should be "0"

