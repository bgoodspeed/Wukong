
class Enemy

  attr_accessor :tracking_target
  ATTRIBUTES = [:position, :health, :velocity, :name]
  ATTRIBUTES.each {|attr| attr_accessor attr }

  extend YamlHelper
  include MovementUndoable
  include Health
  include Collidable

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
    @enemy_avatar = @game.image_controller.register_image(enemy_avatar)
    p = [@enemy_avatar.width/2.0, @enemy_avatar.height/2.0 ]
    @radius = p.max
    @health = 15
    @position = p
    @collision_type = Primitives::Circle.new(@position, @radius)
    @velocity = 5
    @direction = 0
  end



  #TODO hackish
  def hud_message
    "Enemy : #{@health}HP"
  end
  def collision_response_type
    self.class
  end



  def tick_tracking(vector)
    @last_move = vector.scale(@velocity)
    @position = @position.plus(@last_move)
  end


end