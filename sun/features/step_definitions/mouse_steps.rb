
When /^I set the mouse position to (\d+), (\d+) in screen coords$/ do |arg1, arg2|
  #TODO might not be best design...
  @game.input_controller.stubs(:mouse_screen_coords).returns(GVector.xy(arg1.to_i, arg2.to_i))
end


Then /^the mouse world coordinates should be (\d+), (\d+)$/ do |arg1, arg2|
  @game.input_controller.mouse_world_coordinates.should be_within_epsilon_of(GVector.xy(arg1.to_f, arg2.to_f))
end
Then /^the mouse should be considered off screen$/ do
  @game.input_controller.mouse_on_screen.should be_false
end

Then /^the mouse should be considered on screen$/ do
  @game.input_controller.mouse_on_screen.should be_true
end

Then /^a "([^"]*)" event should be queued$/ do |arg1|
  ecs = @game.events.collect {|e| e.event_type.to_s}
  ecs.should be_include(eval(arg1))
end
Then /^there should be no events queued$/ do
  @game.events.should be_empty
end
Then /^the "([^"]*)" event should have "([^"]*)" equal to "([^"]*)"$/ do |event_class, property_string, expected_value|
  events = @game.events.select {|e| e.event_type.to_s == eval(event_class) }
  e = events.first
  invoke_property_string_on(e, property_string).to_s.should == expected_value
end