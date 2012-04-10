
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
  Graphics::Font.stubs(:new).returns(stub_font)
  Graphics::Image.stubs(:new).returns(stub_image)
  Graphics::Image.stubs(:load_tiles).returns(stub_image)
  Graphics::Sample.stubs(:new).returns(stub_sample)
  Graphics::Song.stubs(:new).returns(stub_song)
end

Given /^I use the game named "([^"]*)"$/ do |arg1|
  @game = lookup_game_named("test-data/#{arg1}.yml")
end

Given /^I load the game on level "([^"]*)" with screen size (\d+), (\d+)$/ do |level_to_load, width, height|
  #stub_out_gosu

  @game = Game.new({:width => width.to_i, :height => height.to_i})
  @level = @game.load_level("test-data/levels/#{level_to_load}/#{level_to_load}.yml")
end
Given /^I load the game "([^"]*)"$/ do |arg1|
  #stub_out_gosu
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

Then /^I load slot (\d+)$/ do |arg1|
  @game.load_game_slot(arg1.to_i)
end
