# To change this template, choose Tools | Templates
# and open the template in the editor.

module ResponseTypes
  TRIGGER_EVENT1 = :trigger_event1
  TRIGGER_EVENT2 = :trigger_event2
  BLOCKING1 = :blocking1
  BLOCKING2 = :blocking2
  REMOVING1 = :removing1
  REMOVING2 = :removing2
  DAMAGING1 = :damaging1
  DAMAGING2 = :damaging2
  MOUSE_PICK1 = :mouse_pick1
  TEMPORARY_MESSAGE1 = :temporary_message1
end

class Collision
  attr_reader :dynamic1, :dynamic2
  def initialize(dynamic, dynamic2)
    @dynamic1 = dynamic
    @dynamic2 = dynamic2
  end
  def collision_priority
    @dynamic1.collision_priority + @dynamic2.collision_priority
  end
  alias_method :static, :dynamic1
  alias_method :dynamic, :dynamic2
end


class CollisionResponseController
  extend YamlHelper
  def self.from_yaml(game, yaml, f=nil)
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

    obj = CollisionResponseController.new(game, cr)

    obj
  end


  def self.default_config
    {
      EventEmitter => {
        Player => [ResponseTypes::TRIGGER_EVENT1]
      },
      Weapon => {
        Primitives::LineSegment => []
      },
      Primitives::LineSegment => {
        Player => [ResponseTypes::BLOCKING2],
        VectorFollower => [ResponseTypes::REMOVING2],
        Enemy => [ResponseTypes::BLOCKING2]
      },
      Enemy => {
        Enemy => [],
        VectorFollower => [ResponseTypes::DAMAGING1, ResponseTypes::REMOVING2],
        Primitives::LineSegment => [ResponseTypes::BLOCKING1],
        MouseCollisionWrapper => [ResponseTypes::MOUSE_PICK1],
        Weapon => [ResponseTypes::DAMAGING1]
      },
      VectorFollower => {
        Player => [],
        Enemy => [ResponseTypes::DAMAGING2, ResponseTypes::REMOVING1],
        Primitives::LineSegment => [ResponseTypes::REMOVING1]
      },
      Player => {
        Primitives::LineSegment => [ResponseTypes::BLOCKING1],
        VectorFollower => [], #TODO unrealistic
        Enemy => [ResponseTypes::DAMAGING1, ResponseTypes::DAMAGING2, ResponseTypes::BLOCKING1],
        EventEmitter => [ResponseTypes::TRIGGER_EVENT2],
        MouseCollisionWrapper => [ResponseTypes::MOUSE_PICK1],
        Weapon => [], #TODO unrealistic
      },
    }
  end
  def initialize(game, config=CollisionResponseController.default_config)
    @game = game
    @config = config
  end


  def responses
    @game.action_controller.collision_responses
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
          responses[response].call(@game, col)
        end
    }
  end
end
