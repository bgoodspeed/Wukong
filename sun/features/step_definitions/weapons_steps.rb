Given /^I set the player weapon with image "([^"]*)"$/ do |weapon_image|
  @weapon = Weapon.new(@game, "test-data/equipment/#{weapon_image}")
  @player.weapon = @weapon
end

Given /^I set the player weapon start to \-(\d+)$/ do |st|
  @weapon.swing_start = st.to_i
end

Given /^I set the player weapon sweep to (\d+)$/ do |sw|
  @weapon.swing_start = sw.to_i
end

Given /^I set the player weapon frames to (\d+)$/ do |fr|
  @weapon.swing_frames = fr.to_i
end

When /^I use the weapon$/ do
  @weapon.use
end

Then /^the weapon should be in use and on frame (\d+)$/ do |frame|
  @weapon.should be_in_use
  @weapon.frame.should == frame.to_i
end
