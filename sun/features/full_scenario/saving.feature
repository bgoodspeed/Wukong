@needs_full_gosu
Feature: Saving
  In order to make a record of progress
  As a player
  I want to be able to save a running game

  Scenario: Saving a game saves image and animation properties
    Given I load the game "new_game_load_screen"
    And I set the property "game_load_path" to "test-data/savearea"
    Then the game property "player.image_path" should be "'test-data/sprites/player20120411.png'"
    Then the game property "player.animation_width" should be "30"
    And I save slot 8
    And I load slot 8
    Then the game property "player.image_path" should be "'test-data/sprites/player20120411.png'"
    Then the game property "player.animation_width" should be "30"

  Scenario: Saving a game saves animation width
    Given I load the game "new_game_load_screen"
    And I set the property "game_load_path" to "test-data/savearea"
    When we reset the player to "player_bug" and load the level "simple"
    Then the game property "player.image_path" should be "'test-data/sprites/player_white_circle.png'"
    Then the game property "player.animation_width" should be "30"
    And I save slot 7
    And I load slot 7
    Then the game property "player.image_path" should be "'test-data/sprites/player_white_circle.png'"
    Then the game property "player.animation_width" should be "30"

 Scenario: Saving a game saves animation width
    Given I load the game "new_game_load_screen"
    And I set the property "game_load_path" to "test-data/savearea"
    When we upgrade the player with animation config
    Then the game property "player.image_path" should be "'test-data/sprites/enemy1gd.png'"
    Then the game property "player.animation_width" should be "30"
    And I save slot 6
    And I load slot 6
    Then the game property "player.image_path" should be "'test-data/sprites/enemy1gd.png'"
    Then the game property "player.animation_width" should be "30"


