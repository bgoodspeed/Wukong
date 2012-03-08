
class Enemy

  attr_accessor :position

  def initialize(enemy_avatar, window)
    @enemy_avatar = Gosu::Image.new(window, enemy_avatar, false)
    p = [@enemy_avatar.width/2.0, @enemy_avatar.height/2.0 ]
    @radius = p.max

    @position = [0,0]
  end

  def draw(screen)
    @enemy_avatar.draw(@position[0], @position[1],1)
  end

  def collision_type
    Enemy
  end
  def collision_radius
    @radius
  end
  def collision_center
    @position
  end

  #TODO this should be in a module 
  def take_damage(from)
    #TODO puts "use #{from} to calculate enemy damage"
  end
end