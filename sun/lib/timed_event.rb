# To change this template, choose Tools | Templates
# and open the template in the editor.

class TimedEvent
  attr_accessor :data, :lifespan, :enqueued_at, :start_action
  def initialize(action, data, lifespan)
    @action = action
    @end_action = action
    @data = data
    @lifespan = lifespan
    @enqueued_at = nil
    @start_action = nil
  end

  def enqueued(t, game)
    @enqueued_at = t
    raise "timed event: unknown action #{@action}" unless game.respond_to? @action
    if @start_action
      game.send(@start_action, @data)
    else
      game.send(@end_action, @data)
    end
  end

  def tick
    #TODO?
  end

  #TODO these calls should be specified differently
  def completed(game)
    if @start_action
      game.send(@end_action, @data)
    else
      game.send(@end_action, nil)
    end

  end

  
end
