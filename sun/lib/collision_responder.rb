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

  def self.from_yaml(game, yaml)
    data = YAML.load(yaml)
    conf = data['collision_response']
    cr = {}
    conf.each {|type1,type2c|
      t1 = eval(type1)
      cr[t1] = {} unless cr.has_key?(t1)
      type2c.each {|type2, r|
        t2 = eval(type2)
        cr[t1][t2] = r
      }
    }

    obj = CollisionResponder.new(game, cr)

    obj
  end

  def self.from_file(game, f)
    self.from_yaml(game, IO.readlines(f).join(""))
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


  #TODO Action Manager could hold this
  def responses
    {
      :damaging1 => lambda {|col| col.dynamic1.take_damage(col.dynamic2)},
      :damaging2 => lambda {|col| col.dynamic2.take_damage(col.dynamic1)},
      :removing1 => lambda {|col| @game.remove_projectile(col.dynamic1)},
      :removing2 => lambda {|col| @game.remove_projectile(col.dynamic2)},
      :blocking1 => lambda {|col| col.dynamic1.undo_last_move},
      :blocking2 => lambda {|col| col.dynamic2.undo_last_move},
      :trigger_event1 => lambda {|col| col.dynamic1.trigger},
      :trigger_event2 => lambda {|col| col.dynamic2.trigger},
      :mouse_pick1 => lambda {|col| 
        @game.remove_mouse_collision #TODO could also add a timed event here add a highlight around that enemy?
        @game.add_event(PickEvent.new(@game, col.dynamic1))},
      #TODO sort of exploratory here, extract params, cleanup etc
      :temporary_message1 => lambda {|col| @game.clock.enqueue_event("message", TimedEvent.new("temporary_message=", col.dynamic1.hud_message,"temporary_message=", nil, 60 )) }
    }
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
