# To change this template, choose Tools | Templates
# and open the template in the editor.

class LineSegment
  attr_reader :sx, :sy, :ex, :ey
  def initialize(sx,sy,ex,ey)
    @sx,@sy,@ex,@ey = sx,sy,ex,ey
  end

  def draw(screen)
    screen.draw_line(@sx, @sy, Gosu::Color::BLACK, @ex, @ey, Gosu::Color::BLACK)
  end

  def collides_with_circle?(radius, vertex)
    return false
    #TODO fix this
#    seg_v = [@sx - @ex, @sy - @ey]
#    seg_v_len = seg_v.dot_product(seg_v)
#    pt_v = vertex.add_to([-@sx,-@sy])
#
#    proj_v_len = pt_v.dot_product(seg_v.unit)
#    proj_v = seg_v.unit.multiply_by(proj_v_len)
#    if proj_v_len < 0
#      closest = [@sx, @sy]
#    elsif proj_v_len > seg_v_len
#      closest = [@ex, @ey]
#    else
#      closest = [@sx, @sy].add_to(proj_v)
#    end
#
#    dist_v = vertex.add_to(closest.multiply_by(-1))
#    dist_v.dot_product(dist_v) < radius
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
    segment = LineSegment.new(sx,sy,ex,ey)
    @line_segments << segment
    @spatial_hash.insert_data_at(segment, [segment.sx, segment.sy])
    @spatial_hash.insert_data_at(segment, [segment.ex, segment.ey])
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
  def draw(screen)
    static_bodies.each {|body| body.draw(screen)}
    dynamic_elements.each {|body| body.draw(screen)}
  end

  def check_for_collisions
    collisions = @spatial_hash.collisions(@player.radius, @player.position)
    puts "got #{collisions.size} collisions" if collisions.size > 0
    collisions 
  end
end
