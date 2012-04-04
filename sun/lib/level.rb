# To change this template, choose Tools | Templates
# and open the template in the editor.


require 'chipmunk'
class SpaceWrapper

  def initialize
    @space = CP::Space.new
  end
  def add_segment(segment)
    body = CP::Body.new_static
    v1 = CP::Vec2.new(segment.sx, segment.sy)
    v2 = CP::Vec2.new(segment.ex, segment.ey)

    shape = CP::StaticShape::Segment.new(body, v1, v2, 1.0)
    @space.add_shape(shape)
    #shape = CP::SegmentShape.new(body, v1, v2, 1.0)
  end

end


class Level
  attr_accessor :measurements, :line_segments, :triangles, :circles, 
    :rectangles, :dynamic_elements, :minimum_x, :minimum_y, :maximum_x, 
    :maximum_y, :event_emitters, :enemies, :declared_enemies, :spawn_points,
    :ored_completion_conditions, :anded_completion_conditions
  attr_reader :background_image
  @@CELL_SIZE = 10
  def initialize(game=nil)
    @space = SpaceWrapper.new
    @enemies = []
    @measurements = []
    @line_segments = []
    @triangles = []
    @circles = []
    @rectangles = []
    @dynamic_elements = []
    @event_emitters = []
    @declared_enemies = {}
    @spawn_points = []
    @static_hash = SpatialHash.new(@@CELL_SIZE)
    @dynamic_hash = SpatialHash.new(@@CELL_SIZE)
    @minimum_x = 0
    @minimum_y = 0
    @maximum_x = 0
    @maximum_y = 0
    @ored_completion_conditions = []
    @anded_completion_conditions = []
    @game = game
  end

  def background_image=(img)
    @background_image = img
    if @game
      @background = @game.image_manager.register_image(@background_image)
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
    @declared_enemies[n].dup
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
    @game.completion_manager.check_conditions_or(@ored_completion_conditions) &&
      @game.completion_manager.check_conditions_and(@anded_completion_conditions)
  end
  def add_ored_completion_condition(cc)
    @ored_completion_conditions << cc
  end
  def add_anded_completion_condition(cc)
    @anded_completion_conditions << cc
  end

  def add_line_segment(sx,sy, ex, ey)
    update_minimax(sx,sy,ex,ey)
    segment = Primitives::LineSegment.new([sx,sy],[ex,ey])
    @line_segments << segment
    @static_hash.add_line_segment(segment, segment)
    @space.add_segment(segment)
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
      if sp.active_by_clock? and !sp.stopped_by_cond?
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

  def add_enemy(enemy)
    @enemies << enemy
    @dynamic_elements << enemy
  end

  def remove_enemy(enemy)
    @enemy = nil
    @enemies.reject!{|e| e == enemy}
    @dynamic_elements.reject!{|elem| elem == enemy}
  end

  include UtilityDrawing
  def draw_function_for(elem)
    #TODO move all drawing logic out of models in case we replace gosu
    #TODO maybe a gosu image manager
    mapping = {Primitives::LineSegment => lambda {|screen, linesegment|
                 p1 = @game.camera.screen_coordinates_for(linesegment.p1)
                 p2 = @game.camera.screen_coordinates_for(linesegment.p2)
                 ls = Primitives::LineSegment.new(p1, p2)
                 draw_line_segment(screen, ls, ZOrder.static.value, Gosu::Color::RED)
               },
               Player => lambda {|screen, player| @game.image_manager.draw_in_screen_coords(player) },
               Enemy => lambda {|screen, enemy| @game.image_manager.draw_in_screen_coords(enemy) },
               MouseCollisionWrapper => lambda {|screen, enemy| "NOOP, could add a highlight?" },
               #TODO ugly, should this be here? not sure about design
               VectorFollower => lambda {|screen, vf|
                 d = 10
                 cp = @game.camera.screen_coordinates_for(vf.current_position)

                 draw_rectangle(screen, Primitives::Rectangle.new(cp, cp.plus([d,0]), cp.plus([d,d]), cp.plus([0,d])))}
    }
    raise "Unknown draw function for #{elem.class}" unless mapping.has_key?(elem.class)
    mapping[elem.class]
  end

  def draw(screen)
    unless @background.nil?
      coords = @game.camera.screen_coordinates_for([0,0]) #TODO is this always 0,0?
      @background.draw(coords[0],coords[1],ZOrder.background.value)
    end
    static_bodies.each {|body| draw_function_for(body).call(screen, body)}
    dynamic_elements.each {|body| draw_function_for(body).call(screen, body)}
  end

  def remove_projectile(p)
    @dynamic_elements -= [p]
  end


  #TODO get rid of the distinction between static and dynamic
  def check_for_collisions
    cols = @static_hash.dynamic_collisions(@dynamic_elements )
    @dynamic_hash.clear
    
    @dynamic_elements.each {|e| @dynamic_hash.insert_circle_type_collider(e)}
    all = @dynamic_hash.all_collisions
    dyns = all.collect {|col| Collision.new(col.first, col.last)}
    stats = cols.collect {|col| Collision.new(col.first, col.last)}
    rv = stats + dyns
    rv
  end
end
