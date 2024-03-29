# To change this template, choose Tools | Templates
# and open the template in the editor.
# Copyright 2012 Ben Goodspeed
class Clock
  attr_accessor :throttle
  attr_reader :frames_rendered, :events, :last_save_time, :target_framerate
  def initialize(game, framerate, throttle=false)
    @game = game
    @target_framerate = framerate
    @last_save_time = nil
    @target_frame_time = (1.0/@target_framerate.to_f)*1000.0
    @throttle = throttle
    reset
  end
  def set_last_save_time
    @last_save_time = @last_time
  end
  def reset
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
