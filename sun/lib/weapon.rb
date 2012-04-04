# To change this template, choose Tools | Templates
# and open the template in the editor.


class Weapon
  ATTRIBUTES = [:swing_start , :swing_sweep ,  :swing_frames,
    :image_path, :type, :sound_effect_name, :velocity]
  ATTRIBUTES.each {|attr| attr_accessor attr }

  extend YamlHelper

  #TODO make YAML utils and pass attributes
  def self.from_yaml(game, yaml)
    data = YAML.load(yaml)
    w = data['weapon']
    weapon = Weapon.new(game, nil)
    process_attributes(ATTRIBUTES, weapon, w)
    weapon
  end

  def initialize(game, image)
    @image_path = image
    @swing_start = 0
    @swing_sweep = 0
    @swing_frames = 0
    @velocity = 10
    @type = "swung"
    @game = game
    @sound_effect_name = "unset"
  end

  def use
    unless @in_use

      p = @game.player
      @game.add_projectile(p.position, p.direction, @velocity) unless @type == "swung"
      @game.play_effect(@sound_effect_name)
    end
    @in_use = true
  end
  def inactivate
    @in_use = false
  end

  def in_use?
    @in_use
  end
end
