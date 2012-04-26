@needs_full_gosu
Feature: Sounds effects and music
  In order to play the game
  As a player
  I want to be able to hear events

  Scenario: Sound effect
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a sound controller
    And I add a sound effect from "weapon.wav" called "weapon"
    And I add a sound effect from "death.wav" called "death"
    When I play the sound effect "weapon"
    Then the play count for sound effect "weapon" should be 1
    Then the play count for sound effect "death" should be 0

  Scenario: Background Music
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a sound controller
    And I add a song from "music.wav" called "music"
    When I play the song "music"
    Then the play count for song "music" should be 1
    And the song "music" should be playing

  Scenario: Sounds and Music from File
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a sound controller from file "sound_config.yml"
    When I play the sound effect "weapon"
    Then the play count for sound effect "weapon" should be 1
    Then the play count for sound effect "death" should be 0
    Then the play count for song "music" should be 0

    
