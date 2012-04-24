
Then /^there should be (\d+) active event areas$/ do |n|
  @game.level.active_event_areas.size.should == n.to_i
end

Then /^the event area info window description should be "([^"]*)"$/ do |arg1|
  @game.level.active_event_areas.first.info_window.description.should == arg1
end

Then /^the event area info window description should contain "([^"]*)"$/ do |arg1|
  descs = @game.level.active_event_areas.first.info_window.description.select{|d| d =~ Regexp.new(arg1)}
  descs.should_not be_empty
end