# To change this template, choose Tools | Templates
# and open the template in the editor.

class EventArea
  #TODO use ATTRIBUTES and process with yaml as usual
  attr_accessor :rect, :label, :action, :info_window, :action_argument
  alias_method :argument, :action_argument
  def initialize(game, rect, label, action, description=nil, action_argument=nil, info_window_position=nil)
    @game =game
    @rect, @label, @action = rect, label, action
    @info_window = InfoWindow.new(description ? description : ["Mystery?"], info_window_position)
    @action_argument = action_argument
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
