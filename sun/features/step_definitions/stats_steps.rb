Given /^I create a stats object$/ do
  @stats = Stats.new(nil, {})
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


Then /^the stats should have accuracy (\d+)$/ do |arg1|
  @stats.accuracy.should == arg1.to_i
end