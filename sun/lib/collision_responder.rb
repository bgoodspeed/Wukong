# To change this template, choose Tools | Templates
# and open the template in the editor.



class CollisionResponder

  def initialize(game)
    @game = game
  end

  def response_by_class(d)

    m = {
      Player => lambda {|col| 
        col.dynamic.undo_last_move},
      Enemy => lambda {|col| col.dynamic.undo_last_move},
      VectorFollower => lambda {|col| @game.remove_projectile(col.dynamic)},
    }
    raise "unknown how to respond to collision with #{d}" unless m.has_key?(d.class)
    m[d.class]
  end

  def responses
    {
      :damaging1 => lambda {|col| col.dynamic1.take_damage(col.dynamic2)},
      :damaging2 => lambda {|col| col.dynamic2.take_damage(col.dynamic1)},
      :removing2 => lambda {|col| @game.remove_projectile(col.dynamic2)},
      :blocking1 => lambda {|col| col.dynamic1.undo_last_move},
    }
  end

  #TODO sort collision types?
  def dynamic_response(col)
    m = {
      Enemy => {
        VectorFollower => [:damaging1, :removing2]
      },
      Player => {
        VectorFollower => [],
        Enemy => [:damaging1, :damaging2, :blocking1]
      }


    }
    raise "unknown base response type: #{col.dynamic1.collision_type}" unless m.has_key? col.dynamic1.collision_type
    raise "unknown secondary response type: #{col.dynamic2.collision_type}, primary is #{col.dynamic1.collision_type}" unless m[col.dynamic1.collision_type].has_key? col.dynamic2.collision_type
    m[col.dynamic1.collision_type][col.dynamic2.collision_type]
  end
  def handle_collisions(collisions)
    collisions.each {|col|
      if col.class == StaticCollision
        response_by_class(col.dynamic).call(col)
      else
        dynamic_response(col).each do |response|
          responses[response].call(col)
        end
      end
    }
  end
end
