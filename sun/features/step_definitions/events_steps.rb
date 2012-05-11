Given /^I create an event emitter to play the "([^"]*)" sound$/ do |sound_name|
  c = Primitives::Circle.new([0,0],0)
  @event_emitter = EventEmitter.new(@game, c, "play_sound", sound_name)
end

When /^I trigger the event emitter$/ do
  @event_emitter.trigger
end

When /^handle events$/ do
  @game.event_controller.handle_events
end

def valid_event_area_conf
  {
      'rect' => "LIESRECTANGLES",
      'action' => 'fakeaction',
      'action_argument' => 'fakeactionargument',
      'label' => 'fakelabel',
      'info_window' => {

      }
  }
end
Given /^I create a valid event area$/ do
  @event_area = EventArea.new(nil, valid_event_area_conf)
end


Then /^the event area should be valid$/ do
  @event_area.should be_valid
end


When /^I unset the event area property "([^"]*)"$/ do |prop|
  @last_property = prop
  @event_area.send("#{prop}=", nil)
end


Then /^the event area should not be valid$/ do
  @event_area.should_not be_valid, "Expected event area property #{@last_property} to be mandatory"
end