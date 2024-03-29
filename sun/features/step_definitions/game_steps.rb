
def stub_window
  m = Mocha::Mock.new("gamewindow")
  m.stubs(:window).returns m
  m.stubs(:button_down?).returns true #HACK
  m
end

def stub_song
  m = Mocha::Mock.new("song")
  m.stubs(:play).returns
  m
end
def stub_sample
  m = Mocha::Mock.new("sample")
  m.stubs(:play).returns
  m
end

def stub_font
  m = Mocha::Mock.new("font")
  m
end
def stub_image
  m = Mocha::Mock.new("image")
  m.stubs(:width).returns 36
  m.stubs(:height).returns 36 #HACK
  m
end

def stub_out_gosu
  GameWindow.stubs(:new).returns(stub_window)
  GameWindow.stubs(:initialize).returns(stub_window)
  Graphics::Window.stubs(:new).returns(stub_window)
  Graphics::Window.stubs(:initialize).returns(stub_window)
  Graphics::Font.stubs(:new).returns(stub_font)
  Graphics::Image.stubs(:new).returns(stub_image)
  Graphics::Image.stubs(:load_tiles).returns(stub_image)
  Graphics::Sample.stubs(:new).returns(stub_sample)
  Graphics::Song.stubs(:new).returns(stub_song)
end

Given /^I use the game named "([^"]*)"$/ do |arg1|
  @game = lookup_game_named("test-data/#{arg1}.yml")
end


Given /^I load the game "(.*?)" on level "(.*?)"$/ do |game, level_to_load|
  @game = YamlLoader.game_from_file("test-data/#{game}.yml")
  @level = @game.load_level("test-data/levels/#{level_to_load}/#{level_to_load}.yml")

end

Given /^I load the game on level "([^"]*)" with screen size (\d+), (\d+)$/ do |level_to_load, width, height|
  stub_out_gosu if $can_stub_out_gosu
  @game = Game.new({:width => width.to_i, :height => height.to_i})
  @level = @game.load_level("test-data/levels/#{level_to_load}/#{level_to_load}.yml")
end
Given /^I load the game "([^"]*)"$/ do |arg1|
  stub_out_gosu if $can_stub_out_gosu
  @game = YamlLoader.game_from_file("test-data/#{arg1}.yml")
end

Given /^I set the screen size to (\d+),(\d+)$/ do |width, height|
  @game.set_screen_size(width, height)
end

When /^I see the first frame$/ do
  @game.render_one_frame
end

Then /^I should be at (\d+),(\d+) in the game space$/ do |expected_x, expected_y|
  @game.player_position.should == GVector.xy(expected_x.to_i, expected_y.to_i)
end

Then /^there should be (\d+) event areas$/ do |arg1|
  @game.level.event_areas.size.should == arg1.to_i
end

Then /^the event areas should be:$/ do |table|
  areas = @game.level.event_areas
  table.hashes.each_with_index {|hash, idx|
    areas[idx].rect.to_s.should == hash['rectangle_to_s'] if hash.has_key?('rectangle_to_s')
    areas[idx].label.should == hash['label']
    areas[idx].action.should == hash['action']
    "#{areas[idx].action_argument}".should == "#{hash['action_argument']}"
    "#{areas[idx].description_joined}".should == "#{hash['description joined']}" if hash.has_key?('description joined')

  }
end

Then /^I load slot (\d+)$/ do |arg1|
  @game.load_game_slot(arg1.to_i)
end

Given /^I save slot (\d+)$/ do |arg1|
  @name = @game.save_game_slot(arg1.to_i)
end


Then /^the save file should match "([^"]*)"$/ do |arg1|
  
  actual_lines = IO.readlines(@name)
  expected_lines = IO.readlines("test-data/loads/#{arg1}")

  expected_lines.each do |line1|
    l1 = line1.strip
    matched = actual_lines.select {|line2| line2.strip =~ Regexp.new(l1) }
    matched.should_not be_empty, "Expected #{line1} to be in #{actual_lines}"
  end

end

Given /^I set the property "([^"]*)" to "([^"]*)"$/ do |arg1, arg2|
  
  cmds = arg1.split(".")
  if cmds.size == 1
    @game.send("#{arg1}=", arg2)
  else
    p = @game
    allbutlast = cmds[0..cmds.size - 2]
    allbutlast.each {|cmd| p = p.send(cmd)}
    p.send("#{cmds.last}=", eval(arg2))
  end
  
end

Then /^the game property "([^"]*)" should not be nil$/ do |property_string|
  invoke_property_string_on(@game, property_string).should_not be_nil
end


Then /^the game property "([^"]*)" should be approximately "([^"]*)"$/ do |property_string, expected|
  invoke_property_string_on(@game, property_string).should be_near(expected.to_f)
end



Then /^the active event area action should be "([^"]*)"$/ do |arg1|
  @game.level.active_event_areas.first.action.should == arg1
end

Then /^the active event area action argument should be "([^"]*)"$/ do |arg1|
  @game.level.active_event_areas.first.action_argument.should == arg1
end


Then /^the event area info window images size should be "([^"]*)"$/ do |arg1|
  @game.level.active_event_areas.first.info_window.images.size.should == arg1.to_i
end

When /^I stub the last saved time for slot (\d+) to be "([^"]*)"$/ do |arg1, arg2|
  # @game.stubs(:last_save_time_current).returns eval(arg2)
  t = eval(arg2)
  Dir.stubs(:exists?).with("test-data/loads/#{arg1}").returns(!t.nil?)
  File.stubs(:mtime).with("test-data/loads/#{arg1}/savedata.yml").returns t
  
  #@game.stubs(:last_save_time_for_slot).with(arg1.to_i).returns eval(arg2)
end

Given /^I create a valid game$/ do
  @game = YamlLoader.game_from_file("test-data/valid.yml")
end


When /^I unset the game property "([^"]*)"$/ do |arg1|
  @game.send("#{arg1}=", nil)
end


Then /^the game should be valid$/ do
  @game.valid?.should be(ValidationHelper::Validation::VALID)
end
Then /^the game should not be valid$/ do
  @game.valid?.should_not be(ValidationHelper::Validation::VALID)
end


When /^we reset the player to "([^"]*)" and load the level "([^"]*)"$/ do |reset_player, level|
  orig = @game.player_reset
  @game.player_reset = "test-data/players/#{reset_player}.yml"
  mock_arg = Mocha::Mock.new("arg holder mock")
  mock_arg.stubs(:argument).returns("test-data/levels/#{level}/#{level}.yml")
  @game.action_controller.invoke(BehaviorTypes::RESET_PLAYER_AND_LOAD_LEVEL, mock_arg)
end


When /^we upgrade the player with animation config$/ do
  conf = {
      "animation_file" => "test-data/sprites/enemy1gd.png",
      "animation_width" => 50,
      "animation_height" => 50,
      "animation_rate" => 5
  }
  mock_arg = Mocha::Mock.new("arg holder mock")
  mock_arg.stubs(:argument).returns(conf)

  @game.action_controller.invoke(BehaviorTypes::UPGRADE_PLAYER, mock_arg)
end

When /^I set the player level progress rank to (\d+)$/ do |arg1|
  @game.player.progression.level_background_rank = arg1.to_i
end