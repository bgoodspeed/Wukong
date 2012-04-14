# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'mocha'
def map_test_key_name_to_real_key_name(key)
  key #TODO
end
Given /^I create an input controller from config file "([^"]*)"$/ do |config|
  @input_controller = YamlLoader.from_file(InputController, @game, "test-data/input/#{config}")
  @game.input_controller = @input_controller
end


When /^I press "([^"]*)"$/ do |key|
  @game.input_controller.set_key_to_active(map_test_key_name_to_real_key_name(key))
end


Then /^the following keys should be active: "([^"]*)"$/ do |csv_keys|
  keys = csv_keys.split(",")

  missing_keys = keys.select { |key| !@game.input_controller.active_keys.include? key }
  msg = "Found #{missing_keys} missing keys"
  msg.should == "Found [] missing keys"
end

When /^I update the game state$/ do
  @game.update_game_state
end

#TODO redesign this input mocking mechanism
When /^I run the game loop (\d+) times and clear the state after run (\d+)$/ do |total_loops, input_loops|
  total_loops.to_i.times do |idx|
    if idx == input_loops.to_i
      #@game.stubs(:button_down?).returns false
    end
    @game.simulate
  end

end

#TODO redesign this input mocking mechanism, kills things on win32
When /^I simulate "([^"]*)"$/ do |gosu_buttons|
  values = gosu_buttons.split(",").collect {|button| eval(button)}
  @game.input_controller.stubs(:button_down?).returns false
  values.each {|value| @game.input_controller.stubs(:button_down?).with(value).returns true }

end

When /^I update the key state$/ do
  @game.input_controller.update_key_state
end

Then /^the player weapon should be in use$/ do
  @game.should be_weapon_in_use
end

Then /^the game should call quit$/ do
  @game.should_not be_active
end


Then /^the input controllers mapping should contain:$/ do |table|
  conf = @input_controller.keyboard
  table.hashes.each {|hash|
    k = eval(hash['api_keysym']).to_i
    expected = eval(hash['keyaction'])
    conf[k].should be(expected), "Expected key #{k} -> #{conf[k]} to match #{expected} among #{conf}#"
  }
end
