Given /^I set the player weapon with image "([^"]*)"$/ do |weapon_image|
  @weapon = Weapon.new(@game, "test-data/equipment/#{weapon_image}")
  @player.equip_weapon @weapon
end



Given /^I set the player weapon start to \-(\d+)$/ do |st|
  @weapon.swing_start = st.to_i
end

Given /^I set the player weapon sweep to (\d+)$/ do |sw|
  @weapon.swing_start = sw.to_i
end


When /^I use the weapon$/ do
  @player.use_weapon
end

Then /^the weapon should be in use and on frame (\d+)$/ do |frame|
  @weapon.should be_in_use
  @animation_manager.animation_index_by_entity_and_name(@player, "weapon").animation_index.should == frame.to_i
end


