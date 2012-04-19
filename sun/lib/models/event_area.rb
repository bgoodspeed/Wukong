# To change this template, choose Tools | Templates
# and open the template in the editor.

class EventArea
  #TODO use ATTRIBUTES and process with yaml as usual
  attr_accessor :rect, :label, :action, :info_window, :description, :action_argument
  def initialize(game, rect, label, action, description=nil, action_argument=nil)
    @game =game
    @rect, @label, @action = rect, label, action
    @description = description ? description : "Mystery?"
    @info_window = InfoWindow.new(@description)
    @action_argument = action_argument
  end


  include PrimitiveIntersectionTests
  def intersects?(circle)
    circle_rectangle_intersection?(circle, @rect)
  end

  def invoke
    if @action_argument
      @game.action_controller.invoke(@action, @action_argument)
    else
      @game.action_controller.invoke(@action)
    end
  end
end
