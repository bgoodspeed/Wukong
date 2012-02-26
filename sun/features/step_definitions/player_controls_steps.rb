# To change this template, choose Tools | Templates
# and open the template in the editor.

def map_test_key_name_to_real_key_name(key)
  key #TODO
end

When /^I press "([^"]*)"$/ do |key|
  @game.set_key_to_active(map_test_key_name_to_real_key_name(key))
end

When /^I update the game$/ do
  @game.update
end

Then /^the following keys should be active: "([^"]*)"$/ do |csv_keys|
  keys = csv_keys.split(",")

  missing_keys = keys.select { |key| !@game.active_keys.include? key }
  msg = "Found #{missing_keys} missing keys"
  msg.should == "Found [] missing keys"
end

