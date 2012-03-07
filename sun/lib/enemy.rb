
class Enemy

  attr_reader :position

  def initialize(enemy_avatar, window)
    @enemy_avatar = Gosu::Image.new(window, enemy_avatar, false)
    @position = [0,0]
    puts "Enemy_avatar path: #{enemy_avatar}"
  end

  def draw(screen)
    @enemy_avatar.draw(@position[0], @position[1],1)
  end
end