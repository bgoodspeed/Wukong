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

  Scenario: Vector Distance Apart
    Given we import vector math on arrays
    Then I should be able to get distance between two vectors
      | vector1 | vector2 | expected_distance |
      | 0,0     | 0,0     | 0                 |
      | 0,0     | 1,0     | 1                 |
      | 0,0     | 2,0     | 2                 |
      | 0,0     | 0,2     | 2                 |
      | 0,0     | 4,3     | 5                 |

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

  Scenario: Circle Point Intersection
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
      | 10,10:7.5 | 0,0:5,5             | true        |
      | 10,10:7.1  | 0,0:5,5            | true        |
      | 10,10:4    | 0,0:3.9,3.9        | false       |
      | 2730,280:8  | 2722,250:2741,314 | true       |
      | 2730,280:2  | 2722,250:2741,314 | true       |
      | 2730,280:32 | 2721,250:2742,314 | true       |
      | 2728,265:8  | 2728,250:2748,311   | true       |
      | 2737,281:8  | 2724,251:2745,316   | true       |
      | 2237,1617:8 | 2080,1836:2238,1613 | true       |
      | 2156,1735:8 | 2080,1836:2238,1613 | true       |
      | 2274,1221:8 | 2200,1179:2580,1395 | true       |
      | 2274,1221:4 | 2200,1179:2580,1395 | true       |
      | 2274,1221:2 | 2200,1179:2580,1395 | true       |
      | 2274,1221:1 | 2200,1179:2580,1395 | true       |

  Scenario: Circle Rectangle Intersection
    Given we import vector math on arrays
    Then I should be able to test intersection of the following circles and rectangles
      | circle     | rectangle                       | intersects? |
      | 0,0:1      | 0,-10:0,10:10,10:10,-10         | true        |
      | 0,0:1      | 0,-2:0,2:2,2:2,-2               | true        |
      | 4,4:1      | 0,-2:0,2:2,2:2,-2               | false       |
      | 100,100:36 | 10,10:10,200:300,200:300,10     | true        |
      | 100,100:8  | 10,10:10,200:300,200:300,10     | true        |
      | 170,210:36 | 150,150:190,150:190,230:150,230 | true        |
      | 170,210:8  | 150,150:190,150:190,230:150,230 | true        |
      | 170,210:4  | 150,150:190,150:190,230:150,230 | true        |
      | 170,210:1  | 150,150:190,150:190,230:150,230 | true        |

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

  Scenario: Rectangle Rectangle Intersection
    Given we import vector math on arrays
    Then I should be able to test intersection of the following rectangles
      | rectangle1                 | rectangle2                | intersects? |
      | 0,-1:0,1:1,1:1,-1          | 0,-1:0,1:1,1:1,-1         | true        |
      | 1,1:61,1:61,31:1,31        | 1,1:61,1:61,31:1,31       | true        |
      | 1,1:61,1:61,31:1,31        | 1,30:61,30:61,60:1,60     | true        |
      | 1,1:61,1:61,31:1,31        | 1,31:61,31:61,60:1,60     | true        |
      | 1,1:61,1:61,31:1,31        | 1,28:61,28:61,60:1,60     | true        |
      | 1,1:61,1:61,31:1,31        | 1,27:61,27:61,57:1,57     | true        |
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

  Scenario: Line Segment Line Segment Intersection
    Given we import vector math on arrays
    Then I should be able to test intersection of the following line segments
      | line_segment1              | line_segment2         | intersects? |
      | 0,0:1,1                    | 2,2:3,3               | false       |
      | 1,0:-1,0                   | 0,1:0,-1              | true        |








