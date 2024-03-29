
Given /^I create a game camera tracking the player$/ do
  @camera = Camera.new(@game)
  @game.camera = @camera
end
Then /^the camera should be centered at (\d+), (\d+)$/ do |arg1, arg2|
  cp = @game.camera_position
  cp.x.should == arg1.to_f
  cp.y.should == arg2.to_f

end

Then /^the player screen coordinates should be (\d+), (\d+)$/ do |arg1, arg2|
  @camera.screen_coordinates_for(@player.position).should be_within_epsilon_of(GVector.xy(arg1.to_f, arg2.to_f))
end

Then /^the enemy screen coordinates should be (\d+),(\d+)$/ do |arg1, arg2|
  @camera.screen_coordinates_for(@enemy.position).should be_within_epsilon_of(GVector.xy(arg1.to_f, arg2.to_f))
end

Then /^the camera offset should be (\d+),(\d+)$/ do |arg1, arg2|
  @camera.offset.should be_within_epsilon_of(GVector.xy(arg1.to_f, arg2.to_f))
end

Then /^the camera offset should be \-(\d+),\-(\d+)$/ do |arg1, arg2|
  @camera.offset.should be_within_epsilon_of(GVector.xy(arg1.to_f * -1, arg2.to_f * -1))
end

Then /^the enemy screen coordinates should be (\d+),\-(\d+)$/ do |arg1, arg2|
  @camera.screen_coordinates_for(@enemy.position).should be_within_epsilon_of(GVector.xy(arg1.to_f, arg2.to_f * -1))
end
