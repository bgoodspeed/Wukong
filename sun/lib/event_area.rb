# To change this template, choose Tools | Templates
# and open the template in the editor.

class EventArea
  attr_accessor :rect, :label, :action
  def initialize(game, rect, label, action)
    @game =game
    @rect, @label, @action = rect, label, action
  end


  include PrimitiveIntersectionTests
  def intersects?(circle)
    circle_rectangle_intersection?(circle, @rect)
  end

  def invoke
    @game.action_manager.invoke(@action)
  end
end
