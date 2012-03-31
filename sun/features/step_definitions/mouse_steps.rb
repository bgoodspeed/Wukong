
When /^I set the mouse position to (\d+), (\d+) in screen coords$/ do |arg1, arg2|
  #TODO might not be best design...
  @game.stubs(:mouse_screen_coords).returns([arg1.to_i, arg2.to_i])
end


Then /^the mouse world coordinates should be (\d+), (\d+)$/ do |arg1, arg2|
  @game.mouse_world_coordinates.should == [arg1.to_i, arg2.to_i]
end
Then /^the mouse should be considered off screen$/ do
  @game.mouse_on_screen.should be_false
end

Then /^the mouse should be considered on screen$/ do
  @game.mouse_on_screen.should be_true
end
