# To change this template, choose Tools | Templates
# and open the template in the editor.

class EventManager
  attr_accessor :events
  def initialize(game)
    @game = game
    @events = []

    @disabled = {}
    #TODO not sure if this should be here or in the events themselves
    @handlers = {
      #TODO make death event map to this?
      DeathEvent => lambda {|e| @game.remove_enemy(e.who)},
      LambdaEvent => lambda {|e| e.invoke }
    }
  end



  def add_event(e)
    @events << e
  end
  def handle_events
    @events.each{|event|
      raise "unknown event type: #{event}" unless @handlers.has_key? event.class
      @handlers[event.class].call(event)
    }
  end
  def enable_action(action)
    @disabled[action] = false
  end
  def disable_action(action)
    @disabled[action] = true
  end

  def event_enabled?(action)
    !@disabled[action]
  end
end
