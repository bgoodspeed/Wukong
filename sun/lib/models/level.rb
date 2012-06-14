# To change this template, choose Tools | Templates
# and open the template in the editor.
# Copyright 2012 Ben Goodspeed
class LevelAnimation
  include YamlHelper
  ATTRIBUTES = [:animation_name, :animation_file, :animation_width,
                :animation_height, :animation_position, :animation_active, :animation_rate]
  ATTRIBUTES.each {|attr| attr_accessor(attr)}
  alias_method :animation_path, :animation_file
  def initialize(game, conf)
    @game = game
    process_attributes(ATTRIBUTES, self, conf, {:animation_position => Finalizers::GVectorFinalizer.new})
  end

  def animation_path_for(name)
    @animation_file
  end
  def animation_position_by_name(name)
    @animation_position
  end
end
# Copyright 2012 Ben Goodspeed
class Level
  ARRAY_ATTRIBUTES = [:enemies, :measurements, :line_segments, :triangles,
    :circles, :rectangles, :dynamic_elements, :enemies, :event_emitters,
    :spawn_points, :ored_completion_conditions, :anded_completion_conditions,
    :event_areas, :animations, :sight_lines, :equipment_renderables, :extra_backgrounds,
      :pushable_elements, :push_targets
    ]
  HASH_ATTRIBUTES = [
    :declared_enemies,
  ]
  SCALAR_ATTRIBUTES = [ :spawned_enemies, :background, :current_hack_puzzle

  ]
  YAML_ATTRIBUTES = [ :orig_filename, :cell_size, :background_image, :background_music, :reward_level,
    :player_start_position, :name, :minimum_x, :minimum_y, :maximum_x, :maximum_y, :player_start_health,
    :animation_distance_threshold, :max_enemies, :measurements, :hack_puzzle_key
  ]

  ATTRIBUTES = ARRAY_ATTRIBUTES + HASH_ATTRIBUTES + SCALAR_ATTRIBUTES + YAML_ATTRIBUTES


  ATTRIBUTES.each {|attr| attr_accessor attr}

  include InitHelper

  def self.default_config
    {
      'cell_size' => 100,
      'animation_distance_threshold' => 800,
      'max_enemies' => 10,
      'minimum_x' => 0,
      'maximum_x' => 0,
      'minimum_y' => 0,
      'maximum_y' => 0,
    }
  end
  include YamlHelper
  include ValidationHelper
  attr_reader :required_attributes
  def initialize(game=nil, in_conf={})
    @game = game
    init_arrays(ARRAY_ATTRIBUTES, self)
    conf = self.class.default_config.merge(in_conf)
    process_attributes(YAML_ATTRIBUTES, self, conf, {:player_start_position => Finalizers::GVectorFinalizer.new})
    @declared_enemies = {}
    @static_hash = SpatialHash.new(@cell_size)
    @dynamic_hash = SpatialHash.new(@cell_size)
    @spawned_enemies = 0
    @current_hack_puzzle = ""
    @music = @game.sound_controller.add_song(@background_music, @background_music) if @background_music
    @required_attributes = YAML_ATTRIBUTES - [:player_start_position, :player_start_health,
                                              :background_music, :background_image, :reward_level, :hack_puzzle_key]

  end

  def all_backgrounds
    if @background
      all = [@background]
    else
      all = []
    end

    all + @extra_backgrounds
  end

  def backgrounds_defined
    all_backgrounds.size
  end

  def update_minimax(sx,sy,ex,ey)
    @minimum_x = [sx, ex, @minimum_x].min
    @maximum_x = [sx, ex, @maximum_x].max
    @minimum_y = [sy, ey, @minimum_y].min
    @maximum_y = [sy, ey, @maximum_y].max
  end

  def declared_enemy(n)
    @declared_enemies[n]
  end
  def add_declared_enemy(n,e)
    @declared_enemies[n] = e
  end

  def add_equipment_renderable(er)
    @equipment_renderables << er
  end

  def targettable_enemies
    tgts = @enemies.select {|e|
      (e.position.distance_from(@game.player.position) <= @game.targetting_controller.target_distance_threshold) && (e.line_of_sight)
    }
    tgts.sort {|e1,e2|  e1.position.distance_from(@game.player.position) <=> e2.position.distance_from(@game.player.position)}
  end

  def remove_line_of_sight(los)
    @sight_lines.reject!{|e| e == los}
    @dynamic_elements.reject! {|e|los == e}
  end
  def remove_line_of_sight_queries
    #TODO might need to send an enemy lost query here
    @sight_lines.each {|los|
      los.a.trigger_event(:enemy_sighted)
      los.a.line_of_sight = true
      @dynamic_elements.reject! {|e|los == e}
    }
    @sight_lines = []
  end
  def add_line_of_sight_query(los)
    @sight_lines << los
    @dynamic_elements << los

  end

  def add_pushable_element(e)
    @dynamic_elements << e
    @pushable_elements << e
  end

  def remove_pushable_element(e)
    @dynamic_elements.reject!{|el| e == el}
    @pushable_elements.reject!{|el| e == el}
  end

  def push_targets_satisfied
    @push_targets.select {|e| e.satisfied? }
  end

  def add_push_target(e)
    @dynamic_elements << e
    @push_targets << e
  end

  def add_pickup_item(pickup_item)
    @dynamic_elements << pickup_item
  end
  def remove_pickup_item(pickup_item)
    @dynamic_elements.reject! {|e|e == pickup_item }
  end
  def add_event_emitter(event_emitter)
    update_minimax(event_emitter.position.x, event_emitter.position.y, event_emitter.position.x, event_emitter.position.y)

    @event_emitters << event_emitter
    @static_hash.insert_circle_type_collider(event_emitter)
  end

  def completed?
    return true if hack_puzzle_key and current_hack_puzzle == hack_puzzle_key
    return true if !push_targets.empty? and push_targets_satisfied.size == push_targets.size

    if @ored_completion_conditions.empty? and @anded_completion_conditions.empty?
      #TODO handle level being unbounded
      return false
    end
    @game.completion_controller.check_conditions_or(@ored_completion_conditions) &&
      @game.completion_controller.check_conditions_and(@anded_completion_conditions)
  end
  def add_ored_completion_condition(cc)
    @ored_completion_conditions << cc
  end
  def add_anded_completion_condition(cc)
    @anded_completion_conditions << cc
  end

  def add_event_area(ea)
    @static_hash.add_rectangle(ea, ea.rect)
    @event_areas << ea
  end

  def hack_puzzle_amend(s)
    @current_hack_puzzle += s
  end

  def active_event_areas(collision_volume=@game.player.to_collision)
    @event_areas.select {|ea| ea.active? and ea.intersects?(collision_volume)}
  end
  def interact(collision_volume)
    areas = active_event_areas(collision_volume)

    if areas.empty?
      #TODO level.rb, no areas to interact with at player position #{collision_volume}"
      return
    end
    ea = areas.first #TODO can actually be on multiple at once
    rv = ea.invoke

    rv
  end

  def add_line_segment(sx,sy, ex, ey)
    update_minimax(sx,sy,ex,ey)
    segment = Primitives::LineSegment.new(GVector.xy(sx,sy),GVector.xy(ex,ey))
    @line_segments << segment
    @static_hash.add_line_segment(segment, segment)
  end
  def add_projectile(p)
    @dynamic_elements << p
  end

  def add_mouse(pos)
    @dynamic_elements << MouseCollisionWrapper.new(@game, pos)
  end

  def remove_mouse
    @dynamic_elements.reject!{|e| e.kind_of? MouseCollisionWrapper}
  end
  def add_spawn_point(sp)
    @spawn_points << sp
  end
  def update_spawn_points
    @spawn_points.each do |sp|
      if sp.active_by_clock? and !sp.stopped_by_cond? and @enemies.size < @max_enemies
        sp.enqueue_events
      end
    end
  end

  def static_bodies
    [@line_segments, @triangles, @circles, @rectangles].flatten
  end

  def set_player(player)
    @dynamic_elements.reject!{|elem| elem == @player}
    add_player(player)
  end

  def add_player(player)
    @player = player
    @dynamic_elements << player
  end

  def update_animations
    @animations.each do |anim|
      if @player.position.distance_from(anim.animation_position) < @animation_distance_threshold
        @game.animation_controller.play_animation(anim, anim.animation_name)
      else
        @game.animation_controller.stop_animation(anim, anim.animation_name)
      end

    end
  end

  def tick
    update_animations
    update_spawn_points
    if completed?
      raise "need to set reward level for completable levels: #{self} #{@name}" unless @reward_level
      @game.player.progression.level_completed(@name)
      e = Event.new( @reward_level, EventTypes::LOAD_LEVEL)
      #e = LambdaEvent.new(@game, lambda{|game, arg| puts "decide what to do now that you've beaten this level. #{arg}"}, "argumentblahblah")
      @game.add_event(e)
    end
  end

  def add_weapon(weapon)
    @dynamic_elements << weapon
  end
  def add_enemy(enemy)
    @enemies << enemy
    @dynamic_elements << enemy
  end

  def remove_weapon(weapon)
    @dynamic_elements.reject!{|elem| elem == weapon}
  end

  def remove_enemy(enemy)
    @enemy = nil
    @enemies.reject!{|e| e == enemy}
    @dynamic_elements.reject!{|elem| elem == enemy}
  end



  def current_background
    all = all_backgrounds
    level_idx = [all.size - 1, @game.player.progression.level_background_rank].min
    all[level_idx]
  end

  def draw(screen)
    unless current_background.nil?
      coords = @game.camera.screen_coordinates_for(GVector.xy(0,0)) #TODO is this always 0,0?
      current_background.draw(coords.x,coords.y,ZOrder.background.value)
    end
    static_bodies.each {|body| @game.rendering_controller.draw_function_for(body).call(screen, body)}
    dynamic_elements.each {|body| @game.rendering_controller.draw_function_for(body).call(screen, body)}
    event_areas.each {|body| @game.rendering_controller.draw_function_for(body).call(screen, body) }
    equipment_renderables.each {|body| @game.rendering_controller.draw_function_for(body).call(screen, body) }
  end

  def remove_projectile(p)
    @dynamic_elements -= [p]
  end


  def collect_collisions(s)
    s.collect {|col| Collision.new(col.first, col.last)}
  end
  #TODO get rid of the distinction between static and dynamic
  def check_for_collisions
    cols = @static_hash.dynamic_collisions(@dynamic_elements )
    @dynamic_hash.clear
    
    @dynamic_elements.each {|e|
      if e.kind_of?(PushableElement)
        @dynamic_hash.add_rectangle(e, e.to_collision)
      else
        @dynamic_hash.insert_circle_type_collider(e)
      end


    }
    all = @dynamic_hash.all_collisions
    rv = collect_collisions(all) + collect_collisions(cols)
    rv.sort {|a,b| a.collision_priority <=> b.collision_priority}
  end
end
