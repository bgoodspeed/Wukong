Given /^I create a sound manager$/ do
  @sound_manager = SoundManager.new(@game)
  @game.sound_manager = @sound_manager
end
Given /^I create a sound manager from file "([^"]*)"$/ do |configfile|
  @sound_manager = YamlLoader.from_file(SoundManager, @game, "test-data/sounds/#{configfile}")
  @game.sound_manager = @sound_manager
end

Given /^I add a sound effect from "([^"]*)" called "([^"]*)"$/ do |sound_file, sound_name|
  @sound_manager.add_effect("test-data/sounds/#{sound_file}", sound_name)
end

Given /^I add a song from "([^"]*)" called "([^"]*)"$/ do |sound_file, sound_name|
  @sound_manager.add_song("test-data/music/#{sound_file}", sound_name)
end

When /^I play the sound effect "([^"]*)"$/ do |sound_name|
  @sound_manager.play_effect(sound_name)
end

When /^I play the song "([^"]*)"$/ do |sound_name|
  @sound_manager.play_song(sound_name)
end


Then /^the play count for sound effect "([^"]*)" should be (\d+)$/ do |sound_name, expected_count|
  @sound_manager.play_count_for(sound_name).should == expected_count.to_i
end


Then /^the play count for song "([^"]*)" should be (\d+)$/ do |sound_name, expected_count|
  @sound_manager.play_count_for_song(sound_name).should == expected_count.to_i
end

Then /^the song "([^"]*)" should be playing$/ do |sound_name|
  @sound_manager.is_playing_song(sound_name).should be_true
end
