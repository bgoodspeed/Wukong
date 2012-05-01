# To change this template, choose Tools | Templates
# and open the template in the editor.

class LevelAnimation
  attr_reader :animation_name, :animation_file, :animation_width, 
    :animation_height, :animation_position, :animation_active, :animation_rate
  def initialize(game, conf)
    @game = game
    @animation_name = conf['animation_name']
    @animation_file = conf['animation_file']
    @animation_width = conf['animation_width']
    @animation_height = conf['animation_height']
    @animation_position = conf['animation_position']
    @animation_active = conf['animation_active']
    @animation_rate = conf['animation_rate']
  end

  def animation_position_by_name(name)
    @animation_position
  end
end

class Level
  ARRAY_ATTRIBUTES = [:enemies, :measurements, :line_segments, :triangles,
    :circles, :rectangles, :dynamic_elements, :enemies, :event_emitters,
    :spawn_points, :ored_completion_conditions, :anded_completion_conditions,
    :event_areas, :animations
    ]
  HASH_ATTRIBUTES = [
    :declared_enemies,
  ]
  SCALAR_ATTRIBUTES = [
    :minimum_x, :minimum_y, :maximum_x, :maximum_y, :name, :reward_level, :max_enemies,
    :orig_filename, :cell_size, :player_start_position #TODO this is technically an array,but i don't want it init'd to []
  ]

  ATTRIBUTES = ARRAY_ATTRIBUTES + HASH_ATTRIBUTES + SCALAR_ATTRIBUTES

  ATTRIBUTES.each {|attr| attr_accessor attr}
  attr_reader :background_image, :background_music

  include InitHelper

  def self.default_config
    {
      'cell_size' => 100,
      'animation_distance_threshold' => 800,
      'max_enemies' => 10
    }
  end

  def initialize(game=nil, in_conf={})
    init_arrays(ARRAY_ATTRIBUTES, self)
    conf = self.class.default_config.merge(in_conf)
    @declared_enemies = {}
    @cell_size = conf['cell_size']
    @static_hash = SpatialHash.new(@cell_size)
    @dynamic_hash = SpatialHash.new(@cell_size)
    @player_start_position = nil
    @minimum_x = 0
    @minimum_y = 0
    @maximum_x = 0
    @maximum_y = 0
    @animation_distance_threshold = conf['animation_distance_threshold']
    @max_enemies = conf['max_enemies']
    @game = game
  end

  def background_image=(img)
    @background_image = img
    if @game
      @background = @game.image_controller.register_image(@background_image)
    else
      #TODO should game be required to build a level?
    end
  end
  def background_music=(img)
    @background_music = img
    if @game
      @music = @game.sound_controller.add_song(@background_music, @background_music)
    else
      #TODO should game be required to build a level?
    end
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
  def add_event_emitter(position, radius, event_name, event_arg)
    update_minimax(position[0], position[1], position[0], position[1])
    circle = Primitives::Circle.new(position, radius)
    event_emitter = EventEmitter.new(@game, circle, event_name, event_arg)
    @event_emitters << event_emitter
    @static_hash.insert_circle_type_collider(event_emitter)
  end

  def completed?
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
    @event_areas << ea
  end

  def active_event_areas(collision_volume=@game.player.to_collision)
    @event_areas.select {|ea| ea.intersects?(collision_volume)}
  end
  def interact(collision_volume)
    areas = active_event_areas(collision_volume)

    if areas.empty?
      #TODO level.rb, no areas to interact with at player position #{collision_volume}"
      return
    end

    areas.first.invoke
  end

  def add_line_segment(sx,sy, ex, ey)
    update_minimax(sx,sy,ex,ey)
    segment = Primitives::LineSegment.new([sx,sy],[ex,ey])
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


  def draw(screen)
    unless @background.nil?
      coords = @game.camera.screen_coordinates_for([0,0]) #TODO is this always 0,0?
      @background.draw(coords[0],coords[1],ZOrder.background.value)
    end
    static_bodies.each {|body| @game.rendering_controller.draw_function_for(body).call(screen, body)}
    dynamic_elements.each {|body| @game.rendering_controller.draw_function_for(body).call(screen, body)}
    event_areas.each {|body| @game.rendering_controller.draw_function_for(body).call(screen, body) }
    active_event_areas.each {|body| @game.rendering_controller.draw_function_for(body.info_window).call(screen, body) }
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
    
    @dynamic_elements.each {|e| @dynamic_hash.insert_circle_type_collider(e)}
    all = @dynamic_hash.all_collisions
    rv = collect_collisions(all) + collect_collisions(cols)
    rv.sort {|a,b| a.collision_priority <=> b.collision_priority}
  end
end
