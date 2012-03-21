
Given /^I create a game camera tracking the player$/ do
  @camera = Camera.new(@game)
  @game.camera = @camera
end
Then /^the camera should be centered at (\d+), (\d+)$/ do |arg1, arg2|
  @game.camera_position.should == [arg1.to_i, arg2.to_i]
end

Then /^the player screen coordinates should be (\d+), (\d+)$/ do |arg1, arg2|
  @player.screen_coordinates(@camera).should be_within_epsilon_of([arg1.to_f, arg2.to_f])
end

Then /^the enemy screen coordinates should be (\d+),(\d+)$/ do |arg1, arg2|
  @enemy.screen_coordinates(@camera).should be_within_epsilon_of([arg1.to_f, arg2.to_f])
end


Then /^the camera offset should be (\d+),(\d+)$/ do |arg1, arg2|
  @camera.offset.should be_within_epsilon_of([arg1.to_f, arg2.to_f])
end

Then /^the camera offset should be \-(\d+),\-(\d+)$/ do |arg1, arg2|
  @camera.offset.should be_within_epsilon_of([arg1.to_f * -1, arg2.to_f * -1])
end

Then /^the enemy screen coordinates should be (\d+),\-(\d+)$/ do |arg1, arg2|
  @enemy.screen_coordinates(@camera).should be_within_epsilon_of([arg1.to_f, arg2.to_f * -1])
end
