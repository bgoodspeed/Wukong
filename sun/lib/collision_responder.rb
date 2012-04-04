# To change this template, choose Tools | Templates
# and open the template in the editor.

class Collision
  attr_reader :dynamic1, :dynamic2
  def initialize(dynamic, dynamic2)
    @dynamic1 = dynamic
    @dynamic2 = dynamic2
  end
  alias_method :static, :dynamic1
  alias_method :dynamic, :dynamic2
end


class CollisionResponder
  extend YamlHelper
  def self.from_yaml(game, yaml)
    data = YAML.load(yaml)
    conf = data['collision_response']
    cr = {}
    conf.each {|type1,type2c|
      t1 = eval(type1)
      cr[t1] = {} unless cr.has_key?(t1)
      type2c.each {|type2, r|
        t2 = eval(type2)
        rs = r.collect {|e| e.to_sym}
        cr[t1][t2] = rs
      }
    }

    obj = CollisionResponder.new(game, cr)

    obj
  end


  def self.default_config
    {
      EventEmitter => {
        Player => [:trigger_event1]
      },
      Primitives::LineSegment => {
        Player => [:blocking2],
        VectorFollower => [:removing2],
        Enemy => [:blocking2]
      },
      Enemy => {
        Enemy => [],
        VectorFollower => [:damaging1, :removing2],
        Primitives::LineSegment => [:blocking1],
        MouseCollisionWrapper => [:mouse_pick1]
      },
      VectorFollower => {
        Player => [],
        Enemy => [:damaging2, :removing1],
        Primitives::LineSegment => [:removing1]
      },
      Player => {
        Primitives::LineSegment => [:blocking1],
        VectorFollower => [],
        Enemy => [:damaging1, :damaging2, :blocking1],
        EventEmitter => [:trigger_event2],
        MouseCollisionWrapper => [:mouse_pick1]
      },
    }
  end
  def initialize(game, config=CollisionResponder.default_config)
    @game = game
    @config = config
  end


  def responses
    @game.action_manager.collision_responses
  end

  def response(col)
    m = @config
    raise "collision: unknown base response type: #{col.dynamic1.collision_response_type}" unless m.has_key? col.dynamic1.collision_response_type
    raise "collision: unknown secondary response type: #{col.dynamic2.collision_response_type}, primary is #{col.dynamic1.collision_response_type}" unless m[col.dynamic1.collision_response_type].has_key? col.dynamic2.collision_response_type
    m[col.dynamic1.collision_response_type][col.dynamic2.collision_response_type]
  end
  
  def handle_collisions(collisions)
    collisions.each {|col|
        response(col).each do |response|
          responses[response].call(col)
        end
    }
  end
end
