# To change this template, choose Tools | Templates
# and open the template in the editor.

class LineSegment
  attr_reader :sx, :sy, :ex, :ey
  def initialize(sx,sy,ex,ey)
    @sx,@sy,@ex,@ey = sx,sy,ex,ey
  end
end

class Level
  attr_accessor :measurements, :line_segments, :triangles, :circles, :rectangles
  def initialize
    @measurements = []
    @line_segments = []
    @triangles = []
    @circles = []
    @rectangles = []
  end

  def add_line_segment(sx,sy, ex, ey)
    @line_segments << LineSegment.new(sx,sy,ex,ey)
  end
end
