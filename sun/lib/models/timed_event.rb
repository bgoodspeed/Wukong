# To change this template, choose Tools | Templates
# and open the template in the editor.

class TimedEvent
  attr_accessor :data, :lifespan, :enqueued_at, :start_action
  def initialize(start_action, start_data, end_action, end_data, lifespan)
    @start_action = start_action
    @end_action = end_action
    @start_data = start_data
    @end_data = end_data
    @lifespan = lifespan
    @enqueued_at = nil
  end

  def enqueued(t, game)
    @enqueued_at = t
    raise "timed event: unknown start action  #{@start_action} rest of #{@end_action}conf#{@start_data} #{@end_data}" unless game.respond_to? @start_action
    game.send(@start_action, @start_data)
  end

  def tick
    #TODO?
  end

  def completed(game)
    game.send(@end_action, @end_data)

  end

  
end
