# To change this template, choose Tools | Templates
# and open the template in the editor.


class Weapon
  ATTRIBUTES = [:swing_start , :swing_sweep ,  :swing_frames, :weapon_length,
    :image_path, :type, :sound_effect_name, :velocity, :equipped_on]
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
    @swing_frames = 10
    @current_frame = 0
    @weapon_length = 10
    @velocity = 10
    @type = "swung"
    @game = game
    @sound_effect_name = "unset"
  end


  def use
    unless @in_use
      @current_frame = 0
      p = @game.player
      if @type == "swung"
        te = TimedEvent.new("noop", nil, "stop_weapon", @equipped_on, @swing_frames)
        @game.clock.enqueue_event("stop_swing", te)
        @game.level.add_weapon(self)

      else
        @game.add_projectile(p.position, p.direction, @velocity)
      end
      
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

  def vector_to_weapon_tip
    [calculate_offset_x(@equipped_on.direction, @weapon_length), calculate_offset_y(@equipped_on.direction, @weapon_length)]
  end
  include GraphicsApi
  #TODO all this collision stuff is for swung weapons only.. might be confusing?
  def to_collision
    mv = vector_to_weapon_tip

    p = @equipped_on.position
    Primitives::LineSegment.new(p, p.plus(mv))
  end

  def collision_type
    to_collision.class
  end
  def collision_radius
    @weapon_length
  end
  def collision_center
    @equipped_on.position.plus(vector_to_weapon_tip.scale(0.5))
  end
  def collision_response_type
    self.class
  end
end
