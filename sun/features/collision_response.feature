Feature: Collision Response
  In order to react to collisions
  As a programmer
  I want to define responses based on the types involved in the collision

  Scenario: Collision Response
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a collision responder
    When a collision occurs between type "Player" and type "Enemy"
    Then the collision responses should be:
        | collision_response_type |
        | blocking1               |
        | damaging1               |
        | damaging2               |

  Scenario: Collision Response Projectile
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a collision responder
    When a collision occurs between type "Enemy" and type "VectorFollower"
    Then the collision responses should be:
        | collision_response_type |
        | damaging1               |
        | removing2               |
        
  Scenario: Collision Response Linesegment Enemy
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a collision responder
    When a collision occurs between type "LineSegment" and type "Enemy"
    Then the collision responses should be:
        | collision_response_type |
        | blocking2               |

  Scenario: Collision Response Enemy Linesegment
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a collision responder
    When a collision occurs between type "Enemy" and type "LineSegment"
    Then the collision responses should be:
        | collision_response_type |
        | blocking1               |

  Scenario: Collision Response config from Yaml
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a collision responder from file "collision_response.yml"
    When a collision occurs between type "VectorFollower" and type "LineSegment"
    Then the collision responses should be:
        | collision_response_type |
        | removing1               |

  Scenario: Collision Response Messaging
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a collision responder from file "collision_response.yml"
    When a collision occurs between type "Enemy" and type "VectorFollower"
    Then the collision responses should be:
        | collision_response_type |
        | removing2               |
        | temporary_message1      |

  Scenario: Collision Response Messaging
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a collision responder from file "collision_response.yml"
    When a collision occurs between type "Player" and type "Weapon"
    Then the collision responses should be:
        | collision_response_type |


  Scenario: Collision Response Messaging Invocation
    Given I load the game on level "trivial" with screen size 640, 480
    And I create a collision responder from file "collision_response.yml"
    Then the response for "temporary_message1" should enqueue a timed event


