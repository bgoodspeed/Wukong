Feature: ZOrder Details
  In order to play the game
  As a developer
  I want to be able to draw things on different layers

  Scenario: ZOrder
    Given I load the ZOrder module
    Then the ordering should be:
       | zorder value | zorder name |
       | 0            | background  |
       | 1            | static      |
       | 2            | dynamic     |
       | 3            | hud         |

