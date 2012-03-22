Given /^I create a sound manager$/ do
  @sound_manager = SoundManager.new(@game)
  @game.sound_manager = @sound_manager
end

Given /^I add a sound effect from "([^"]*)" called "([^"]*)"$/ do |sound_file, sound_name|
  @sound_manager.add_effect("test-data/sounds/#{sound_file}", sound_name)
end

When /^I play the sound effect "([^"]*)"$/ do |sound_name|
  @sound_manager.play_effect(sound_name)
end

Then /^the play count for sound effect "([^"]*)" should be (\d+)$/ do |sound_name, expected_count|
  @sound_manager.play_count_for(sound_name).should == expected_count.to_i
end