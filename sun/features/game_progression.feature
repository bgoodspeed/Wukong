Feature: Game Progression
  In order to see the game evolve
  As a player
  I want to be able to progress through the game


  Scenario: Game Has Progression Controller
    Given I load the game "game"
    Then the game property "progression_controller" should not be nil

