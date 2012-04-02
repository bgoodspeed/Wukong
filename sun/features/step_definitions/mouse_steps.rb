
When /^I set the mouse position to (\d+), (\d+) in screen coords$/ do |arg1, arg2|
  #TODO might not be best design...
  @game.input_manager.stubs(:mouse_screen_coords).returns([arg1.to_i, arg2.to_i])
end


Then /^the mouse world coordinates should be (\d+), (\d+)$/ do |arg1, arg2|
  @game.input_manager.mouse_world_coordinates.should == [arg1.to_i, arg2.to_i]
end
Then /^the mouse should be considered off screen$/ do
  @game.input_manager.mouse_on_screen.should be_false
end

Then /^the mouse should be considered on screen$/ do
  @game.input_manager.mouse_on_screen.should be_true
end

Then /^a "([^"]*)" event should be queued$/ do |arg1|
  ecs = @game.events.collect {|e| e.class.to_s}
  ecs.should be_include(arg1)
end
Then /^there should be no events queued$/ do
  @game.events.should be_empty
end
def invoke_property_string_on(e, property_string)
  properties = property_string.split(".")
  v = e
  properties.each {|prop|
    v = v.send(prop)
  }
  v
end
Then /^the "([^"]*)" event should have "([^"]*)" equal to "([^"]*)"$/ do |event_class, property_string, expected_value|
  events = @game.events.select {|e| e.class.to_s == event_class }
  e = events.first
  invoke_property_string_on(e, property_string).to_s.should == expected_value
end