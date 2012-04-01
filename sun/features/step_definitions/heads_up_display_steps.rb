
Given /^I create the HUD$/ do
  @hud = HeadsUpDisplay.new(@game)
  @game.hud = @hud
end
Given /^I create the HUD from file "([^"]*)"$/ do |file|
  @hud = HeadsUpDisplay.from_file(@game, "test-data/hud/#{file}")
  @game.hud = @hud
end

Given /^I set the HUD text to:$/ do |text|
  text.each_line {|line| @hud.add_line(line.to_s.strip)}
end

Then /^the hud should contain:$/ do | table|
  @hud.lines.should == table.rows.flatten
end

Then /^the hud should be in menu mode$/ do
  @hud.should be_menu_mode
end

Then /^the hud cursor position should be (\d+),(\d+)$/ do |arg1, arg2|
  expected = [arg1.to_f, arg2.to_f]
  @hud.cursor_position.should be_within_epsilon_of(expected)
end

Then /^the hud formatted line (\d+) should be "([^"]*)"$/ do |lineno, arg2|
  lines = @hud.formatted_lines
  lines[lineno.to_i - 1].should == arg2

end

Then /^there should be (\d+) regions to check the mouse against$/ do |arg1|
  @hud.regions.size.should == arg1.to_i
end
Then /^highlighted region should be line (\d+)$/ do |arg1|
  @hud.highlighted_regions.first.should == arg1.to_i
end
