# To change this template, choose Tools | Templates
# and open the template in the editor.
class EventArea
  #TODO use ATTRIBUTES and process with yaml as usual
  YAML_ATTRIBUTES = [:rect, :label, :action, :action_argument]
  ATTRIBUTES = [:info_window ]
  REQUIRED_ATTRIBUTES = YAML_ATTRIBUTES - [:action_argument]

  (ATTRIBUTES + YAML_ATTRIBUTES).each {|attribute| attr_accessor attribute }
  alias_method :argument, :action_argument
  def self.defaults
    {
    }
  end
  include YamlHelper
  include ValidationHelper
  def initialize(game, conf_in)
    conf = self.class.defaults.merge(conf_in)
    @game = game
    process_attributes(YAML_ATTRIBUTES, self, conf)
    # conf.has_key?('description') ? conf['description'] : ["Mystery?"], conf['info_window']['position'], conf['info_window']['size']
    cf = conf['info_window'] ? conf['info_window'] : {}
    @info_window = InfoWindow.new(game, cf)
  end

  def valid?(attrs=REQUIRED_ATTRIBUTES)
    attrs.each {|attr| return false if self.send(attr).nil?}
    true
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

  def invoke
    if @action_argument
      @game.action_controller.invoke(@action, self)
    else
      @game.action_controller.invoke(@action)
    end
  end
end
