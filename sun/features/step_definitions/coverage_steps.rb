
Given /^I create a GameWindow mocking game$/ do
  @game_mock = Mocha::Mock.new("game mock")
  @game_window = GameWindow.new(@game_mock, 640, 480)
end

Given /^I expect "([^"]*)" on game mock$/ do |arg1|
    @game_mock.expects(arg1)
end

When /^"([^"]*)" is called on the GameWindow$/ do |arg1|
  @game_window.send(arg1)
end

Then /^expectations should be met$/ do
  #NOOP automatically verified my Mocha::Mock.teardown
end

Given /^I create a screen mocking game window$/ do
  @game_window_mock = Mocha::Mock.new("game window mock")
  GameWindow.stubs(:new).returns @game_window_mock
  @screen = Screen.new(nil, 640, 480)
end

Given /^I expect "([^"]*)" on game window mock$/ do |arg1|
  @game_window_mock.expects(arg1)
end

When /^"([^"]*)" is called on the screen$/ do |arg1|
  @screen.send(arg1)
end


Given /^I create a collider$/ do
  @collider = Collider.new
end

Given /^I make a line segment from \[(\d+),(\d+)\] to \[(\d+), (\d+)\]$/ do |x1, y1, x2, y2|
  @line_seg = Primitives::LineSegment.new([x1.to_i, y1.to_i], [x2.to_i, y2.to_i])
end

Given /^I make a circle at \[(\d+),(\d+)\] radius (\d+)$/ do |x, y, rad|
  @circle = Primitives::Circle.new([x.to_i, y.to_i], rad.to_i)
end

When /^I check collision between the line segment and the circle i should get true$/ do
  @collider.check_for_collision_by_type(@line_seg, @circle).should == true
end
