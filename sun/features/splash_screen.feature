Feature: Splash
  In order to understand the game
  As a player
  I want to see credit screens

  Scenario: Splash Screens
    Given I load the game "splash"
    Then the game should be in splash mode

  Scenario: New Game Loading Level Invoke Event Area - New Game
    Given I load the game "splash"
    When I run the game loop 3 times
    Then the game should be in splash mode
    And the splash screen should be "splash_screen.png"
    When I simulate "Graphics::KbO"
    When I run the game loop 1 times
    Then the game should not be in splash mode


