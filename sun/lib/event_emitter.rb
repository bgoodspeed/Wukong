# To change this template, choose Tools | Templates
# and open the template in the editor.

class LambdaEvent
  def initialize(game, lambda, arg)
    @game = game
    @lambda = lambda
    @argument = arg
  end

  def invoke
    @lambda.call(@game, @argument)
  end

end


class EventEmitter

  attr_reader :event_name, :event_argument, :collision_primitive



  def initialize(game, collision_primitive, event_name, event_arg)
    @game = game
    @collision_primitive = collision_primitive
    @event_name = event_name
    @event_argument = event_arg
    @events = {
      "play_sound" => LambdaEvent.new(@game, lambda {|game, arg| game.play_effect(arg)}, @event_argument )
    }
  end

  def collision_type
    to_collision.class
  end
  def collision_response_type
    self.class
  end

  def to_collision
    #Primitives::Circle.new(@position, @radius)
    @collision_primitive
  end
  def collision_radius
    to_collision.radius
  end
  def collision_center
    to_collision.position
  end



  def events_by_name(name)
    raise "todo handle other types of event emitter" unless @events.has_key? name
    @events[name]
  end

  def trigger
    @game.add_event(events_by_name(@event_name))
  end
  alias_method :position, :collision_center
  alias_method :radius, :collision_radius
end
