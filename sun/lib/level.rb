# To change this template, choose Tools | Templates
# and open the template in the editor.


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
    @spatial_hash = SpatialHash.new(@@CELL_SIZE)
    
  end

  def add_line_segment(sx,sy, ex, ey)
    segment = Primitives::LineSegment.new([sx,sy],[ex,ey])
    @line_segments << segment
    @spatial_hash.add_line_segment(segment, segment)
    @space.add_segment(segment)
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

  include UtilityDrawing
  def draw_function_for(elem)
    mapping = {Primitives::LineSegment => lambda {|screen, linesegment| draw_line_segment(screen, linesegment) }}
    raise "Unknown draw function for #{elem.class}" unless mapping.has_key?(elem.class)
    mapping[elem.class]
  end
  def draw(screen)
    static_bodies.each {|body| draw_function_for(body).call(screen, body)}
    dynamic_elements.each {|body| body.draw(screen)}
  end

  #TODO this is really check for player collisions...
  def check_for_collisions
    cols = @spatial_hash.collisions(@player.radius, @player.position)
    cols.collect {|col| StaticCollision.new(@player, col)}
  end
end
