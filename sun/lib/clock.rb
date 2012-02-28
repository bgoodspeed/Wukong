# To change this template, choose Tools | Templates
# and open the template in the editor.

class Clock
  attr_reader :frames_rendered
  def initialize(framerate)
    @target_framerate = framerate
    @target_frame_time = (1.0/@target_framerate.to_f)*1000.0

    @start_time = @last_time = Gosu::milliseconds
    @frames_rendered = 0
  end

  def tick
    @frames_rendered += 1
    @last_time = Gosu::milliseconds
  end
  def current_frame_too_fast?
    elapsed_time_ms < @target_frame_time
  end
  def elapsed_time_ms
    Gosu::milliseconds - @last_time
  end
  def total_elapsed_time_ms
    Gosu::milliseconds - @start_time
  end
end
