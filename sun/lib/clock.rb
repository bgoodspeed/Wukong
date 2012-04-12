# To change this template, choose Tools | Templates
# and open the template in the editor.

class Clock
  attr_accessor :throttle
  attr_reader :frames_rendered, :events
  def initialize(game, framerate)
    @game = game
    @target_framerate = framerate
    @target_frame_time = (1.0/@target_framerate.to_f)*1000.0
    @throttle = true
    @start_time = @last_time = Graphics::milliseconds
    @frames_rendered = 0
    @events = {}
  end
  def current_tick
    @frames_rendered
  end
  def tick
    @frames_rendered += 1
    @last_time = Graphics::milliseconds
    to_rm = []
    @events.each {|name, event|
      if @frames_rendered > (event.enqueued_at + event.lifespan)
        event.completed(@game)
        to_rm << name
      else
        event.tick
      end
    }
    @events.reject!{|k,v| to_rm.include?(k)}
  end
  def current_frame_too_fast?
    @throttle && (elapsed_time_ms < @target_frame_time)
  end
  def elapsed_time_ms
    Graphics::milliseconds - @last_time
  end
  def total_elapsed_time_ms
    Graphics::milliseconds - @start_time
  end

  def enqueue_event(event_name, timed_event)
    timed_event.enqueued @frames_rendered, @game
    @events[event_name] = timed_event
  end
end
