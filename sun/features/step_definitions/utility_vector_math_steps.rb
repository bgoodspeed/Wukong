
Given /^we import vector math on arrays$/ do
  #NOOP
end



def to_vector(vs)
  return vs if vs.kind_of? Array
  vals = vs.split(",").collect {|v| v.to_f }
  GVector.xy(vals[0], vals[1])
end

class Array
  def near?(expected, max_delta = 0.005)
    BeNear.new(max_delta).of(expected).matches?(self)
  end
end

class GVector
  def near?(expected, max_delta = 0.005)
    BeNearGV.new(max_delta).of(expected).matches?(self)
  end
end

class BeNear
  def initialize(max_delta)
    @max_delta = max_delta
  end
  def of(expected)
    @expected = expected
    self
  end
  def matches?(target)
    @target = target
    raise "size mismatch" unless @target.size == @expected.size
    @target.each_with_index do |v, idx|
      if (v - @expected[idx]).abs > @max_delta
        #puts failure_message_for_should #TODO sort this error reporting vs utility issue out
        return false
      end
      
    end
    true
  end
    def failure_message_for_should
    "expected #{@target.inspect} to be within #{@max_delta} of #{@expected}"
  end
  def failure_message_for_should_not
    "expected #{@target.inspect} not to be within #{@max_delta} of #{@expected}"
  end
end
class BeNearGV
  def initialize(max_delta)
    @max_delta = max_delta
  end
  def of(expected)
    @expected = expected
    self
  end
  def matches?(target)
    @target = target
    ((target.x - @expected.x).abs < @max_delta) && ((target.y - @expected.y).abs < @max_delta)
  end
    def failure_message_for_should
    "expected #{@target.inspect} to be within #{@max_delta} of #{@expected}"
  end
  def failure_message_for_should_not
    "expected #{@target.inspect} not to be within #{@max_delta} of #{@expected}"
  end
end

class Float
  def near?(other, max_delta=0.005)
    cond = (self - other).abs > max_delta
    puts "expected s=#{self} to be within #{max_delta} of o=#{other}" if cond

    !cond
  end
end
class Fixnum
  def near?(other, max_delta=0.005)
    cond = (self - other).abs > max_delta
    puts "expected s=#{self} to be within #{max_delta} of o=#{other}" if cond

    !cond
  end
end

#class Float
#  def be_near(delta)
#    BeNear.new(delta)
#  end
#  def close_to?(other, max_delta = 0.005)
#    self.should be_near(max_delta).of(other)
#  end
#end

Then /^I should be able to add the following vectors$/ do |table|
  table.map_column!('vector1') { |vs| to_vector(vs) }
  table.map_column!('vector2') { |vs| to_vector(vs) }
  table.map_column!('expected_sum') { |vs| to_vector(vs) }
  table.hashes.each {|hash|
    v1 = hash['vector1']
    v2 = hash['vector2']
    expected = hash['expected_sum']
    sum = v1.plus(v2)
    sum.should be_near(expected)
  }

end

Then /^I should be able to subtract the following vectors$/ do |table|
  table.map_column!('vector1') { |vs| to_vector(vs) }
  table.map_column!('vector2') { |vs| to_vector(vs) }
  table.map_column!('expected_difference') { |vs| to_vector(vs) }
  table.hashes.each {|hash|
    v1 = hash['vector1']
    v2 = hash['vector2']
    expected = hash['expected_difference']
    diff = v1.minus(v2)
    diff.should be_near(expected)
  }

end


Then /^I should be able to take the dot product of the following vectors$/ do |table|
  table.map_column!('vector1') { |vs| to_vector(vs) }
  table.map_column!('vector2') { |vs| to_vector(vs) }
  table.map_column!('expected_dot_product') { |vs| vs.to_f }
  table.hashes.each {|hash|
    v1 = hash['vector1']
    v2 = hash['vector2']
    expected = hash['expected_dot_product']
    diff = v1.dot(v2)
    diff.should be_near(expected)
  }

end

Then /^I should be able to get distance between two vectors$/ do |table|
  table.map_column!('vector1') { |vs| to_vector(vs) }
  table.map_column!('vector2') { |vs| to_vector(vs) }
  table.map_column!('expected_distance') { |vs| vs.to_f }
  table.hashes.each {|hash|
    v1 = hash['vector1']
    v2 = hash['vector2']
    expected = hash['expected_distance']
    diff = v1.distance_from(v2)
    diff.should be_near(expected)
  }
end

Then /^I should be able to get the length of the following vectors$/ do |table|
  table.map_column!('vector') { |vs| to_vector(vs) }
  table.map_column!('expected_length') { |vs| vs.to_f }
  table.hashes.each {|hash|
    v = hash['vector']
    expected = hash['expected_length']
    diff = v.norm
    diff.should be_near(expected)
  }
end

Then /^I should be able to get the unit of the following vectors$/ do |table|
  table.map_column!('vector') { |vs| to_vector(vs) }
  table.map_column!('expected_unit') { |vs| to_vector(vs) }
  table.hashes.each {|hash|
    v = hash['vector']
    expected = hash['expected_unit']
    unit = v.unit
    unit.should be_near(expected)
  }

end

include PrimitiveIntersectionTests

def to_circle(str)
  return str if str.kind_of? Primitives::Circle
  pos_rad = str.split(":")

  pos = to_vector(pos_rad.first)
  radius = pos_rad.last.to_f
  Primitives::Circle.new(pos, radius)
end
def to_line_segment(str)
  return str if str.kind_of? Primitives::LineSegment
  p1p2 = str.split(":")
  p1 = to_vector(p1p2.first)
  p2 = to_vector(p1p2.last)
  Primitives::LineSegment.new(p1, p2)
end

def to_rectangle(str)
  return str if str.kind_of? Primitives::Rectangle
  pts = str.split(":")
  pts.collect!{|v| to_vector(v) }
  Primitives::Rectangle.new(pts[0], pts[1], pts[2], pts[3])
end
def to_bool(str)
  str.kind_of?(String) ? eval(str) : str
end
def to_triangle(str)
  return str if str.kind_of? Primitives::Triangle
  pts = str.split(":")
  pts.collect!{|v| to_vector(v) }
  Primitives::Triangle.new(pts[0], pts[1], pts[2])
end

Then /^I should be able to test intersection of the following circles$/ do |table|
  table.map_column!('circle1') { |vs| to_circle(vs) }
  table.map_column!('circle2') { |vs| to_circle(vs) }
  table.map_column!('intersects?') { |vs| to_bool(vs) }
  table.hashes.each {|hash|
    c1 = hash['circle1']
    c2 = hash['circle2']
    expected = hash['intersects?']
    rv = circle_circle_intersection?(c1, c2)
    rv.should ==(expected)
  }
end


Then /^I should be able to test intersection of the following circles and line segments$/ do |table|
  table.map_column!('circle') { |vs| to_circle(vs) }
  table.map_column!('line_segment') { |vs| to_line_segment(vs) }
  table.map_column!('intersects?') { |vs| to_bool(vs) }
  table.hashes.each {|hash|
    c = hash['circle']
    ls = hash['line_segment']
    expected = hash['intersects?']
    rv = circle_line_segment_intersection?(c, ls)
    rv.should(be(expected), "Expected circle #{c} and line seg #{ls} intersect test to be #{expected}")
  }
end

Then /^I should be able to test intersection of the following circles and points$/ do |table|
  table.map_column!('circle') { |vs| to_circle(vs) }
  table.map_column!('point') { |vs| to_vector(vs) }
  table.map_column!('intersects?') { |vs| to_bool(vs) }
  table.hashes.each {|hash|
    c = hash['circle']
    p = hash['point']
    expected = hash['intersects?']
    rv = circle_point_intersection?(c, p)
    rv.should(be(expected), "Expected #{c} and #{p} intersect test to be #{expected}")
  }
end

Then /^I should be able to test intersection of the following circles and rectangles$/ do |table|
  table.map_column!('circle') { |vs| to_circle(vs) }
  table.map_column!('rectangle') { |vs| to_rectangle(vs) }
  table.map_column!('intersects?') { |vs| to_bool(vs) }
  table.hashes.each {|hash|
    c = hash['circle']
    r = hash['rectangle']
    expected = hash['intersects?']
    rv = circle_rectangle_intersection?(c, r)
    rv.should(be(expected), "Expected #{c} and #{r} intersect test to be #{expected}")
  }

end

Then /^I should be able to test intersection of the following circles and triangles$/ do |table|
  table.map_column!('circle') { |vs| to_circle(vs) }
  table.map_column!('triangle') { |vs| to_triangle(vs) }
  table.map_column!('intersects?') { |vs| to_bool(vs) }
  table.hashes.each {|hash|
    c = hash['circle']
    t = hash['triangle']
    expected = hash['intersects?']
    rv = circle_triangle_intersection?(c, t)
    rv.should(be(expected), "Expected #{c} and #{t} intersect test to be #{expected}")
  }

end

Then /^I should be able to test intersection of the following rectangles$/ do |table|
  table.map_column!('rectangle1') { |vs| to_rectangle(vs) }
  table.map_column!('rectangle2') { |vs| to_rectangle(vs) }
  table.map_column!('intersects?') { |vs| to_bool(vs) }
  table.hashes.each {|hash|
    r1 = hash['rectangle1']
    r2 = hash['rectangle2']
    expected = hash['intersects?']
    rv = rectangle_rectangle_intersection?(r1, r2)
    rv.should(be(expected), "Expected #{r1} and #{r2} intersect test to be #{expected}")
  }

end


Then /^I should be able to get the left right top and bottom values for these rectangles$/ do |table|
  table.map_column!('rectangle') { |vs| to_rectangle(vs) }
  table.map_column!('left') { |vs| vs.to_f }
  table.map_column!('right') { |vs| vs.to_f }
  table.map_column!('top') { |vs| vs.to_f }
  table.map_column!('bottom') { |vs| vs.to_f }

  table.hashes.each {|hash|
    rect = hash['rectangle']
    l = hash['left']
    r = hash['right']
    t = hash['top']
    b = hash['bottom']
    
    rect.left.should == l
    rect.right.should == r
    rect.top.should == t
    rect.bottom.should == b
  }

end

Then /^I should be able to test intersection of the following rectangles and points$/ do |table|
  table.map_column!('rectangle') { |vs| to_rectangle(vs) }
  table.map_column!('point') { |vs| to_vector(vs) }
  table.map_column!('intersects?') { |vs| to_bool(vs) }
  table.hashes.each {|hash|
    r = hash['rectangle']
    p = hash['point']
    expected = hash['intersects?']
    rv = rectangle_point_intersection?(r, p)
    rv.should(be(expected), "Expected #{r} and #{p} intersect test to be #{expected}")
  }

end



Then /^I should be able to test intersection of the following rectangles and line segments$/ do |table|
  table.map_column!('rectangle') { |vs| to_rectangle(vs) }
  table.map_column!('line_segment') { |vs| to_line_segment(vs) }
  table.map_column!('intersects?') { |vs| to_bool(vs) }
  table.hashes.each {|hash|
    r = hash['rectangle']
    ls = hash['line_segment']
    expected = hash['intersects?']
    rv = rectangle_line_segment_intersection?(r, ls)
    rv.should(be(expected), "Expected #{r} and #{ls} intersect test to be #{expected}")
  }

end

Then /^I should be able to test intersection of the following line segments$/ do |table|
  table.map_column!('line_segment1') { |vs| to_line_segment(vs) }
  table.map_column!('line_segment2') { |vs| to_line_segment(vs) }
  table.map_column!('intersects?') { |vs| to_bool(vs) }
  table.hashes.each {|hash|
    ls1 = hash['line_segment1']
    ls2 = hash['line_segment2']
    expected = hash['intersects?']
    rv = line_segment_line_segment_intersection?(ls1, ls2)
    rv.should(be(expected), "Expected #{ls1} and #{ls2} intersect test to be #{expected}")
  }
end
