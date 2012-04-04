Given /^I set the player weapon with image "([^"]*)"$/ do |weapon_image|
  @weapon = Weapon.new(@game, "test-data/equipment/#{weapon_image}")
  @player.equip_weapon @weapon
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

Then /^the weapon should be in use and on frame (\d+)$/ do |frame|
  @player.weapon.should be_in_use
  @animation_manager.animation_index_by_entity_and_name(@player, "weapon").animation_index.should == frame.to_i
end

Given /^I set the player weapon sound effect to "([^"]*)"$/ do |sound_file|
  @sound_manager.add_effect("test-data/sounds/#{sound_file}", "player_weapon_sound")
  @weapon.sound_effect_name = "player_weapon_sound"
end

Then /^the weapon sound should be played$/ do
  @sound_manager.play_count_for(@game.player.weapon.sound_effect_name).should == 1
end

