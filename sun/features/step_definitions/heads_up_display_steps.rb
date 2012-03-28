
Given /^I create the HUD$/ do
  @hud = HeadsUpDisplay.new(@game)
  @game.hud = @hud
end

Given /^I set the HUD text to:$/ do |text|
  text.each_line {|line| @hud.add_line(line.to_s.strip)}
end

Then /^the hud should contain:$/ do | table|
  @hud.lines.should == table.rows.flatten
end
