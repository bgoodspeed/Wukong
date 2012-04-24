Given /^I set the player weapon with image "([^"]*)"$/ do |weapon_image|
  n = "test-data/equipment/#{weapon_image}"
  @weapon = Weapon.new(@game, n)
  @game.inventory_controller.register_item(n, @weapon)
  
  @player.equip_weapon @game.inventory_controller.item_named(n)
end
Given /^I load and equip the weapon defined in "([^"]*)"$/ do |yml_file|
  @weapon = YamlLoader.from_file(Weapon, @game, "test-data/equipment/#{yml_file}")
  @player.equip_weapon @weapon
end

Given /^I set the player weapon start to \-(\d+)$/ do |st|
  @weapon.swing_start = st.to_i
end

Given /^I set the player weapon sweep to (\d+)$/ do |sw|
  @weapon.swing_start = sw.to_i
end
Given /^I set the player weapon type to "([^"]*)"$/ do |weapon_type|
  @weapon.type = weapon_type
end

When /^I use the weapon$/ do
  @player.use_weapon
end

Then /^the weapon should not be in use$/ do
  @player.weapon_in_use?.should == false
end



Then /^the weapon should be in use and on frame (\d+)$/ do |frame|
  @player.weapon_in_use?.should == true
  @animation_controller.animation_index_by_entity_and_name(@player, "weapon").animation_index.should == frame.to_i
end

Given /^I set the player weapon sound effect to "([^"]*)"$/ do |sound_file|
  @sound_controller.add_effect("test-data/sounds/#{sound_file}", "player_weapon_sound")
  @weapon.sound_effect_name = "player_weapon_sound"
end

Then /^the weapon sound should be played$/ do
  @sound_controller.play_count_for(@game.player.inventory.weapon.sound_effect_name).should == 1
end

