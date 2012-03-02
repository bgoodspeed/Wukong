# To change this template, choose Tools | Templates
# and open the template in the editor.

class CollisionResponder

  def initialize(game)
    @game = game
  end
  def handle_collisions(collisions)
    collisions.each {|col| col.dynamic.undo_last_move}
  end
end
