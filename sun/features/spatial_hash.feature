Feature: Data Structure for Storing Visual Data
  In order to store data
  As a programmer
  I want to be able to store geometric objects in a hash

  Scenario Outline: Spatial indexing
    Given I create a spatial hash with cell size 10
    Then the cell coordinate for vertex <x>,<y> is <i>,<j>

  Examples:
   | x    | y    | i    | j    |
   | 0    | 0    | 0    | 0    |
   | 9    | 0    | 0    | 0    |
   | 0    | 9    | 0    | 0    |
   | 9    | 9    | 0    | 0    |
   | 9    | 10   | 0    | 1    |
   | 10   | 9    | 1    | 0    |
   | 10   | 10   | 1    | 1    |
   | 45   | 65   | 4    | 6    |


  Scenario Outline: Spatial hashing
    Given I create a spatial hash with cell size 10
    When I override the table size to 100
    And I override the x prime to 73856093
    And I override the y prime to 19349663
    Then the hash for <i>,<j> should be <hash>

  Examples:
   | i    | j    | hash      |
   | 0    | 0    | 0         |
   | 0    | 1    | 63        |
   | 1    | 0    | 93        |
   | 1    | 1    | 94        |
   | 87   | 98   | 89        |
   | 45   | 45   | 34        |

  Scenario: Spatial Storage
    Given I create a spatial hash with cell size 10
    When I override the table size to 10
    And I add data "foo" at (10, 20)
    And I add data "bar" at (10, 21)
    Then the cell coordinate for vertex 10,20 is 1,2
    Then the cell coordinate for vertex 10,21 is 1,2
    And the hash for 1,2 should be 7
    And the data array looks like:
        | hash_index | data        |
        | 9          |             |
        | 8          |             |
        | 7          | foo,bar     |

  Scenario: Spatial Storage Deletion
    Given I create a spatial hash with cell size 10
    When I override the table size to 10
    And I add data "foo" at (10, 20)
    And I add data "bar" at (10, 21)
    And I clear the spatial hash
    And the data array looks like:
        | hash_index | data        |
        | 7          |             |


  Scenario: Collision Detection
    Given I create a spatial hash with cell size 10
    When I override the table size to 10
    And I add data "mid" at (50, 50)
    And I add data "left" at (40, 50)
    And I add data "right" at (60, 50)
    And I add data "up" at (50, 60)
    And I add data "down" at (50, 40)
    Then asking for collision candidates yields:
        | center_x | center_y | radius | candidate_data         |
        | 1        |1         | 1      |                        |
        | 51       |51        | 1      | mid                    |
        | 55       |55        | 10     | mid,right,up,left,down |

  Scenario: Collision Detection 2
    Given I create a spatial hash with cell size 10
    When I override the table size to 10
    And I add data "mid" at (50, 50)
    And I add data "left" at (40, 50)
    And I add data "right" at (60, 50)
    And I add data "up" at (50, 60)
    And I add data "down" at (50, 40)
    And I add data "down_left" at (40, 40)
    Then asking for collision candidates yields:
        | center_x | center_y | radius | candidate_data                   |
        | 55       |55        | 10     | mid,right,up,left,down,down_left |
    Then asking for collision pairs yields:
        | center_x | center_y | radius | candidate_data                   |
        | 55       |55        | 10     | mid,right,up                     |

        

  Scenario: Collision Detection 3
    Given I create a spatial hash with cell size 10
    When I override the table size to 10
    And I add line segment 0,0:0,480 with data "xfixed"
    And I add line segment 0,0:640,0 with data "yfixed"
    Then asking for collision candidates yields:
        | center_x | center_y | radius | candidate_data         |
        | 36       | 16       | 36     | xfixed,yfixed          |
    Then asking for collision pairs yields:
        | center_x | center_y | radius | candidate_data                   |
        | 37       | 16       | 36     | yfixed                           |
        | 36       | 16       | 36     | xfixed,yfixed                    |


  Scenario: Collision Detection 4
    Given I create a spatial hash with cell size 100
    When I override the table size to 100
    And I add line segment 111,0:115,15 with data "B"
    And I add line segment 266,0:249,4 with data "C"
    And I add line segment 248,5:237,15 with data "D"
    And I add line segment 115,16:121,35 with data "E"
    And I add line segment 236,16:230,30 with data "F"
    And I add line segment 229,31:184,45 with data "G"
    And I add line segment 122,35:154,35 with data "H"
    And I add line segment 155,36:183,45 with data "I"
    Then asking for collision candidates yields:
      | center_x | center_y | radius | candidate_data         |
      | 242       | 10       | 2       | C,D,F,G                 |
      | 245       | 8        | 2       | C,D,F,G                 |
      | 239       | 12       | 2       | C,D,F,G                 |
    Then asking for collision pairs yields:
      | center_x | center_y | radius | candidate_data         |
      | 242       | 10       | 2       | D                        |
      | 245       | 8        | 2       | D                        |
      | 239       | 12       | 2       | D                        |

  Scenario: Collision Detection 5
    Given I create a spatial hash with cell size 100
    When I override the table size to 100
    And I add line segment 182,45:229,31 with data "WEIRD"
    Then asking for collision candidates yields:
      | center_x | center_y | radius | candidate_data         |
      | 212       | 31       | 8       | WEIRD                   |
      | 212       | 31       | 3       | WEIRD                   |
      | 212       | 31       | 2       | WEIRD                   |
      | 212       | 31       | 1       | WEIRD                   |
    Then asking for collision pairs yields:
      | center_x | center_y | radius | candidate_data         |
      | 212       | 31       | 8       | WEIRD                   |
      | 212       | 31       | 6       | WEIRD                   |
      | 212       | 31       | 5       | WEIRD                   |
      | 212       | 31       | 4       |                         |

  Scenario: Collision Detection 6
    Given I create a spatial hash with cell size 100
    When I override the table size to 100
    And I add line segment 182,45:227,31 with data "WEIRD"
    Then asking for collision candidates yields:
      | center_x | center_y | radius | candidate_data         |
      | 220       | 35       | 8       | WEIRD                   |
    Then asking for collision pairs yields:
      | center_x | center_y | radius | candidate_data         |
      | 220       | 35       | 8       | WEIRD                   |

  Scenario: Collision Detection 7
    Given I create a spatial hash with cell size 100
    When I override the table size to 100
    And I add line segment 182,45:227,31 with data "WEIRD"
    And I add line segment 0,0:800,0 with data "top"
    And I add line segment 0,0:0,600 with data "left"
    And I add line segment 800,0:800,600 with data "bottom"
    And I add line segment 0,600:800,600 with data "right"
    Then asking for collision candidates yields:
      | center_x | center_y | radius | candidate_data         |
      | 0         | 201       |  8     | left                    |
      | 0         | 10       |  8      | top,left               |
    Then asking for collision pairs yields:
      | center_x | center_y | radius | candidate_data         |
      | 0         | 100       |  8     | left                    |
      | 0         | 10       |  8      | left                    |

  Scenario: Collision Detection Gvector usage
    Given I create a line segment 123,456:789,101
    Then the line segment property "p1.class" should be "GVector"

  Scenario: Collision Detection 8
    Given I create a spatial hash with cell size 100
    When I override the table size to 100
    And I add line segment 2203,1180:2342,1262 with data "diagonal"
    Then asking for collision candidates yields:
      | center_x | center_y | radius | candidate_data         |
      | 2285     | 1228       |  8     | diagonal                |
      | 2285     | 1225       |  8     | diagonal                |
    Then asking for collision pairs yields:
      | center_x | center_y | radius | candidate_data         |
      | 2285     | 1228       |  8     | diagonal                |
      | 2285     | 1226       |  8     | diagonal                |
      | 2287     | 1226       |  8     | diagonal                |

  Scenario: Collision Detection Game Bug 1
    Given I create a spatial hash with cell size 100
    When I override the table size to 100
    And I add line segment 2200,1179:2579,1394 with data "d"
    Then the effected spatial hash indices are: "[ 10, 34, 47, 56, 71 ]"
    Then the cell coordinate for vertex 2200,1179 is 22,11
    Then the cell coordinate for vertex 2274,1221 is 22,12
    Then the cell coordinate for vertex 2579,1394 is 25,13
    And the hash for 22,11 should be 47
    And the hash for 22,12 should be 10
    And the hash for 25,13 should be 34

    And the data array looks like:
      | hash_index | data        |
      | 34          | d           |
      | 47          | d           |
      | 10          | d           |
    Then asking for collision candidates yields:
      | center_x | center_y | radius | candidate_data         |
      | 2285     | 1228       |  30    | d                       |
      | 2274     | 1221       |  30    | d                       |
      | 2274     | 1221       |  16    | d                       |
    Then asking for collision pairs yields:
      | center_x | center_y | radius | candidate_data         |
      | 2285     | 1228       |  30     | d                      |
      | 2285     | 1228       |  16     | d                      |
      | 2274     | 1221       |  30     | d                       |
      | 2274     | 1221       |  16     | d                       |
      | 2274     | 1221       |  8      | d                       |
      | 2285     | 1228       |  8     | d                      |

  Scenario: Collision Detection Push Puzzle Bug
    Given I create a spatial hash with cell size 100
    When I override the table size to 100
    And I add line segment 150,150:190,150 with data "p1p2"
    And I add line segment 190,150:190,230 with data "p2p3"
    And I add line segment 190,230:150,230 with data "p3p4"
    And I add line segment 150,230:150,150 with data "p4p1"
    And I add line segment 150,150:190,230 with data "p1p3"
    And I add line segment 190,150:150,230 with data "p2p4"
    Then asking for collision candidates yields:
      | center_x | center_y | radius | candidate_data           |
      | 150      | 210      | 2      | p2p3,p3p4,p4p1,p1p3,p2p4 |
      | 190      | 210      | 2      | p2p3,p3p4,p4p1,p1p3,p2p4 |

    Then asking for collision pairs yields:
      | center_x | center_y | radius | candidate_data           |
      | 150      | 210      | 2      | p4p1                     |
      | 190      | 210      | 2      | p2p3                     |
      | 190      | 210      | 16     | p2p3,p1p3                |
      | 170      | 210      | 16     | p1p3,p2p4                |
