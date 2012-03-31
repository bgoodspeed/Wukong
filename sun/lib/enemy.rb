
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

  def self.from_file(game, f)
    self.from_yaml(game, IO.readlines(f).join(""))
  end
  def initialize(enemy_avatar, game)
    @game = game
    @enemy_avatar = Gosu::Image.new(@game.window, enemy_avatar, false)
    p = [@enemy_avatar.width/2.0, @enemy_avatar.height/2.0 ]
    @radius = p.max
    @health = 15
    @position = p
    @velocity = 5
    @direction = 0
  end

  def undo_last_move
    unless @last_move.nil?
      @position = @position.minus @last_move
      @last_move = nil
    end
  end

  #TODO clean this up
  include UtilityDrawing
  def draw(screen)
    coords = @game.camera.screen_coordinates_for(@position)
    @enemy_avatar.draw_rot(coords[0] , coords[1] , ZOrder.dynamic.value, @direction)
  end


  #TODO hackish
  def hud_message
    "Enemy : #{@health}HP"
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

  def dead?
    @health <= 0
  end
  #TODO this should be in a module 
  def take_damage(from)
    @health -= 1
    if dead?
      @game.add_death_event(self)
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