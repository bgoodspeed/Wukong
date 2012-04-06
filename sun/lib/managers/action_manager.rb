

#TODO how to make this configurable? maybe not needed since input->action is configurable
class ActionManager
  def default_menu_actions
    {
      "debug_print" => lambda {|arg| puts "DEBUG_PRINT: #{arg}"},
      "noop" => lambda {|arg| }
    }
  end
  def default_collision_responses
    {
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
        @game.add_event(Event.new(col.dynamic1, EventTypes::PICK))},
      #TODO sort of exploratory here, extract params, cleanup etc
      :temporary_message1 => lambda {|col| @game.clock.enqueue_event("message", TimedEvent.new("temporary_message=", col.dynamic1.hud_message,"temporary_message=", nil, 60 )) }
    }
  end

  def default_event_actions
    {
      #TODO not sure if this should be here or in the events themselves
      EventTypes::DEATH => lambda {|e|
        #TODO untested
        @game.player.enemy_killed
        @game.remove_enemy(e.argument)},
      EventTypes::LAMBDA => lambda {|e| e.invoke },
      EventTypes::PICK => lambda {|e| puts "In Action Manager: must implement what to do when #{e.picked}"},
      EventTypes::SPAWN => lambda {|e| @game.add_enemy(e.argument)}
    }
  end

  #TODO unify these APIs, all lambdas should take game, arg
  def default_always_available_behaviors
    {
      KeyActions::QUIT => lambda { @game.deactivate_and_quit },
      "queue_start_new_game_event" => lambda {|game, arg| game.add_event(Event.new(nil, EventTypes::START_NEW_GAME))},
      #TODO figure out which game to load from menu?
      "queue_load_game_event" => lambda {|game, arg| game.add_event(Event.new(nil, EventTypes::LOAD_GAME))}
     
    }
  end

  #TODO this is how you can limit repeat rates of keys, might need to do same for mouse clicks etc
  def introduce_delay(action, delay)
    te = TimedEvent.new("disable_action", action, "enable_action", action, delay)
    @game.clock.enqueue_event("timeout_down", te)
  end
  def default_menu_behaviors
    {
      KeyActions::MENU => lambda {
        introduce_delay(KeyActions::MENU, @game.player.menu_action_delay)
        @game.exit_menu
      },
      KeyActions::DOWN => lambda {
        introduce_delay(KeyActions::DOWN, @game.player.menu_action_delay)
        @game.menu_manager.move_down
      },
      KeyActions::MENU_ENTER => lambda {
        introduce_delay(KeyActions::MENU_ENTER, @game.player.menu_action_delay)
        @game.menu_manager.invoke_current
      },
      KeyActions::MOUSE_CLICK => lambda {
        introduce_delay(KeyActions::MOUSE_CLICK, @game.player.menu_action_delay)
        @game.menu_manager.invoke_current_mouse
      },
    }
  end
  def default_gameplay_behaviors
    {
      KeyActions::INTERACT => lambda {
        introduce_delay(KeyActions::MENU, @game.player.menu_action_delay)
        @game.interact
      }, 
      KeyActions::MENU => lambda {
        introduce_delay(KeyActions::MENU, @game.player.menu_action_delay)
        @game.enter_menu
      },
      KeyActions::RIGHT => lambda { @game.player.turn(@game.turn_speed) },
      KeyActions::LEFT => lambda { @game.player.turn(-@game.turn_speed) },
      KeyActions::UP => lambda { @game.player.move_forward(@game.movement_distance) },
      KeyActions::DOWN => lambda { @game.player.move_forward(-@game.movement_distance) },
      KeyActions::FIRE => lambda { @game.player.use_weapon },
      KeyActions::MOUSE_CLICK => lambda {
        introduce_delay(KeyActions::MOUSE_CLICK, @game.player.menu_action_delay)
        @game.pick_game_element
      }
    }
  end


  #TODO unify these interfaces?
  attr_reader :collision_responses, :menu_actions, :event_actions, 
    :always_available_behaviors, :gameplay_behaviors, :menu_behaviors
  
  def initialize(game)
    @game = game
    @collision_responses = default_collision_responses
    @menu_actions = default_menu_actions
    @event_actions = default_event_actions
    @always_available_behaviors = default_always_available_behaviors
    @gameplay_behaviors = default_gameplay_behaviors
    @menu_behaviors = default_menu_behaviors
  end

  def all_responses
    @collision_responses.merge(@menu_actions).merge(@event_actions).merge(@always_available_behaviors).merge(@gameplay_behaviors).merge(@menu_behaviors)
  end

  def invoke(action_name, arg=nil)
    rs = all_responses
    raise "unknown action #{action_name}" unless rs.has_key?(action_name)
    rs[action_name].call(@game, arg )
  end
end
