# To change this template, choose Tools | Templates
# and open the template in the editor.

class EventEmitter

  attr_reader :event_name, :event_argument, :collision_primitive



  def initialize(game, collision_primitive, event_name, event_arg)
    @game = game
    @collision_primitive = collision_primitive
    @event_name = event_name
    @event_argument = event_arg
  end

  def collision_type
    self.class
  end

  def collision_radius
    @collision_primitive.radius
  end
  def collision_center
    @collision_primitive.position
  end

  def trigger
    raise "todo handle other types of event emitter" unless @event_name =~ /play_sound/
    @game.play_effect(@event_argument)
  end
  alias_method :position, :collision_center
  alias_method :radius, :collision_radius
end
