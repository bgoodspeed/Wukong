Given /^I create a stats object$/ do
  @stats = Stats.new({})
end


Then /^the stats should have strength (\d+)$/ do |arg1|
  @stats.strength.should == arg1.to_i
end


Then /^the stats should have defense (\d+)$/ do |arg1|
  @stats.defense.should == arg1.to_i
end



Then /^the stats should have health (\d+)$/ do |arg1|
  @stats.health.should == arg1.to_i
end


Then /^the stats should have max health (\d+)$/ do |arg1|
  @stats.max_health.should == arg1.to_i
end

Then /^the stats should have speed (\d+)$/ do |arg1|
  @stats.speed.should == arg1.to_i
end
Given /^I create a stats object called "([^"]*)"$/ do |arg1|
  @all_stats ||= {}
  @all_stats[arg1] = Stats.new({})
end

Then /^the stats should have accuracy (\d+)$/ do |arg1|
  @stats.accuracy.should == arg1.to_i
end

When /^stats "([^"]*)" and "([^"]*)" are added$/ do |arg1, arg2|
  @result_stats = @all_stats[arg1].plus_stats(@all_stats[arg2])
end


Then /^the stats result should have property "([^"]*)" equal to "([^"]*)"$/ do |arg1, arg2|
  @result_stats.send(arg1).should == arg2.to_i
end


Then /^the player stats should have property "([^"]*)" equal to "([^"]*)"$/ do |arg1, arg2|
  @game.player.stats.send(arg1).should == arg2.to_i
end


Then /^the equipment stats should have property "([^"]*)" equal to "([^"]*)"$/ do |arg1, arg2|
  @game.player.inventory.equipped_stats.send(arg1).should == arg2.to_i
end


Then /^the effective player stats should have property "([^"]*)" equal to "([^"]*)"$/ do |arg1, arg2|
  @game.player.effective_stats.send(arg1).should == arg2.to_i
end
