Given /^I set the game clock to (\d+) fps$/ do |framerate|
  @clock = Clock.new(@game, framerate.to_i)
  @game.clock = @clock
end

#TODO speed this up and reinstate 60fps

When /^I run the game loop (\d+) times$/ do |loops|
  loops.to_i.times do
    @game.simulate
  end
end


def clock
  @game.clock
end
Then /^the elapsed clock time should be between (\d+) and (\d+) milliseconds$/ do |min, max|
  time = clock.total_elapsed_time_ms
  time.should be >= min.to_i
  time.should be <= max.to_i
end


Then /^the number of frames render should be (\d+)$/ do |frames|
  @clock.frames_rendered.should == frames.to_i
end

Given /^I enqueue a timed event named "([^"]*)" and action "([^"]*)" data "([^"]*)" for (\d+) ticks$/ do |event_name, action, data, lifespan|
  @timed_event = TimedEvent.new(action, data, action, nil, lifespan.to_i)

  @clock.enqueue_event(event_name, @timed_event)
end

Given /^I enqueue a timed event with name "([^"]*)" and start_action "([^"]*)" and end_action "([^"]*)" and data "([^"]*)" for (\d+) ticks$/ do |name, startact, endact, data, ticks|
  @timed_event = TimedEvent.new(startact, data, endact, data, ticks.to_i)
  @clock.enqueue_event(name, @timed_event)
end

Given /^I reset the clock$/ do
  @game.clock.reset
end


Then /^the action "([^"]*)" should be disabled$/ do |arg1|
  @game.event_enabled?(arg1).should be_false
end

Then /^the action "([^"]*)" should be enabled$/ do |arg1|
  @game.event_enabled?(arg1).should be_true
end
Then /^a timed event should be queued$/ do 
  @game.clock.events.size.should be_>=(1)
end
