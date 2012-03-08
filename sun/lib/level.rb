# To change this template, choose Tools | Templates
# and open the template in the editor.


class DynamicCollision
  attr_reader :dynamic1, :dynamic2
  def initialize(dynamic, dynamic2)
    @dynamic1 = dynamic
    @dynamic2 = dynamic2
  end
end
class StaticCollision
  attr_reader :static, :dynamic
  def initialize(dynamic, static)
    @dynamic = dynamic
    @static = static
  end
end

class CollisionHandlerChipmunk

end

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
  attr_accessor :measurements, :line_segments, :triangles, :circles, :rectangles, :dynamic_elements
  @@CELL_SIZE = 10
  def initialize
    @space = SpaceWrapper.new
    @measurements = []
    @line_segments = []
    @triangles = []
    @circles = []
    @rectangles = []
    @dynamic_elements = []
    @static_hash = SpatialHash.new(@@CELL_SIZE)
    @dynamic_hash = SpatialHash.new(@@CELL_SIZE)
    
  end

  def add_line_segment(sx,sy, ex, ey)
    segment = Primitives::LineSegment.new([sx,sy],[ex,ey])
    @line_segments << segment
    @static_hash.add_line_segment(segment, segment)
    @space.add_segment(segment)
  end
  def add_projectile(p)
    @dynamic_elements << p
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


  def set_enemy(enemy)
    @dynamic_elements.reject!{|elem| elem == @enemy}
    add_enemy(enemy)
  end

  def add_enemy(enemy)
    @enemy = enemy
    @dynamic_elements << enemy
  end


  include UtilityDrawing
  def draw_function_for(elem)
    #TODO move all drawing logic out of models in case we replace gosu
    #TODO maybe a gosu image manager
    mapping = {Primitives::LineSegment => lambda {|screen, linesegment| draw_line_segment(screen, linesegment, ZOrder.static.value) },
               Player => lambda {|screen, player| player.draw(screen) },
               Enemy => lambda {|screen, enemy| enemy.draw(screen) },
               #TODO ugly, should this be here? not sure about design
               VectorFollower => lambda {|screen, vf|
                 d = 10
                 draw_rectangle(screen, Primitives::Rectangle.new(vf.current_position, vf.current_position.plus([d,0]), vf.current_position.plus([d,d]), vf.current_position.plus([0,d])))}
    }
    raise "Unknown draw function for #{elem.class}" unless mapping.has_key?(elem.class)
    mapping[elem.class]
  end

  def draw(screen)
    static_bodies.each {|body| draw_function_for(body).call(screen, body)}
    dynamic_elements.each {|body| draw_function_for(body).call(screen, body)}
  end

  def remove_projectile(p)
    @dynamic_elements -= [p]
  end

  def check_for_collisions
    cols = @static_hash.dynamic_collisions(@dynamic_elements )
    @dynamic_hash.clear
    @dynamic_elements.each {|e| @dynamic_hash.insert_data_at(e, e.collision_center)}
    all = @dynamic_hash.all_collisions
    dyns = all.collect {|col| DynamicCollision.new(col.first, col.last)}
    stats = cols.collect {|col| StaticCollision.new(col.first, col.last)}
    stats + dyns
  end
end
