

module EventTypes
  LAMBDA = "LAMBDA"
  PICK = "PICK"
  SPAWN = "SPAWN"
  DEATH = "DEATH"
  START_NEW_GAME = "START_NEW_GAME"
  LOAD_GAME = "LOAD_GAME"
end

class Event
  attr_reader :argument, :event_type
  def initialize(argument, event_type)
    @argument, @event_type = argument, event_type
  end

  def to_s
    "Event:#{event_type} arg(#{argument})"
  end
end

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
      raise "unknown event type: #{event}" unless handlers.has_key? event.event_type
      handler_for(event.event_type).call(event)
      @handled << event
    }

    @events = @events - @handled
  end
end
