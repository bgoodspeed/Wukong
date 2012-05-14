

Given /^I create a GameWindow mocking game$/ do
  @game_mock = mock_game
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
  @line_seg = Primitives::LineSegment.new(GVector.xy(x1.to_i, y1.to_i), GVector.xy(x2.to_i, y2.to_i))
end

Given /^I make a circle at \[(\d+),(\d+)\] radius (\d+)$/ do |x, y, rad|
  @circle = Primitives::Circle.new(GVector.xy(x.to_i, y.to_i), rad.to_i)
end

When /^I check collision between the line segment and the circle i should get true$/ do
  @collider.check_for_collision_by_type(@line_seg, @circle).should == true
end



Given /^I create an event area$/ do
  @mock_game = mock_game
  conf = { 'action' => 'action', 'action_argument' => 'action_argument'}
  @event_area = EventArea.new(@mock_game,conf)
end

Given /^I expect "([^"]*)" with event area for the argument on the action controller$/ do |arg1|
  @mock_game.stubs(:action_controller).returns @mock_game
  @mock_game.expects(:invoke).with("action", @event_area)
end

When /^I call "([^"]*)" on the event area$/ do |arg1|
  @event_area.send(arg1)
end

Given /^I create an action controller mocking game$/ do
  @mock_game = mock_game
  @action_controller = ActionController.new(@mock_game)
end

Then /^I expect the games "([^"]*)" to receive "([^"]*)"$/ do |delegate, arg2|
  @mock_game.stubs(delegate).returns @mock_game
  @mock_game.stubs("player").returns @mock_game
  @mock_game.stubs("clock").returns @mock_game
  @mock_game.stubs("menu_action_delay").returns 10
  @mock_game.stubs("enqueue_event")
  @mock_game.expects(arg2)
end

When /^I invoke the action "([^"]*)" with set "([^"]*)"$/ do |arg1, arg2|
  @action_controller.invoke(eval(arg1), nil, @action_controller.send(arg2))
end

Given /^I create a vector follower with start "([^"]*)", vector "([^"]*)", velocity "([^"]*)"$/ do |arg1, arg2, arg3|
  start = eval(arg1)
  start_v = GVector.xy(start[0], start[1])
  vector = eval(arg2)
  vector_v = GVector.xy(vector[0], vector[1])
  @vector_follower = VectorFollower.new(start_v , vector_v, eval(arg3), "fake owner2")
  @last = @vector_follower
end
Then /^the last should match the fragment "([^"]*)"$/ do |arg1|
  @last.to_s.should =~ Regexp.new(arg1)
end

Given /^I create an event with arg "([^"]*)" and event type "([^"]*)"$/ do |arg1, arg2|
  @event = Event.new(arg1, arg2)
  @last = @event
end

Then /^the vector should match the fragment "([^"]*)"$/ do |arg1|
  
end

Given /^I create a path following controller$/ do
  @path_following_controller = PathFollowingController.new(mock_game)
end

def mock_tracking_target
  m = Mocha::Mock.new("tracking target")
  m.stubs(:tracking_target).returns GVector.xy(0,0)
  m
end
Given /^I add tracking$/ do
  @tracking_target = mock_tracking_target
  @path_following_controller.add_tracking(@tracking_target, "bar")
end

Then /^the path following controller should be tracking (\d+)$/ do |arg1|
  @path_following_controller.tracking.size.should == arg1.to_i
end

Then /^I remove tracking$/ do
  @path_following_controller.remove_tracking(@tracking_target, "bar")
end

Given /^I create a game clock$/ do
  @clock = Clock.new(nil, 60)
end

Given /^I tick the game clock$/ do
  @clock.tick
end

Then /^the elapsed time should be less than (\d+) ms$/ do |arg1|
  @clock.elapsed_time_ms.should be_<(arg1.to_i)
end

def mock_inventory
  m = Mocha::Mock.new("mock inventory")
  m.stubs(:weapon).returns @weapon
  m
end
Given /^I create a player with a mock inventory$/ do
  @mock_game = mock_game
  @weapon = Weapon.new(@mock_game, "foo")
  Inventory.stubs(:new).returns mock_inventory
  conf = {'image_path' => "foo"}
  @player = Player.new(@mock_game, conf )
end

Given /^I activate the weapon$/ do
  @player.inventory.weapon.in_use = true
end

When /^I tick the weapon$/ do
  @player.tick_weapon
end

Then /^the weapon should active$/ do
  @player.inventory.weapon.in_use.should == true
end

When /^I stop the weapon$/ do
  @player.stop_weapon
end

Then /^the weapon should not be active$/ do
  @player.inventory.weapon.in_use.should == true
end

Given /^I create a level$/ do
  @level = Level.new
end

Given /^I add a fake completion condition to both and and or$/ do
  @level.add_anded_completion_condition("and")
  @level.add_ored_completion_condition("or")
end

Given /^I require the dll or shared object "([^"]*)"$/ do |arg1|
  #WINDOWS
  #TODO need to determine if this ungodly magic voodoo will cause it require the DLL on windows
  require 'utility/ripmunk'
end



When /^I create a sample class which includes the module$/ do
  class Sample
    include PrimitiveOpsCpp
  end

  @sample = Sample.new
end

Then /^the method "([^"]*)" should be defined on the sample$/ do |arg1|
  @sample.should be_respond_to(arg1)
end
