Feature: Vector Math
  In order to to do basic collision detection and the like
  Arrays should be outfitted with some convenience methods for vector math

  Scenario: Addition
    Given we import vector math on arrays
    Then I should be able to add the following vectors
      | vector1 | vector2 | expected_sum |
      | 0,0     | 0,0     | 0,0          |
      | 1,0     | 0,1     | 1,1          |
      | -1,-1   | 1,1     | 0,0          |
      | 2.3,4.2 | -2.2,1  | 0.1,5.2      |

  Scenario: Subtraction
    Given we import vector math on arrays
    Then I should be able to subtract the following vectors
      | vector1 | vector2 | expected_difference |
      | 0,0     | 0,0     | 0,0                 |
      | 1,0     | 0,1     | 1,-1                |
      | -1,-1   | 1,1     | -2,-2               |
      | 2.3,4.2 | -2.2,1  | 4.5,3.2             |

  Scenario: Dot Products
    Given we import vector math on arrays
    Then I should be able to take the dot product of the following vectors
      | vector1 | vector2 | expected_dot_product |
      | 0,0     | 0,0     | 0                    |
      | 1,0     | 0,1     | 0                    |
      | -1,-1   | 1,1     | -2                   |
      | 2.3,4.2 | -2.2,1  | -0.86                |
      | 10,20   | 2,7     | 160                  |

  Scenario: Vector Length
    Given we import vector math on arrays
    Then I should be able to get the length of the following vectors
      | vector | expected_length |
      | 0,0    | 0               |
      | 1,0    | 1               |
      | 2,0    | 2               |
      | 0,2    | 2               |
      | 4,3    | 5               |

  Scenario: Vector Unit
    Given we import vector math on arrays
    Then I should be able to get the unit of the following vectors
      | vector | expected_unit |
      | 1,0    | 1,0           |
      | 0,1    | 0,1           |
      | 4,3    | 0.8,0.6       |
      | -3,-4  | -0.6,-0.8     |

  Scenario: Circle Circle Intersection
    Given we import vector math on arrays
    Then I should be able to test intersection of the following circles
      | circle1  | circle2  | intersects? | 
      | 0,0:1    | 0,0:1    | true        |
      | 0,0:2    | 0,0:1    | true        |
      | 2,0:1    | 0,0:1    | true        |
      | 2.1,0:1  | 0,0:1    | false       |
      | 10,10:1  | 2,2:5    | false       |

  Scenario: Circle Line Segment Intersection
    Given we import vector math on arrays
    Then I should be able to test intersection of the following circles and points
      | circle    | point  | intersects? | 
      | 0,0:1     | 0,0    | true        |
      | 0,0:1     | 1,0    | true        |
      | 0,0:1     | 0,1    | true        |
      | 0,0:1     | 0,1.1  | false       |
      | 0,0:1     | 1.1,0  | false       |
      | 2,2:2     | 2,4    | true        |
      | 2,2:2     | 4,2    | true        |
      | 2,2:2     | 4,4    | false       |
      | 10,10:5   | 0,0    | false       |


  Scenario: Circle Line Segment Intersection
    Given we import vector math on arrays
    Then I should be able to test intersection of the following circles and line segments
      | circle    | line_segment  | intersects? | 
      | 0,0:1     | 0,-10:0,10    | true        |
      | 0,0:1     | 1,-10:1,10    | true        |
      | 0,0:1     | 2,-10:2,10    | false       |
      | 10,10:5   | 0,0:5,5       | false       |
      | 10,10:7.5 | 0,0:5,5       | true        |
      | 10,10:7.1 | 0,0:5,5       | true        |
      | 10,10:4   | 0,0:3.9,3.9   | false       |


  Scenario: Circle Rectangle Intersection
    Given we import vector math on arrays
    Then I should be able to test intersection of the following circles and rectangles
      | circle    | rectangle                  | intersects? | 
      | 0,0:1     | 0,-10:0,10:10,10:10,-10    | true        |
      | 0,0:1     | 0,-2:0,2:2,2:2,-2          | true        |
      | 4,4:1     | 0,-2:0,2:2,2:2,-2          | false       |

  Scenario: Circle Triangle Intersection
    Given we import vector math on arrays
    Then I should be able to test intersection of the following circles and triangles
      | circle    | triangle                  | intersects? | 
      | 0,0:1     | 0,-10:0,10:10,10          | true        |
      | 0,0:1     | 0,-2:0,2:2,2              | true        |
      | 4,4:1     | 0,-2:0,2:2,2              | false       |

  Scenario: Rectangles
    Given we import vector math on arrays
    Then I should be able to get the left right top and bottom values for these rectangles
      | rectangle            | left | right | top | bottom | 
      | 0,-1:0,1:1,1:1,-1    | 0    | 1     | 1   | -1     | 
      | 12,-11:0,1:-10,9:1,1 | -10  | 12    | 9   | -11    | 
    
  Scenario: Rectangle Rectangle Intersection
    Given we import vector math on arrays
    Then I should be able to test intersection of the following rectangles
      | rectangle1                 | rectangle2                | intersects? | 
      | 0,-1:0,1:1,1:1,-1          | 0,-1:0,1:1,1:1,-1         | true        |
      | 0,-1:0,1:1,1:1,-1          | 5,10:5,-10:6,-10:6,10     | false       |

  Scenario: Rectangle Point Intersection
    Given we import vector math on arrays
    Then I should be able to test intersection of the following rectangles and points
      | rectangle                  | point                | intersects? | 
      | -1,-1:-1,1:1,1:1,-1        | 0,-1                 | true        |
      | -1,-1:-1,1:1,1:1,-1        | 0,0                  | true        |
      | -1,-1:-1,1:1,1:1,-1        | 1.1,0                | false       |
      | -1,-1:-1,1:1,1:1,-1        | 0,1.1                | false       |
      | -1,-1:-1,1:1,1:1,-1        | 1.1,1.1              | false       |

  Scenario: Rectangle Line Segment Intersection
    Given we import vector math on arrays
    Then I should be able to test intersection of the following rectangles and line segments
      | rectangle                  | line_segment         | intersects? | 
      | -1,-1:-1,1:1,1:1,-1        | 0,-1:0,0             | true        |
      | -1,-1:-1,1:1,1:1,-1        | 0,0:1,1              | true        |
      | -1,-1:-1,1:1,1:1,-1        | 1.1,0:2.2,2.2        | false       |
      | -1,-1:-1,1:1,1:1,-1        | 0,1.1:2.2,2.2        | false       |
      | -1,-1:-1,1:1,1:1,-1        | 1.1,1.1:2.2,2.2      | false       |








