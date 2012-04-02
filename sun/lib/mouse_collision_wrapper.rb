 
#TODO reconsider this design

class MouseCollisionWrapper
  attr_reader :position, :radius 
  def initialize(game, pos, r = 5)
    @game = game
    @position = pos
    @radius = r
  end

  def collision_type
    self.class
  end
  def collision_radius
    @radius
  end
  def collision_center
    @position
  end
end
