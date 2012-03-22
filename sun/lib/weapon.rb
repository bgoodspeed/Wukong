# To change this template, choose Tools | Templates
# and open the template in the editor.

class Weapon
  attr_accessor :swing_start , :swing_sweep ,  :swing_frames, :image_path, :type, :sound_effect_name

  def initialize(game, image)
    @image_path = image
    @swing_start = 0
    @swing_sweep = 0
    @swing_frames = 0
    @type = "swung"
    @game = game
  end

  def use
    unless @in_use

      #TODO use weapon-specific velocity
      p = @game.player
      @game.add_projectile(p.position, p.direction, 10) unless @type == "swung"
      @game.play_effect(@sound_effect_name)
    end
    @in_use = true
  end
  def inactivate
    @in_use = false
  end
  #TODO bad fit, this shouldn't have to care about drawing, things are not being composed correctly
  def draw
  
    # puts "draw weapon based on frame, swing start, player offset etc"
  end

  def in_use?
    @in_use
  end
end
