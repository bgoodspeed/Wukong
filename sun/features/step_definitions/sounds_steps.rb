Given /^I create a sound controller$/ do
  @sound_controller = SoundController.new(@game)
  @game.sound_controller = @sound_controller
end
Given /^I create a sound controller from file "([^"]*)"$/ do |configfile|
  @sound_controller = YamlLoader.from_file(SoundController, @game, "test-data/sounds/#{configfile}")
  @game.sound_controller = @sound_controller
end

Given /^I add a sound effect from "([^"]*)" called "([^"]*)"$/ do |sound_file, sound_name|
  @sound_controller.add_effect("test-data/sounds/#{sound_file}", sound_name)
end

Given /^I add a song from "([^"]*)" called "([^"]*)"$/ do |sound_file, sound_name|
  @sound_controller.add_song("test-data/music/#{sound_file}", sound_name)
end

When /^I play the sound effect "([^"]*)"$/ do |sound_name|
  @sound_controller.play_effect(sound_name)
end

When /^I play the song "([^"]*)"$/ do |sound_name|
  @sound_controller.play_song(sound_name)
end


Then /^the play count for sound effect "([^"]*)" should be (\d+)$/ do |sound_name, expected_count|
  @sound_controller.play_count_for(sound_name).should == expected_count.to_i
end


Then /^the play count for song "([^"]*)" should be (\d+)$/ do |sound_name, expected_count|
  @sound_controller.play_count_for_song(sound_name).should == expected_count.to_i
end

Then /^the song "([^"]*)" should be playing$/ do |sound_name|
  @sound_controller.is_playing_song(sound_name).should be_true
end
