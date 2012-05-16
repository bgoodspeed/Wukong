$GVECTOR_UPGRADE = "construct using GVectors"

module ArrayVectorOperations



end

class GVector
  attr_accessor :x,:y

  def self.xy(x,y)
    GVector.new(x,y)
  end
  def initialize(x,y)
    @x = x
    @y = y
  end

  def min
    (x < y) ? x : y
  end
  def max
    (x < y) ? y : x
  end
  def <=>(other)
    xrv = (x.to_f <=> other.x.to_f)
    xrv == 0 ? (y.to_f <=> other.y.to_f) : xrv
  end
  def ==(other)
    x == other.x and y == other.y
  end

  def to_s
    "[#{x}, #{y}]"
  end

  #HACK this is hard coded to 2d
  def sum2d
    x + y
  end

  #HACK this is hard coded to 2d
  def dot(other)
#    rvs = gather_up_as(:*, other)
    rvs = GVector.xy(0,0)
    rvs.x = x * other.x
    rvs.y = y * other.y
    rvs.sum2d
  end

  def norm
    Math.sqrt(dot(self))
  end
  def unit
    n = norm.to_f
    raise "cannot take the unit of a zero sized vector" if n == 0.0
    scale_factor = 1.0/n

    scale(scale_factor)
  end
  def distance_from(other)
    v = self.minus(other)
    v.norm
  end

  #HACK hardcoded to 2d
  def scale(factor)
    GVector.xy(x*factor, y*factor)
  end

  #HACK 2d specific
  def minus(other)
    GVector.xy(self.x - other.x, self.y - other.y)
  end
  def plus(other)
    GVector.xy(self.x + other.x, self.y + other.y)
  end

end


module Primitives
  class Circle
    attr_accessor :position, :radius, :user_data
    def initialize(position, radius)
      @position = position
      @radius = radius
      @user_data = nil #TODO reconsider this design? should the circle belong to a data holder?
    end
    def to_s; "Circle #{@position}:#{@radius}"; end
    def collision_response_type; self.class; end
    def collision_type; self.class; end
    
    def to_collision; self; end
  end
  class LineSegment
    attr_accessor :p1, :p2, :user_data, :collision_priority
    def initialize(p1, p2, ud=nil, cp=CollisionPriority::HIGH)
      @p1 = p1
      @p2 = p2
      @user_data = ud #TODO reconsider this design
      @collision_priority = cp
    end
    def sx; @p1.x; end
    def sy; @p1.y; end
    def ex; @p2.x; end
    def ey; @p2.y; end
    def to_s; "Lineseg #{@p1}:#{@p2}"; end
    def collision_response_type; self.class; end
    def collision_type; self.class; end
    def to_collision; self; end
  end

  #TODO this assumed AXIS ALIGNED to calculate l,r,b,t
  class Rectangle
    attr_accessor :p1, :p2, :p3, :p4, :left, :right, :top, :bottom
    def initialize(p1, p2, p3, p4)
      @p1 = p1
      @p2 = p2
      @p3 = p3
      @p4 = p4

      all = [p1, p2, p3,p4]
      xs = all.collect {|p| p.x}
      ys = all.collect {|p| p.y}
      @left = xs.min
      @right = xs.max
      @top = ys.max
      @bottom = ys.min
    end
    def to_s; "Rectangle #{@p1}:#{@p2}:#{@p3}:#{@p4}"; end

  end
  class Triangle
    attr_accessor :p1, :p2, :p3
    def initialize(p1, p2, p3)
      @p1 = p1
      @p2 = p2
      @p3 = p3
    end
    def to_s; "Triangle #{@p1}:#{@p2}:#{@p3}"; end
  end
end

module PrimitiveIntersectionTests
  def circle_circle_intersection?(c1, c2)
    from = c1.position.minus(c2.position)
    dist = from.norm
    rad_sum = c1.radius + c2.radius
    dist <= rad_sum
  end

  def primitive_circle_line_segment_intersection?(cx,cy,cr, ls1x, ls1y, ls2x, ls2y)
    seg_vx = ls2x - ls1x
    seg_vy = ls2y - ls1y

    pt_vx = cx - ls1x
    pt_vy = cy - ls1y

    seg_v_norm = Math::sqrt(seg_vx * seg_vx + seg_vy * seg_vy)
    seg_vux = seg_vx.to_f/seg_v_norm
    seg_vuy = seg_vy.to_f/seg_v_norm

    proj_len = pt_vx * seg_vux + pt_vy * seg_vuy
    projx = seg_vux * proj_len
    projy = seg_vuy * proj_len

    closestx = nil
    closesty = nil
    if proj_len < 0
      closestx = ls1x
      closesty = ls1y
    elsif proj_len > seg_v_norm
      closestx = ls2x
      closesty = ls2y
    else
      closestx = ls1x + projx
      closesty = ls1y + projy
    end

    dist_vx = cx - closestx
    dist_vy = cy - closesty

    (dist_vx * dist_vx + dist_vy * dist_vy) <= cr * cr

  end

  def circle_line_segment_intersection?(circle, line_segment)
    primitive_circle_line_segment_intersection?(circle.position.x, circle.position.y, circle.radius, line_segment.p1.x, line_segment.p1.y, line_segment.p2.x, line_segment.p2.y)
  end
 

  def circle_point_intersection?(circle, point)
    circle_circle_intersection?(circle, Primitives::Circle.new(point, 0.0))
  end

  def circle_rectangle_intersection?(circle, rectangle)
    circle_line_segment_intersection?(circle, Primitives::LineSegment.new(rectangle.p1, rectangle.p2)) ||
      circle_line_segment_intersection?(circle, Primitives::LineSegment.new(rectangle.p2, rectangle.p3)) ||
      circle_line_segment_intersection?(circle, Primitives::LineSegment.new(rectangle.p3, rectangle.p4)) ||
      circle_line_segment_intersection?(circle, Primitives::LineSegment.new(rectangle.p4, rectangle.p1)) ||
      circle_inside_rectangle?(circle, rectangle)
  end

  def in_on_less(dir, c1, c2, c3)
    (dir < c1 ||
     dir < c2 ||
     dir < c3 )
  end
  def in_on_more(dir, c1, c2, c3)
    (dir > c1 ||
     dir > c2 ||
     dir > c3 )
  end
  def circle_inside_rectangle?(circle, rectangle)
    minx = circle.position.x - circle.radius
    maxx = circle.position.x + circle.radius
    return false unless in_on_less(rectangle.left, circle.position.x, minx, maxx)
    return false unless in_on_more(rectangle.right, circle.position.x, minx, maxx)
    miny = circle.position.y - circle.radius
    maxy = circle.position.y + circle.radius
    return false unless in_on_more(rectangle.top, circle.position.y, miny, maxy)
    in_on_less(rectangle.bottom, circle.position.y, miny, maxy)
  end

  def circle_triangle_intersection?(circle, triangle)
    circle_line_segment_intersection?(circle, Primitives::LineSegment.new(triangle.p1, triangle.p2)) ||
      circle_line_segment_intersection?(circle, Primitives::LineSegment.new(triangle.p2, triangle.p3)) ||
      circle_line_segment_intersection?(circle, Primitives::LineSegment.new(triangle.p3, triangle.p1))

  end

  def rectangle_rectangle_intersection?(r1, r2)
    !(r1.left > r2.right || r1.right < r2.left || r1.top < r2.bottom || r1.bottom > r2.top)
  end

  def rectangle_point_intersection?(rectangle, point)
    (rectangle.left <= point.x && rectangle.right >= point.x &&
     rectangle.bottom <= point.y && rectangle.top >= point.y)
  end
  def rectangle_line_segment_intersection?(rectangle, line_segment)
    lsxs = [line_segment.p1.x, line_segment.p2.x]
    lsys = [line_segment.p1.y, line_segment.p2.y]
    minx = lsxs.min
    maxx = lsxs.max
    maxx = rectangle.right if (maxx > rectangle.right)
    minx = rectangle.left if (minx < rectangle.left)
    return false if minx > maxx

    miny = lsys.min
    maxy = lsys.max
    maxy = rectangle.top if (maxy > rectangle.top)
    miny = rectangle.bottom if (miny < rectangle.bottom)

    return false if miny > maxy

    true
  end

  def line_segment_line_segment_intersection?(l1, l2)
    lsxd = l1.sx - l2.sx
    lsyd = l1.sy - l2.sy
    l2yd = l2.ey - l2.sy
    l2xd = l2.ex - l2.sx
    l1xd = l1.ex - l1.sx
    l1yd = l1.ey - l1.sy
    d =   (l2yd) * (l1xd) - (l2xd) * (l1yd)
    n_a = (l2xd) * (lsyd) - (l2yd) * (lsxd)
    n_b = (l1xd) * (lsyd) - (l1yd) * (lsxd)

    return false if (d == 0)
    ua = n_a.to_f/d.to_f
    ub = n_b.to_f/d.to_f
    if (ua >= 0 && ua <= 1 && ub >= 0 && ub <= 1)
    #if (ua > 0 && ua < 1 && ub > 0 && ub < 1)
      #       ptIntersection.X = L1.X1 + (ua * (L1.X2 - L1.X1));
            #ptIntersection.Y = L1.Y1 + (ua * (L1.Y2 - L1.Y1));
       return true
    end
    false
  end
end

module GraphicsApi
  def calculate_offset_x(vector, scale)
    Graphics::offset_x(vector,scale)
  end
  def calculate_offset_y(vector, scale)
    Graphics::offset_y(vector,scale)
  end
end