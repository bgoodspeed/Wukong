# To change this template, choose Tools | Templates
# and open the template in the editor.

class Weapon
  attr_accessor :swing_start , :swing_sweep ,  :swing_frames, :image_path

  def initialize(game, image)
    @image_path = image
    @swing_start = 0
    @swing_sweep = 0
    @swing_frames = 0
  end

  def use
    @in_use = true
  end
  
  #TODO bad fit, this shouldn't have to care about drawing, things are not being composed correctly
  def draw

    # puts "draw weapon based on frame, swing start, player offset etc"
  end

  def in_use?
    @in_use
  end
end
