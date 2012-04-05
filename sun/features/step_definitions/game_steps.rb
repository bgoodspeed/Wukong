

Given /^I load the game on level "([^"]*)" with screen size (\d+), (\d+)$/ do |level_to_load, width, height|
  @game = Game.new({:width => width.to_i, :height => height.to_i})
  @level = @game.load_level("test-data/levels/#{level_to_load}/#{level_to_load}.yml")
end
Given /^I load the game "([^"]*)"$/ do |arg1|
  @game = YamlLoader.game_from_file("test-data/#{arg1}.yml")
end

Given /^I set the screen size to (\d+),(\d+)$/ do |width, height|
  @game.set_screen_size(width, height)
end

When /^I see the first frame$/ do
  @game.render_one_frame
end

Then /^I should be at (\d+),(\d+) in the game space$/ do |expected_x, expected_y|
  @game.player_position.should == [expected_x.to_i, expected_y.to_i]
end

Then /^there should be (\d+) event areas$/ do |arg1|
  @game.level.event_areas.size.should == arg1.to_i
end

Then /^the event areas should be:$/ do |table|
  areas = @game.level.event_areas
  table.hashes.each_with_index {|hash, idx|
    areas[idx].rect.to_s.should == hash['rectangle_to_s']
    areas[idx].label.should == hash['label']
    areas[idx].action.should == hash['action']
  }
end