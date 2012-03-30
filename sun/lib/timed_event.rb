# To change this template, choose Tools | Templates
# and open the template in the editor.

class TimedEvent
  attr_accessor :data, :lifespan, :enqueued_at
  def initialize(action, data, lifespan)
    @action = action
    @data = data
    @lifespan = lifespan
    @enqueued_at = nil
  end

  def enqueued(t, game)
    @enqueued_at = t
    raise "timed event: unknown action #{@action}" unless game.respond_to? @action
    game.send(@action, @data)
  end

  def tick
    #TODO?
  end

  #TODO these calls should be specified differently
  def completed(game)
    game.send(@action, nil)
  end

  
end
