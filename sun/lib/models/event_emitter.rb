# To change this template, choose Tools | Templates
# and open the template in the editor.

# Copyright 2012 Ben Goodspeed
class LambdaEvent
  def initialize(game, lambda, arg)
    @game = game
    @lambda = lambda
    @argument = arg
  end
  def invoke
    @lambda.call(@game, @argument)
  end
  def event_type
    EventTypes::LAMBDA
  end
end

# Copyright 2012 Ben Goodspeed
class EventEmitter

  ATTRIBUTES = [:event_name, :event_argument, :collision_primitive]
  ATTRIBUTES.each {|attribute| attr_accessor attribute }

  include YamlHelper
  include ValidationHelper
  def initialize(game, conf)
    @game = game
    process_attributes(ATTRIBUTES, self, conf)
    #TODO these should be defined elsewhere
    @events = {
      "play_sound" => LambdaEvent.new(@game, lambda {|game, arg| game.play_effect(arg)}, @event_argument )
    }
  end

  def required_attributes; ATTRIBUTES; end
  def collision_type
    to_collision.collision_type
  end
  def collision_response_type
    self.class.to_s
  end

  #TODO extract this to a behavior
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
