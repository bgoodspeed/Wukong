# To change this template, choose Tools | Templates
# and open the template in the editor.

class CollisionResponder

  def initialize(game)
    @game = game
  end

  def response_by_class(d)
    m = {
      Player => lambda {|col| col.dynamic.undo_last_move},
      VectorFollower => lambda {|col| @game.remove_projectile(col.dynamic)},
    }
    raise "unknown how to respond to collision with #{d}" unless m.has_key?(d.class)
    m[d.class]
  end
  def handle_collisions(collisions)
    collisions.each {|col| response_by_class(col.dynamic).call(col)}
  end
end
