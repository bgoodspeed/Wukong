
Given /^I create a new AI Strategy called "([^"]*)":$/ do |name, yaml_text|
  @ai = ArtificialIntelligence.from_yaml(yaml_text)
end
When /^the event "([^"]*)" occurs$/ do |event|
  @ai.trigger_event(event)
end

Then /^the current state is "([^"]*)"$/ do |state|
  @ai.current_state.to_s.should == state
end

Then /^the start state is "([^"]*)"$/ do |state_name|
  @ai.start_state
end
Then /^attempting an event "([^"]*)" generates an error and stay in state "([^"]*)"$/ do |event, state|
  begin
    @ai.trigger_event(event)
    "The event trigger should have exploded".should == "But it did not"
  rescue Exception => e
    @ai.current_state.to_s.should == state
  end
end