# To change this template, choose Tools | Templates
# and open the template in the editor.

class EventManager
  attr_accessor :events
  def initialize(game)
    @game = game
    @events = []

  end

  def handlers
    @game.action_manager.event_actions
  end
  def handler_for(ec)
    @game.action_manager.event_actions[ec]
  end
  def add_event(e)
    @events << e
  end
  def handle_events
    @handled = []
    @events.each{|event|
      raise "unknown event type: #{event}" unless handlers.has_key? event.class
      handler_for(event.class).call(event)
      @handled << event
    }

    @events = @events - @handled

  end
end
