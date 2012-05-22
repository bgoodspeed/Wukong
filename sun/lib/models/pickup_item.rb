class PickupItem
  attr_reader :position, :inventory
  include Collidable
  def initialize(game, inventory, position)
    @game = game
    @inventory = inventory
    @position = position
    @collision_type = Primitives::Circle.new(position, 15)
  end

  def collision_priority
    CollisionPriority::MID
  end
end