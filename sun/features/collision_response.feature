Feature: Collision Response
  In order to react to collisions
  As a programmer
  I want to define responses based on the types involved in the collision

  Scenario: Collision Response
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a collision responder
    When a dynamic collision occurs between type "Player" and type "Enemy"
    Then the dynamic collision responses should be:
        | collision_response_type |
        | blocking1               |
        | damaging1               |
        | damaging2               |

  Scenario: Collision Response Projectile
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a collision responder
    When a dynamic collision occurs between type "Enemy" and type "VectorFollower"
    Then the dynamic collision responses should be:
        | collision_response_type |
        | damaging1               |
        | removing2               |
        

