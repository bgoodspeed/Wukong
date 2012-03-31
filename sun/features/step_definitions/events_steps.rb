Given /^I create an event emitter to play the "([^"]*)" sound$/ do |sound_name|
  c = Primitives::Circle.new([0,0],0)
  @event_emitter = EventEmitter.new(@game, c, "play_sound", sound_name)
end

When /^I trigger the event emitter$/ do
  @event_emitter.trigger
end

When /^handle events$/ do
  @game.event_manager.handle_events
end
