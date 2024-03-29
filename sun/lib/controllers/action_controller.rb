

#TODO how to make this configurable? maybe not needed since input->action is configurable
# Copyright 2012 Ben Goodspeed# Copyright 2012 Ben Goodspeed
module BehaviorTypes
  GIVE_UPGRADE_POINTS = "give_upgrade_points"
  QUEUE_NEW_GAME_EVENT = "queue_start_new_game_event"
  QUEUE_LOAD_GAME_EVENT = "queue_load_game_event"
  QUEUE_SAVE_GAME_EVENT = "queue_save_game_event"
  CHOOSE_GAME_MENU = "CHOOSE_GAME_MENU"
  SAVE_GAME_SLOT = "save_game_slot"
  LOAD_GAME_SLOT = "load_game_slot"
  CONTINUE_LAST_GAME = "continue_last_game"
  TAKE_REWARD = "take_reward"
  UPGRADE_PLAYER = "upgrade_player"
  UPGRADE_PROGRESSION = "upgrade_progression"
  EQUIPMENT_MENU = "equipment_menu"
  CUSTOMIZATION_MENU = "customization_menu"
  EQUIP_ITEM = "equip_item"
  DEBUG_PRINT = "debug_print"
  CONSUME_ITEM = "consume_item"
  CHOOSE_ITEM_FOR_CUSTOMIZATION = "choose_item_for_customization"
  PROCEED_WITH_CUSTOMIZATION = "proceed_with_customization"

  NOOP = "noop"
  RESET_PLAYER_AND_LOAD_LEVEL = "reset_player_and_load_level"
end
# Copyright 2012 Ben Goodspeed# Copyright 2012 Ben Goodspeed
class ActionController
  def default_menu_actions
    {
      BehaviorTypes::DEBUG_PRINT => lambda {|game, arg| game.log.info "DEBUG_PRINT: #{arg}"},
      BehaviorTypes::TAKE_REWARD => lambda {|game, arg| 
        game.log.info "Take reward: #{arg}"
        w = game.inventory_controller.item_named(arg.argument)
        game.player.inventory.add_item(w)
      },
      BehaviorTypes::PROCEED_WITH_CUSTOMIZATION => lambda {|game, arg|
        game.customization_controller.proceed
        },
      BehaviorTypes::EQUIP_ITEM => lambda {|game, arg|
        w = game.inventory_controller.item_named(arg.argument)
        game.player.equip_weapon(w)},
      BehaviorTypes::CONSUME_ITEM => lambda {|game, arg|
        item = game.inventory_controller.item_named(arg.argument)
        game.player.use_item(item) },
      BehaviorTypes::CHOOSE_ITEM_FOR_CUSTOMIZATION => lambda {|game, arg|
        item = game.inventory_controller.item_named(arg.argument)
        # game.player.use_item(item)
        game.customization_controller.select_for_customization(item)

      },

      BehaviorTypes::SAVE_GAME_SLOT => lambda {|game, arg| 
        game.clock.set_last_save_time
        game.save_game_slot(arg)
        msg = "Saved to slot #{arg}"
        game.log.info { msg }
        game.clock.enqueue_event("message", TimedEvent.new("temporary_message=", msg ,"temporary_message=", nil, 60 ))
        game.exit_menu
      }, #TODO could add temp message and maybe exit menu
      BehaviorTypes::LOAD_GAME_SLOT => lambda {|game, arg|
        game.load_game_slot(arg)
        msg = "Loaded slot #{arg}","temporary_message="
        game.log.info { msg }
        game.clock.enqueue_event("message", TimedEvent.new("temporary_message=", msg ,"temporary_message=", nil, 60 ))
        game.exit_menu
      },
      BehaviorTypes::CONTINUE_LAST_GAME => lambda {|game, arg|
        slot = game.load_most_recent_game_slot
        msg = "Continued slot #{slot}","temporary_message="
        game.log.info { msg }
        game.clock.enqueue_event("message", TimedEvent.new("temporary_message=", msg ,"temporary_message=", nil, 60 ))
      },
      BehaviorTypes::NOOP => lambda {|game, arg| }
    }
  end
  def default_collision_responses
    {
      ResponseTypes::DAMAGING_SHOWING_AND_REMOVING1 => lambda {|game, col|
        attacker = col.dynamic2
        target = col.dynamic1

        return if target == attacker.owner

        target.take_damage(attacker)
        game.rendering_controller.add_consumable_rendering(target, RenderingTypes::TARGET_DAMAGE, 10)
        game.remove_projectile(attacker)

      },
      ResponseTypes::DAMAGING_SHOWING_AND_REMOVING2 => lambda {|game, col|
        attacker = col.dynamic1
        target = col.dynamic2
        return if target == attacker.owner
        target.take_damage(attacker)
        game.rendering_controller.add_consumable_rendering(target, RenderingTypes::TARGET_DAMAGE, 10)
        game.remove_projectile(attacker)

      },
      ResponseTypes::DAMAGING1 => lambda {|game, col|
        game.sound_controller.play_effect(col.dynamic1.damage_sound_effect_name)
        col.dynamic1.take_damage(col.dynamic2)
      },
      ResponseTypes::DAMAGING2 => lambda {|game, col|
        col.dynamic2.take_damage(col.dynamic1)
      },
      ResponseTypes::TAKE_INVENTORY1 => lambda {|game, col|
        pi = col.dynamic1
        game.player.acquire_inventory(pi.inventory)
        game.level.remove_pickup_item(pi)
      },
      ResponseTypes::TAKE_INVENTORY2 => lambda {|game, col|
        pi = col.dynamic2

        game.player.acquire_inventory(pi.inventory)
        game.level.remove_pickup_item(pi)
      },
      ResponseTypes::SHOW_DAMAGE1 => lambda {|game, col|
        game.rendering_controller.add_consumable_rendering(col.dynamic1, RenderingTypes::TARGET_DAMAGE, 10)
      },
      ResponseTypes::SHOW_DAMAGE2 => lambda {|game, col|
        game.rendering_controller.add_consumable_rendering(col.dynamic2, RenderingTypes::TARGET_DAMAGE, 10)
      },
      ResponseTypes::SHOW_INFO_WINDOW1 => lambda {|game, col|
        game.rendering_controller.add_consumable_rendering(col.dynamic1, RenderingTypes::INFO_WINDOW, 10)
      },
      ResponseTypes::SHOW_INFO_WINDOW2 => lambda {|game, col|
        game.rendering_controller.add_consumable_rendering(col.dynamic2, RenderingTypes::INFO_WINDOW, 10)
      },

      ResponseTypes::BLOCKED_LINE_OF_SIGHT1 => lambda {|game, col|
        los = col.dynamic1
        hunter = los.a
        hunter.trigger_event(:enemy_lost)
        hunter.line_of_sight = false
        game.level.remove_line_of_sight(los)

      },
      ResponseTypes::BLOCKED_LINE_OF_SIGHT2 => lambda {|game, col|
        los = col.dynamic2
        hunter = los.a
        hunter.trigger_event(:enemy_lost)
        hunter.line_of_sight = false
        game.level.remove_line_of_sight(los)

      },
      ResponseTypes::PUSH_ELEMENT1 => lambda {|game,col|
        mv = col.dynamic2.last_move
        return unless mv
        col.dynamic1.move(mv)
      },
      ResponseTypes::FIZZLE_ELEMENT1 => lambda {|game,col|
        game.level.remove_pushable_element(col.dynamic1)
        game.clock.enqueue_event("message", TimedEvent.new("temporary_message=", "Fizzled.","temporary_message=", nil, 60 ))

      },
      ResponseTypes::SEATED_ELEMENT1 => lambda {|game,col|
        return if col.dynamic2.satisfied?
        game.level.remove_pushable_element(col.dynamic1)
        game.clock.enqueue_event("message", TimedEvent.new("temporary_message=", "Seated.","temporary_message=", nil, 60 ))

      },
      ResponseTypes::SATISFYING_TARGET2 => lambda {|game,col|
        col.dynamic2.satisfy

      },
      ResponseTypes::FIZZLE_ELEMENT2 => lambda {|game,col|
        game.level.remove_pushable_element(col.dynamic2)
        game.clock.enqueue_event("message", TimedEvent.new("temporary_message=", "Fizzled.","temporary_message=", nil, 60 ))

      },
      ResponseTypes::REMOVING1 => lambda {|game, col| game.remove_projectile(col.dynamic1)},
      ResponseTypes::REMOVING2 => lambda {|game, col| game.remove_projectile(col.dynamic2)},
      ResponseTypes::BLOCKING1 => lambda {|game, col|
        col.dynamic1.undo_last_move},
      ResponseTypes::BLOCKING2 => lambda {|game, col|
        col.dynamic2.undo_last_move},
      ResponseTypes::TRIGGER_EVENT1 => lambda {|game, col| col.dynamic1.trigger},
      ResponseTypes::TRIGGER_EVENT2 => lambda {|game, col| col.dynamic2.trigger},
      ResponseTypes::MOUSE_PICK1 => lambda {|game, col|
        game.log.info { "Mouse click on #{col.dynamic1}" }
        game.remove_mouse_collision #TODO could also add a timed event here add a highlight around that enemy?
        game.add_event(Event.new(col.dynamic1, EventTypes::PICK))},
      ResponseTypes::MOUSE_PICK2 => lambda {|game, col|
        game.log.info { "Mouse click on #{col.dynamic2}" }
        game.remove_mouse_collision #TODO could also add a timed event here add a highlight around that enemy?
        game.add_event(Event.new(col.dynamic2, EventTypes::PICK))},
      ResponseTypes::TEMPORARY_MESSAGE1  => lambda {|game, col| game.clock.enqueue_event("message", TimedEvent.new("temporary_message=", col.dynamic1.hud_message,"temporary_message=", nil, 60 )) }
    }
  end

  def default_event_actions
    {
      EventTypes::DEATH => lambda {|game,e|
        if e.argument.kind_of?(game.player.class)
          game.over = true
          game.load_level(game.game_over_level)
        else
          enemy = e.argument
          game.player.enemy_killed(enemy)
          game.remove_enemy(enemy)
          game.level.add_pickup_item(PickupItem.new(game, enemy.inventory, enemy.position)) if !enemy.inventory_empty?

        end
        },
      EventTypes::LAMBDA => lambda {|game,e| e.invoke },
      EventTypes::BACK_TO_LEVEL => lambda { |game, e|
        game.load_level(game.old_level_name)
      },

      EventTypes::HACK_PUZZLE_AMEND => lambda { |game, e|
        game.level.hack_puzzle_amend(e.argument)
        game.clock.enqueue_event("message", TimedEvent.new("temporary_message=", "Current Guess #{game.level.current_hack_puzzle}","temporary_message=", nil, 360 ))
      },
      EventTypes::LOAD_LEVEL => lambda { |game, e|
        game.old_level_name = game.level.orig_filename
        game.load_level(e.argument)

      },
      BehaviorTypes::RESET_PLAYER_AND_LOAD_LEVEL => lambda { |game, e|
        player = YamlLoader.from_file(Player, game, game.player_reset)
        game.set_player player
        game.old_level_name = game.level.orig_filename
        game.load_level(e.argument)
      },
      EventTypes::START_NEW_GAME => lambda { |game, e| game.load_level(e.argument)},
      EventTypes::PICK => lambda {|game,e| game.log.warn "TODO: In Action Controller: must implement what to do when #{e.argument}"},
      EventTypes::SPAWN => lambda {|game,e|
        enemy = e.argument
        enemy.tracking_target = game.player
        game.add_enemy(enemy)
        game.path_following_controller.add_tracking(enemy, game.wayfinding)
        game.level.spawned_enemies += 1
        }
    }
  end

  #TODO unify these APIs, all lambdas should take game, arg
  def default_always_available_behaviors
    {
      KeyActions::QUIT => lambda {|game, arg| game.deactivate_and_quit },

      BehaviorTypes::UPGRADE_PLAYER => lambda {|game, arg|
        #NOTE this assumes the new animation is the same size and rate of the old.
        game.log.info "Upgrading player"
        orig_animation = @game.player.player_animation
        if arg.argument.kind_of?(Hash)
          hash = arg.argument
          f = hash['animation_file']
          w = hash['animation_width']
          h = hash['animation_height']
          r = hash['animation_rate']
        else
          f = arg.argument
          w = orig_animation.width
          h = orig_animation.height
          r = orig_animation.animation_rate
        end
        animation = game.animation_controller.register_animation(game.player, game.player.animation_name,
            f, w, h, false, false,r)
        game.player.image_path = f
        game.player.image_file = f

      },

      BehaviorTypes::GIVE_UPGRADE_POINTS => lambda {|game, arg|
        game.player.add_upgrade_points(arg.to_i)
      },
      BehaviorTypes::UPGRADE_PROGRESSION => lambda {|game, arg|
        if arg.kind_of?(Hash)
          ptype = arg['progression_type']
          amount = arg['progression_amount']
          raise "unknown progression type: #{ptype}" unless ptype =~ /level_background_rank/
          raise "unknown progression amount: #{amount}" unless amount
          game.player.progression.level_background_rank += amount.to_i
        else
          raise "TODO upgrade_progression Must take a hash"
        end
      },
      BehaviorTypes::QUEUE_NEW_GAME_EVENT => lambda {|game, arg| game.add_event(Event.new(game.new_game_level, EventTypes::START_NEW_GAME))},
      #TODO figure out which game to load from menu?
      BehaviorTypes::QUEUE_SAVE_GAME_EVENT => lambda {|game, arg| game.enter_menu(game.menu_for_save_game) },
      BehaviorTypes::EQUIPMENT_MENU => lambda {|game, arg| game.enter_menu(game.menu_for_equipment, arg.argument) },
      BehaviorTypes::CUSTOMIZATION_MENU => lambda {|game, arg| game.enter_menu(game.menu_for_customization, nil) }, #  + "_#{arg.argument}"
      BehaviorTypes::QUEUE_LOAD_GAME_EVENT => lambda {|game, arg| game.enter_menu(game.menu_for_load_game) },
#      BehaviorTypes::CHOOSE_GAME_MENU => lambda {|game, arg| puts "todo activate a menu based on '#{arg}'"}
     
    }
  end

  #TODO this is how you can limit repeat rates of keys, might need to do same for mouse clicks etc
  def introduce_delay(game, action, delay)
    te = TimedEvent.new("disable_action", action, "enable_action", action, delay)
    game.clock.enqueue_event("timeout_down_#{action}", te)
  end

  def delaying(key,  &block)
    lambda {|game, arg|
      introduce_delay(game, key, game.player.menu_action_delay)
      yield game,arg
    }
  end
  include StatsMapping
  def delaying_by_speed(key,  &block)
    lambda {|game, arg|
      introduce_delay(game, key, map_speed_to_delay(game.player.effective_stats.speed) )
      yield game,arg
    }
  end

  def default_targetting_behaviors
    {
      KeyActions::TARGETTING    => delaying(KeyActions::TARGETTING)    {|game,arg|
        game.rendering_controller.remove_consumable_rendering(game.targetting_controller, RenderingTypes::TARGETTING)
        game.targetting_controller.target_list = nil
        game.exit_targetting
      },
      KeyActions::INTERACT => delaying(KeyActions::INTERACT) {|game,arg|
        if game.targetting_controller.queue_attack_on_current
          game.clock.enqueue_event("message", TimedEvent.new("temporary_message=", "Targetted.","temporary_message=", nil, 60 ))
        else
          game.clock.enqueue_event("message", TimedEvent.new("temporary_message=", "Not enough energy points","temporary_message=", nil, 60 ))
        end

      },
      KeyActions::FIRE     => delaying(KeyActions::FIRE)     {|game,arg|

        results = game.targetting_controller.invoke_action_queue
        results.each do |result|
          if result[1] =~ /miss/
            game.rendering_controller.add_consumable_rendering(result[0].target, RenderingTypes::TARGET_MISS, 10)
          else
            game.rendering_controller.add_consumable_rendering(result[0].target, RenderingTypes::TARGET_DAMAGE, 10)
          end
        end
        game.rendering_controller.remove_consumable_rendering(game.targetting_controller, RenderingTypes::TARGETTING)
      },
      KeyActions::CANCEL   => delaying(KeyActions::CANCEL)   {|game,arg| game.targetting_controller.cancel_last_attack },
      KeyActions::LEFT     => delaying(KeyActions::LEFT)     {|game,arg| game.targetting_controller.move_to_next_lower },
      KeyActions::DOWN     => delaying(KeyActions::DOWN)     {|game,arg| game.targetting_controller.move_to_next_lower },
      KeyActions::RIGHT    => delaying(KeyActions::RIGHT)    {|game,arg| game.targetting_controller.move_to_next_higher },
      KeyActions::UP       => delaying(KeyActions::UP)       {|game,arg| game.targetting_controller.move_to_next_higher },
  }
  end

  def default_menu_behaviors
    {
      KeyActions::MENU        => delaying(KeyActions::MENU )        { |game, arg| game.exit_menu },
      KeyActions::DOWN        => delaying(KeyActions::DOWN )        { |game, arg| game.menu_controller.move_down },
      KeyActions::UP          => delaying(KeyActions::UP )          { |game, arg| game.menu_controller.move_up },
      KeyActions::MENU_ENTER  => delaying(KeyActions::MENU_ENTER )  { |game, arg| game.menu_controller.invoke_current },
      KeyActions::INTERACT    => delaying(KeyActions::INTERACT )  { |game, arg| game.menu_controller.invoke_current },
      KeyActions::MOUSE_CLICK => delaying(KeyActions::MOUSE_CLICK ) { |game, arg| game.menu_controller.invoke_current_mouse },
    }
  end
  def default_gameplay_behaviors
    {
      KeyActions::TARGETTING    => delaying(KeyActions::TARGETTING)    {|game,arg|
        if game.level.targettable_enemies.empty?
          game.clock.enqueue_event("message", TimedEvent.new("temporary_message=", "No enemies to target.","temporary_message=", nil, 60 ))
        else
          game.clock.enqueue_event("message", TimedEvent.new("temporary_message=", "There are #{game.targetting_controller.target_list.size} targets.","temporary_message=", nil, 60 ))
          game.enter_targetting
          game.rendering_controller.add_indeterminate_consumable_rendering(game.targetting_controller, RenderingTypes::TARGETTING)
        end

      },
      KeyActions::INTERACT    => delaying(KeyActions::INTERACT)    {|game,arg| game.interact},
      KeyActions::MENU_ENTER  => delaying(KeyActions::MENU_ENTER)  {|game,arg| game.interact},
      KeyActions::MENU        => delaying(KeyActions::MENU)        {|game,arg| game.enter_menu},
      KeyActions::MOUSE_CLICK => delaying(KeyActions::MOUSE_CLICK) {|game,arg|
        msc = game.input_controller.mouse_screen_coords
        game.log.info "Mouse click at screen: #{msc.x},#{msc.y}"
        mwc = game.input_controller.mouse_world_coordinates
        game.log.info "Mouse click at world: #{mwc.x},#{mwc.y}"
        game.pick_game_element},
      
      KeyActions::RIGHT => lambda { |game, arg|
        d = game.turn_speed
        d *= game.speed_factor if game.input_controller.speed_up_key_down?
        d /= game.speed_factor if game.input_controller.speed_down_key_down?
        game.player.turn(d)
      },
      KeyActions::LEFT  => lambda { |game, arg|
        d = game.turn_speed
        d *= game.speed_factor if game.input_controller.speed_up_key_down?
        d /= game.speed_factor if game.input_controller.speed_down_key_down?
        game.player.turn(-d)
      },
      KeyActions::UP    => lambda { |game, arg| 
        game.animation_controller.animation_index_by_entity_and_name(game.player, game.player.main_animation_name).needs_update = true
        game.sound_controller.play_singleton_effect(game.player.footsteps_effect_name)
        d = game.movement_distance
        d *= game.speed_factor if game.input_controller.speed_up_key_down?
        d /= game.speed_factor if game.input_controller.speed_down_key_down?
        game.player.move_forward(d)
      },
      KeyActions::DOWN  => lambda { |game, arg|
        game.animation_controller.animation_index_by_entity_and_name(game.player, game.player.main_animation_name).needs_update = true
        game.sound_controller.play_singleton_effect(game.player.footsteps_effect_name)
        d = game.movement_distance
        d *= game.speed_factor if game.input_controller.speed_up_key_down?
        d /= game.speed_factor if game.input_controller.speed_down_key_down?
        game.player.move_forward(-d)
      },
      #TODO need a way to let the weapon determine the length of the delay
      KeyActions::FIRE  => delaying_by_speed(KeyActions::FIRE) {|game,arg| game.player.use_weapon},
    }
  end


  #TODO unify these interfaces?
  attr_reader :collision_responses, :menu_actions, :event_actions, 
    :always_available_behaviors, :gameplay_behaviors, :menu_behaviors, :targetting_behaviors
  
  def initialize(game)
    @game = game
    @collision_responses = default_collision_responses
    @menu_actions = default_menu_actions
    @event_actions = default_event_actions
    @always_available_behaviors = default_always_available_behaviors
    @gameplay_behaviors = default_gameplay_behaviors
    @menu_behaviors = default_menu_behaviors
    @targetting_behaviors = default_targetting_behaviors
  end

  def all_responses
    @collision_responses.merge(@menu_actions).merge(@event_actions).merge(@always_available_behaviors).merge(@gameplay_behaviors).merge(@menu_behaviors)
  end

  def invoke(action_name, arg=nil, rs = all_responses)
    raise "unknown action '#{action_name}'\ndefined are: #{rs.keys}" unless rs.has_key?(action_name)
    rs[action_name].call(@game, arg )
  end

 def menu_invoke(menu, c, breadcrumbs)
    if c.nil?
      puts "no entry available handle this"
      return
    end
    @game.log.info { "Attempting to invoke #{c}"}
    ce = c
    action = ce.action
    action_argument = ce.action_argument

    m = @menu_actions[action]
    raise "unknown action #{action}" if m.nil?
    action_result = m.call(@game, action_argument)
    menu_id = menu.menu_id
    breadcrumbs << Breadcrumb.new(menu_id, action, action_argument, action_result)
    @game.log.info { "Successfully invoked menu entry #{action}(#{action_argument})"}
    action_result
  end
end
