# To change this template, choose Tools | Templates
# and open the template in the editor.

class LineSegment
  attr_reader :sx, :sy, :ex, :ey
  def initialize(sx,sy,ex,ey)
    @sx,@sy,@ex,@ey = sx,sy,ex,ey
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
  attr_accessor :measurements, :line_segments, :triangles, :circles, :rectangles
  def initialize
    @space = SpaceWrapper.new
    @measurements = []
    @line_segments = []
    @triangles = []
    @circles = []
    @rectangles = []
  end

  def add_line_segment(sx,sy, ex, ey)
    @line_segments << LineSegment.new(sx,sy,ex,ey)
    @space.add_segment(LineSegment.new(sx,sy,ex,ey))
  end

  def static_bodies
    [@line_segments, @triangles, @circles, @rectangles].flatten
  end

  def draw(screen)
    puts "draw level"
  end
end
