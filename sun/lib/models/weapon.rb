
class Weapon
  ATTRIBUTES = [:swing_start , :swing_sweep ,  :swing_frames, :weapon_length,
    :image_path, :type, :sound_effect_name, :velocity, :equipped_on, 
    :orig_filename, :animation_name, :collision_priority, :display_name,
    :equipment_image_path
  ]
  ATTRIBUTES.each {|attr| attr_accessor attr }
  attr_accessor :in_use
  attr_accessor :inventory_type, :stats
  extend YamlHelper

  alias_method :display_text, :display_name
  def self.defaults
    {
        'stats' => {

        }
    }
  end
  def initialize(game, image, conf_in={})
    conf = self.class.defaults.merge(conf_in)
    @image_path = image
    @swing_start = 0
    @swing_sweep = 0
    @swing_frames = 10
    @current_frame = 0
    @weapon_length = 10
    @collision_priority = CollisionPriority::HIGH
    @velocity = 10
    @type = "swung"
    @game = game
    @inventory_type = InventoryTypes::WEAPON
    cf = conf['stats'] ? conf['stats'] : {}
    @stats = Stats.new(cf)
    @animation_name = "weapon"
    @sound_effect_name = "unset"
  end
  

  def effective_stats
    @stats
  end


  def use
    @current_frame = 0
    owner = @equipped_on
    if @type == "swung"
      te = TimedEvent.new("noop", nil, "stop_weapon", @equipped_on, @swing_frames)
      @game.clock.enqueue_event("stop_swing", te)
      @game.level.add_weapon(self)

    else
      @game.add_projectile(@equipped_on, owner.position, owner.direction, @velocity)
    end

    @game.play_effect(@sound_effect_name)
  end
  def inactivate
    @in_use = false
    @game.level.remove_weapon(self)
  end

  def in_use?
    @in_use
  end

  def vector_to_weapon_tip
    tmp = GVector.xy(0,0) #NOTE temporary vector allocation
    GVector.xy(calculate_offset_x(@equipped_on.direction, @weapon_length), calculate_offset_y(@equipped_on.direction, @weapon_length)).scale(tmp, @weapon_length)
    tmp
  end
  include GraphicsApi
  include Collidable
  #TODO all this collision stuff is for swung weapons only.. might be confusing?
  def to_collision
    mv = vector_to_weapon_tip
    p = @equipped_on.position
    tmp = GVector.xy(0,0) #NOTE temporary vector allocation
    p.plus(tmp, mv)
    Primitives::LineSegment.new(p, tmp)
  end

  def collision_radius
    @weapon_length
  end
  def collision_center
    tmp = GVector.xy(0,0) #NOTE temporary vector allocation
    @equipped_on.position.plus(tmp, vector_to_weapon_tip)
    tmp
  end

end
