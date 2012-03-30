Given /^I set the game clock to (\d+) fps$/ do |framerate|
  @clock = Clock.new(@game, framerate.to_i)
  @game.clock = @clock
end



When /^I run the game loop (\d+) times$/ do |loops|
  loops.to_i.times do
    @game.simulate
  end
end

Then /^the elapsed clock time should be between (\d+) and (\d+) milliseconds$/ do |min, max|
  time = @clock.total_elapsed_time_ms
  time.should be >= min.to_i
  time.should be <= max.to_i
end


Then /^the number of frames render should be (\d+)$/ do |frames|
  @clock.frames_rendered.should == frames.to_i
end

Given /^I enqueue a timed event named "([^"]*)" and action "([^"]*)" data "([^"]*)" for (\d+) ticks$/ do |event_name, action, data, lifespan|
  @timed_event = TimedEvent.new(action, data, lifespan.to_i)

  @clock.enqueue_event(event_name, @timed_event)
end
