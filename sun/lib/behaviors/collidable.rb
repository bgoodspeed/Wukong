# To change this template, choose Tools | Templates
# and open the template in the editor.

module Collidable
  def collision_response_type
    self.class
  end
  #TODO use strings/enums/symbols for collision types not classes, make these first class values
  def collision_type
    to_collision.class
  end

  def collision_radius
    to_collision.radius
  end
  def collision_center
    to_collision.position
  end
  def to_collision
    @collision_type.position = @position
    @collision_type
  end



end
