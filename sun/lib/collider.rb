
class Collider
  def initialize
    @config = {
      Primitives::Circle => {
        Primitives::Circle => lambda {|a,b| circle_circle_intersection?(a.to_collision, b.to_collision)},
        Primitives::LineSegment => lambda {|a,b| circle_line_segment_intersection?(a.to_collision, b.to_collision)},
      },
      Primitives::LineSegment => {
        Primitives::LineSegment => lambda {|a, b| line_segment_line_segment_intersection?(a.to_collision, b.to_collision)},
      },
      VectorFollower => {
        Primitives::LineSegment => lambda {|a,b| puts "vf vs lineseg"}
      },
      #TODO these should use primitives
      Player => {
        Primitives::LineSegment => lambda {|a,b| circle_line_segment_intersection?(a.to_collision, b.to_collision)},
        Enemy => lambda {|a,b| puts "player vs enemy"},
        EventEmitter => lambda {|a,b| puts "player vs event emitter"},
        Primitives::Circle => lambda {|a,b| puts "player vs circle #{a} vs #{b}"},
        VectorFollower => lambda {|a,b| puts "player vs vf"}
      },
      Enemy => {
        Primitives::LineSegment => lambda {|a,b| puts "enemy vs lineseg"}
      }
    }
  end
  def check_for_collision_by_type(a,b)
    raise "collider: error unknown base type #{a.collision_type} -> #{a}" unless @config.has_key?(a.collision_type)
    raise "collider: error unknown secondary type #{b.collision_type} -> #{b}, primary is #{a.collision_type}" unless @config[a.collision_type].has_key?(b.collision_type)
    @config[a.collision_type][b.collision_type].call(a,b)
  end
end
