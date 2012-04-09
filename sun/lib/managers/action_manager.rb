

#TODO how to make this configurable? maybe not needed since input->action is configurable

module BehaviorTypes
  QUEUE_NEW_GAME_EVENT = "queue_start_new_game_event"
  QUEUE_LOAD_GAME_EVENT = "queue_load_game_event"
  CHOOSE_GAME_MENU = "CHOOSE_GAME_MENU"
end

class ActionManager
  def default_menu_actions
    {
      "debug_print" => lambda {|game, arg| puts "DEBUG_PRINT: #{arg}"},
      "noop" => lambda {|game, arg| }
    }
  end
  def default_collision_responses
    {
      ResponseTypes::DAMAGING1 => lambda {|game, col| col.dynamic1.take_damage(col.dynamic2)},
      ResponseTypes::DAMAGING2 => lambda {|game, col| col.dynamic2.take_damage(col.dynamic1)},
      ResponseTypes::REMOVING1 => lambda {|game, col| game.remove_projectile(col.dynamic1)},
      ResponseTypes::REMOVING2 => lambda {|game, col| game.remove_projectile(col.dynamic2)},
      ResponseTypes::BLOCKING1 => lambda {|game, col| col.dynamic1.undo_last_move},
      ResponseTypes::BLOCKING2 => lambda {|game, col| col.dynamic2.undo_last_move},
      ResponseTypes::TRIGGER_EVENT1 => lambda {|game, col| col.dynamic1.trigger},
      ResponseTypes::TRIGGER_EVENT2 => lambda {|game, col| col.dynamic2.trigger},
      ResponseTypes::MOUSE_PICK1 => lambda {|game, col|
        @game.remove_mouse_collision #TODO could also add a timed event here add a highlight around that enemy?
        @game.add_event(Event.new(col.dynamic1, EventTypes::PICK))},
      ResponseTypes::TEMPORARY_MESSAGE1  => lambda {|game, col| game.clock.enqueue_event("message", TimedEvent.new("temporary_message=", col.dynamic1.hud_message,"temporary_message=", nil, 60 )) }
    }
  end

  def default_event_actions
    {
      #TODO not sure if this should be here or in the events themselves
      EventTypes::DEATH => lambda {|game,e|
        game.player.enemy_killed
        game.remove_enemy(e.argument)},
      EventTypes::LAMBDA => lambda {|game,e| e.invoke },
      EventTypes::START_NEW_GAME => lambda { |game, e| game.load_level(game.new_game_level)},
      EventTypes::PICK => lambda {|game,e| puts "In Action Manager: must implement what to do when #{e.picked}"},
      EventTypes::SPAWN => lambda {|game,e| game.add_enemy(e.argument)}
    }
  end

  #TODO unify these APIs, all lambdas should take game, arg
  def default_always_available_behaviors
    {
      KeyActions::QUIT => lambda {|game, arg| game.deactivate_and_quit },

      BehaviorTypes::QUEUE_NEW_GAME_EVENT => lambda {|game, arg| game.add_event(Event.new(nil, EventTypes::START_NEW_GAME))},
      #TODO figure out which game to load from menu?
      BehaviorTypes::QUEUE_LOAD_GAME_EVENT => lambda {|game, arg| game.enter_menu(game.menu_for_load_game) },
#      BehaviorTypes::CHOOSE_GAME_MENU => lambda {|game, arg| puts "todo activate a menu based on '#{arg}'"}
     
    }
  end

  #TODO this is how you can limit repeat rates of keys, might need to do same for mouse clicks etc
  def introduce_delay(game, action, delay)
    te = TimedEvent.new("disable_action", action, "enable_action", action, delay)
    game.clock.enqueue_event("timeout_down", te)
  end
  def default_menu_behaviors
    {
      KeyActions::MENU => lambda { |game, arg|
        introduce_delay(game, KeyActions::MENU, game.player.menu_action_delay)
        game.exit_menu
      },
      KeyActions::DOWN => lambda { |game, arg|
        introduce_delay(game, KeyActions::DOWN, game.player.menu_action_delay)
        game.menu_manager.move_down
      },
      KeyActions::MENU_ENTER => lambda { |game, arg|
        introduce_delay(game, KeyActions::MENU_ENTER, game.player.menu_action_delay)
        game.menu_manager.invoke_current
      },
      KeyActions::MOUSE_CLICK => lambda { |game, arg|
        introduce_delay(game, KeyActions::MOUSE_CLICK, game.player.menu_action_delay)
        game.menu_manager.invoke_current_mouse
      },
    }
  end
  def default_gameplay_behaviors
    {
      KeyActions::INTERACT => lambda { |game, arg|
        introduce_delay(game, KeyActions::MENU, game.player.menu_action_delay)
        game.interact
      }, 
      KeyActions::MENU => lambda { |game, arg|
        introduce_delay(game, KeyActions::MENU, game.player.menu_action_delay)
        game.enter_menu
      },
      KeyActions::RIGHT => lambda { |game, arg| game.player.turn(game.turn_speed) },
      KeyActions::LEFT => lambda { |game, arg| game.player.turn(-game.turn_speed) },
      KeyActions::UP => lambda { |game, arg| game.player.move_forward(game.movement_distance) },
      KeyActions::DOWN => lambda { |game, arg| game.player.move_forward(-game.movement_distance) },
      KeyActions::FIRE => lambda { |game, arg| game.player.use_weapon },
      KeyActions::MOUSE_CLICK => lambda { |game, arg|
        introduce_delay(game, KeyActions::MOUSE_CLICK, game.player.menu_action_delay)
        game.pick_game_element
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

  def invoke(action_name, arg=nil, rs = all_responses)
    raise "unknown action #{action_name}" unless rs.has_key?(action_name)
    rs[action_name].call(@game, arg )
  end
end