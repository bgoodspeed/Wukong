# To change this template, choose Tools | Templates
# and open the template in the editor.
class EventArea
  #TODO use ATTRIBUTES and process with yaml as usual
  REQUIRED_ATTRIBUTES = [:rect, :action]
  YAML_ATTRIBUTES = REQUIRED_ATTRIBUTES + [:label, :action_argument,  :required_attributes, :extra_actions, :conditions, :one_time ]
  ATTRIBUTES = [:info_window ]

  (ATTRIBUTES + YAML_ATTRIBUTES).each {|attribute| attr_accessor attribute }
  alias_method :argument, :action_argument
  def self.defaults
    {
        'required_attributes' => REQUIRED_ATTRIBUTES,
        'info_window' => {}
    }
  end
  include YamlHelper
  include ValidationHelper
  include Collidable
  def initialize(game, conf_in)
    conf = self.class.defaults.merge(conf_in)
    @game = game
    @extra_actions = []
    @one_time = false
    process_attributes(YAML_ATTRIBUTES, self, conf)


    @info_window = InfoWindow.new(game, conf['info_window'])
    @collision_type = @rect
  end

  def description_joined
    @info_window.description.kind_of?(Array) ? @info_window.description.join("") : @info_window.description
  end
  def description
    @info_window.description
  end

  include PrimitiveIntersectionTests
  def intersects?(circle)
    circle_rectangle_intersection?(circle, @rect)
  end

  def access_allowed?
    return true if @conditions.nil?
    @conditions.each {|cond| return false unless @game.condition_controller.condition_met?(cond['condition_name'], cond['condition_argument'])}
    true
  end
  def invoke
    if !access_allowed?
      puts "TODO event area: forbidden access to event area, should put temporary message"
      return
    end
    if @action_argument
      @game.action_controller.invoke(@action, self)
    else
      @game.action_controller.invoke(@action)
    end

    @extra_actions.each {|action_conf|
      @game.action_controller.invoke(action_conf['action'], action_conf['action_argument'])
    }
  end
end
