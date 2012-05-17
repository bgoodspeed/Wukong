


class Collider
  def initialize
    @config = {
      "Circle" => {
        "Circle" => lambda {|a,b| circle_circle_intersection?(a.to_collision, b.to_collision)},
        "LineSegment" => lambda {|a,b| circle_line_segment_intersection?(a.to_collision, b.to_collision)},
        "Rectangle" => lambda {|a,b| circle_rectangle_intersection?(a.to_collision, b.to_collision)},
      },
      "LineSegment" => {
        "LineSegment" => lambda {|a, b| line_segment_line_segment_intersection?(a.to_collision, b.to_collision)},
        "Circle" => lambda {|a,b| circle_line_segment_intersection?(b.to_collision, a.to_collision)},
        "Rectangle" => lambda {|a,b| rectangle_line_segment_intersection?(b.to_collision, a.to_collision)},
      },
    }
  end
  def check_for_collision_by_type(a,b)
    #TODO refine and elaborate this notion, declare collidable types, etc
    return false if a.class == b.class
    raise "collider: error unknown base type #{a.collision_type} -> #{a}" unless @config.has_key?(a.collision_type)
    raise "collider: error unknown secondary type #{b.collision_type} -> #{b}, primary is #{a.collision_type}" unless @config[a.collision_type].has_key?(b.collision_type)
    @config[a.collision_type][b.collision_type].call(a,b)
  end
end
