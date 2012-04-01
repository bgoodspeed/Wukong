Feature: Image Manager
  In order to maintain efficiency and framework independence
  As a developer
  I want to be able to register filenames and control image loading

  Scenario: Image Name Mapping
    Given I load the game on level "demo" with screen size 640, 480
    When I create an image manager
    And I expect gosu to load the image 
    And I register image "foo/bar/baz.jpg"
    Then the image manager should be tracking 1 images
    
    