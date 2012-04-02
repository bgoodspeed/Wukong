# To change this template, choose Tools | Templates
# and open the template in the editor.

class EventManager
  attr_accessor :events
  def initialize(game)
    @game = game
    @events = []

    #TODO not sure if this should be here or in the events themselves
    @handlers = {
      #TODO make death event map to this?
      DeathEvent => lambda {|e| @game.remove_enemy(e.who)},
      LambdaEvent => lambda {|e| e.invoke },
      PickEvent => lambda {|e| puts "In Event Manager: must implement what to do when #{e.picked}"}
    }
  end



  def add_event(e)
    @events << e
  end
  def handle_events
    @handled = []
    @events.each{|event|
      raise "unknown event type: #{event}" unless @handlers.has_key? event.class
      @handlers[event.class].call(event)
      @handled << event
    }

    @events = @events - @handled

  end
end
