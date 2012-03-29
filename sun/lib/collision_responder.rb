# To change this template, choose Tools | Templates
# and open the template in the editor.



class CollisionResponder

  def initialize(game)
    @game = game
  end


  def responses
    {
      :damaging1 => lambda {|col| col.dynamic1.take_damage(col.dynamic2)},
      :damaging2 => lambda {|col| col.dynamic2.take_damage(col.dynamic1)},
      :removing2 => lambda {|col| @game.remove_projectile(col.dynamic2)},
      :blocking1 => lambda {|col| col.dynamic1.undo_last_move},
      :blocking2 => lambda {|col| col.dynamic2.undo_last_move},
      :trigger_event1 => lambda {|col| col.dynamic1.trigger},
    }
  end

  #TODO get rid of the distinction between static and dynamic
  def static_response(col)
    m = {
      EventEmitter => {
        Player => [:trigger_event1]
      },
      Primitives::LineSegment => {
        Player => [:blocking2],
        VectorFollower => [:removing2],
        Enemy => [:blocking2]
      },
      Enemy => {
        Primitives::LineSegment => [:blocking1]
      }
    }

    raise "unknown static base response type: #{col.static.collision_type}" unless m.has_key? col.static.collision_type
    raise "unknown static secondary response type: #{col.dynamic.collision_type}, primary is #{col.static.collision_type}" unless m[col.static.collision_type].has_key? col.dynamic.collision_type
    m[col.dynamic1.collision_type][col.dynamic2.collision_type]

  end

  #TODO sort collision types?
  def dynamic_response(col)
    m = {
      Enemy => {
        VectorFollower => [:damaging1, :removing2],
        Primitives::LineSegment => [:blocking1]
      },
      Player => {
        VectorFollower => [],
        Enemy => [:damaging1, :damaging2, :blocking1]
      },
      Primitives::LineSegment => {
        Enemy => [:blocking2]
      }

    }
    raise "unknown dynamic base response type: #{col.dynamic1.collision_type}" unless m.has_key? col.dynamic1.collision_type
    raise "unknown dynamic secondary response type: #{col.dynamic2.collision_type}, primary is #{col.dynamic1.collision_type}" unless m[col.dynamic1.collision_type].has_key? col.dynamic2.collision_type
    m[col.dynamic1.collision_type][col.dynamic2.collision_type]
  end
  def handle_collisions(collisions)
    collisions.each {|col|
      if col.class == StaticCollision
        static_response(col).each do |response|
          responses[response].call(col)
        end
      else
        dynamic_response(col).each do |response|
          responses[response].call(col)
        end
      end
    }
  end
end
