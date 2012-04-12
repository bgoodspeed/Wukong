
class Enemy

  attr_accessor :tracking_target
  ATTRIBUTES = [:position, :health, :velocity, :name]
  ATTRIBUTES.each {|attr| attr_accessor attr }

  extend YamlHelper

  #TODO make YAML utils and pass attributes
  def self.from_yaml(game, yaml)
    data = YAML.load(yaml)
    conf = data['enemy']
    obj = Enemy.new(conf['image_path'], game)
    process_attributes(ATTRIBUTES, obj, conf)
    obj
  end


  attr_reader :image_file, :direction
  def initialize(enemy_avatar, game)
    @game = game
    @image_file = enemy_avatar
    @enemy_avatar = @game.image_manager.register_image(enemy_avatar)
    p = [@enemy_avatar.width/2.0, @enemy_avatar.height/2.0 ]
    @radius = p.max
    @health = 15
    @position = p
    @col = Primitives::Circle.new(@position, @radius)
    @velocity = 5
    @direction = 0
  end

  def undo_last_move
    unless @last_move.nil?
      @position = @position.minus @last_move
      @last_move = nil
    end
  end


  #TODO hackish
  def hud_message
    "Enemy : #{@health}HP"
  end
  #TODO use strings/enums/symbols for collision types not classes, make these first class values
  def collision_type
    to_collision.class
  end

  def to_collision
    @col.position = @position
    @col
  end
  def collision_radius
    to_collision.radius
  end
  def collision_center
    to_collision.position
  end

  def collision_response_type
    self.class
  end

  #TODO this should be in a module
  def dead?
    @health <= 0
  end
  #TODO this should be in a module 
  def take_damage(from)
    @health -= 1
    if dead?
      @game.add_event(Event.new(self, EventTypes::DEATH))
    end
  end

  def tick_tracking(vector)
    @last_move = vector.scale(@velocity)
    @position = @position.plus(@last_move)
  end

  def to_s
    "#{self.class} #{collision_type} r=#{collision_radius} c=#{collision_center}"
  end
end