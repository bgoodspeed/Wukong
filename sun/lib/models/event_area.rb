# To change this template, choose Tools | Templates
# and open the template in the editor.

class EventArea
  #TODO use ATTRIBUTES and process with yaml as usual
  attr_accessor :rect, :label, :action, :info_window, :description, :action_argument
  alias_method :argument, :action_argument
  def initialize(game, rect, label, action, description=nil, action_argument=nil, info_window_position=nil)
    @game =game
    @rect, @label, @action = rect, label, action
    @description = description ? description : ["Mystery?"]
    @info_window = InfoWindow.new(@description, info_window_position)
    @action_argument = action_argument
  end

  def description_joined
    @description.kind_of?(Array) ? @description.join("") : @description
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
