Given /^I create an event emitter to play the "([^"]*)" sound$/ do |sound_name|
  c = Primitives::Circle.new(GVector.xy(0,0),0)
  conf = {
      'collision_primitive' => c,
      'event_name' => "play_sound",
      'event_argument' => sound_name

  }
  @event_emitter = EventEmitter.new(@game, conf)
end

When /^I trigger the event emitter$/ do
  @event_emitter.trigger
end

When /^handle events$/ do
  @game.event_controller.handle_events
end

def valid_event_area_conf
  {
      'rect' => Primitives::Rectangle.new(GVector.xy(0,0), GVector.xy(0,1), GVector.xy(1,1), GVector.xy(1,0)),
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
  @event_area.valid?.should be(ValidationHelper::Validation::VALID)
end


When /^I unset the event area property "([^"]*)"$/ do |prop|
  @last_property = prop
  @event_area.send("#{prop}=", nil)
end


Then /^the event area should not be valid$/ do
  @event_area.valid?.should_not be(ValidationHelper::Validation::VALID), "Expected event emitter property #{@last_property} to be mandatory"
end

def valid_event_emitter_conf
  {
      'event_name' => 'play_sound',
      'event_argument' => "fakenotneededeventarg",
      'collision_primitive' => Primitives::Circle.new(GVector.xy(0,0),0)
  }
end

Given /^I create a valid event emitter$/ do
  @event_emitter = EventEmitter.new(nil, valid_event_emitter_conf)
end


Then /^the event emitter should be valid$/ do
  @event_emitter.valid?.should be(ValidationHelper::Validation::VALID)
end


When /^I unset the event emitter property "([^"]*)"$/ do |prop|
  @last_property = prop
  @event_emitter.send("#{prop}=", nil)
end


Then /^the event emitter should not be valid$/ do
  @event_emitter.valid?.should_not be(ValidationHelper::Validation::VALID)
end