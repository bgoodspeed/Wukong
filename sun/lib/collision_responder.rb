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

  #TODO sort collision types?
  def dynamic_response(col)
    m = {
      Enemy => {
        VectorFollower => lambda  do |col|
          col.dynamic1.take_damage(col.dynamic2)
          @game.remove_projectile(col.dynamic2)
        end
      },
      Player => {
        VectorFollower => lambda  do |col|
          #TODO track the shooter of projectiles
          # puts "player shot self #{col.dynamic1} by projectile #{col.dynamic2}"
        end,
        Enemy => lambda do |c|
          c.dynamic1.undo_last_move
          c.dynamic1.take_damage(c.dynamic2)
          c.dynamic2.take_damage(c.dynamic1)
        end
      }


    }
    raise "unknown base response type: #{col.dynamic1.class}" unless m.has_key? col.dynamic1.class
    raise "unknown secondary response type: #{col.dynamic2.class}, primary is #{col.dynamic1.class}" unless m[col.dynamic1.class].has_key? col.dynamic2.class
    m[col.dynamic1.class][col.dynamic2.class]
  end
  def handle_collisions(collisions)
    collisions.each {|col|
      if col.class == StaticCollision
        response_by_class(col.dynamic).call(col)
      else
        dynamic_response(col).call(col)
      end
    }
  end
end
