# To change this template, choose Tools | Templates
# and open the template in the editor.

class EventArea
  attr_accessor :rect, :label, :action, :info_window, :description
  def initialize(game, rect, label, action, description="Mystery?")
    @game =game
    @rect, @label, @action = rect, label, action
    @description = description
    @info_window = InfoWindow.new(@description)
    
  end


  include PrimitiveIntersectionTests
  def intersects?(circle)
    circle_rectangle_intersection?(circle, @rect)
  end

  def invoke
    @game.action_controller.invoke(@action)
  end
end
