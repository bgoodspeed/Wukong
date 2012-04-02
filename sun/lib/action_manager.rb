# To change this template, choose Tools | Templates
# and open the template in the editor.

class ActionManager
  def self.default_menu_actions

    {
      "debug_print" => lambda {|arg| puts "DEBUG_PRINT: #{arg}"},
      "noop" => lambda {|arg| }
    }
  end


  #TODO unify these interfaces
  attr_reader :collision_responses, :menu_actions, :event_actions
  def initialize(game)
    @game = game
    @collision_responses = {
      :damaging1 => lambda {|col| col.dynamic1.take_damage(col.dynamic2)},
      :damaging2 => lambda {|col| col.dynamic2.take_damage(col.dynamic1)},
      :removing1 => lambda {|col| @game.remove_projectile(col.dynamic1)},
      :removing2 => lambda {|col| @game.remove_projectile(col.dynamic2)},
      :blocking1 => lambda {|col| col.dynamic1.undo_last_move},
      :blocking2 => lambda {|col| col.dynamic2.undo_last_move},
      :trigger_event1 => lambda {|col| col.dynamic1.trigger},
      :trigger_event2 => lambda {|col| col.dynamic2.trigger},
      :mouse_pick1 => lambda {|col|
        @game.remove_mouse_collision #TODO could also add a timed event here add a highlight around that enemy?
        @game.add_event(PickEvent.new(@game, col.dynamic1))},
      #TODO sort of exploratory here, extract params, cleanup etc
      :temporary_message1 => lambda {|col| @game.clock.enqueue_event("message", TimedEvent.new("temporary_message=", col.dynamic1.hud_message,"temporary_message=", nil, 60 )) }
    }
    @menu_actions = ActionManager.default_menu_actions
        #TODO not sure if this should be here or in the events themselves
    @event_actions = {
      #TODO make death event map to this?
      DeathEvent => lambda {|e| @game.remove_enemy(e.who)},
      LambdaEvent => lambda {|e| e.invoke },
      PickEvent => lambda {|e| puts "In Event Manager: must implement what to do when #{e.picked}"}
    }

  end

end
