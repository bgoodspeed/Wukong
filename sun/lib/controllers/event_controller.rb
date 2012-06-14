
# Copyright 2012 Ben Goodspeed
module EventTypes
  LAMBDA = "LAMBDA"
  PICK = "PICK"
  SPAWN = "SPAWN"
  DEATH = "DEATH"
  START_NEW_GAME = "START_NEW_GAME"
  LOAD_GAME = "LOAD_GAME"
  SAVE_GAME = "SAVE_GAME"
  LOAD_LEVEL = "LOAD_LEVEL"
  BACK_TO_LEVEL = "BACK_TO_LEVEL"
  HACK_PUZZLE_AMEND = "hack_puzzle_amend"
end
# Copyright 2012 Ben Goodspeed
class Event
  attr_reader :argument, :event_type
  def initialize(argument, event_type)
    @argument, @event_type = argument, event_type
  end

  def to_s
    "Event:#{event_type} arg(#{argument})"
  end
end
# Copyright 2012 Ben Goodspeed
class EventController
  attr_accessor :events
  def initialize(game)
    @game = game
    @events = []

  end

  def handlers
    @game.action_controller.event_actions
  end
  def handler_for(ec)
    @game.action_controller.event_actions[ec]
  end
  def add_event(e)
    @events << e
  end
  def handle_events
    @handled = []
    @events.each{|event|
      raise "unknown event type: #{event}" unless handlers.has_key? event.event_type
      handler_for(event.event_type).call(@game, event)
      @handled << event
    }

    @events = @events - @handled
  end
end
