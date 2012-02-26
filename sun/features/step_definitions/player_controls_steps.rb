# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'mocha'
def map_test_key_name_to_real_key_name(key)
  key #TODO
end

When /^I press "([^"]*)"$/ do |key|
  @game.set_key_to_active(map_test_key_name_to_real_key_name(key))
end


Then /^the following keys should be active: "([^"]*)"$/ do |csv_keys|
  keys = csv_keys.split(",")

  missing_keys = keys.select { |key| !@game.active_keys.include? key }
  msg = "Found #{missing_keys} missing keys"
  msg.should == "Found [] missing keys"
end

When /^I update the game state$/ do
  @game.update_game_state
end

When /^I simulate "([^"]*)"$/ do |gosu_buttons|
  values = gosu_buttons.split(",").collect {|button| eval(button)}
  @game.stubs(:button_down?).returns false
  values.each {|value| @game.stubs(:button_down?).with(value).returns true }

end

When /^I update the key state$/ do
  @game.update_key_state
end
