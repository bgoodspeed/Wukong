
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

Then /^the event area info window position should be nil$/ do 
  @game.level.active_event_areas.first.info_window.position.should be_nil
end
Then /^the event area info window position should be "([^"]*)"$/ do |arg1|
  @game.level.active_event_areas.first.info_window.position.should be_within_epsilon_of(eval(arg1))
end

def valid_info_window_conf
  {
      'description' => 'fake info window description'
  }
end
Given /^I create a valid info window$/ do
  @info_window = InfoWindow.new(valid_info_window_conf)
end


Then /^the info window should be valid$/ do
  @info_window.should be_valid
end
