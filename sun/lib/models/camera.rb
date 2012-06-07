# To change this template, choose Tools | Templates
# and open the template in the editor.
# Copyright 2012 Ben Goodspeed
class Camera
  def initialize(game)
    @game = game
  end

  def screen_width
    @game.screen.width
  end
  def screen_height
    @game.screen.height
  end

  def offset
    tmp = GVector.xy(0,0) #NOTE temporary vector allocation
    position.minus(tmp, GVector.xy(screen_width/2.0, screen_height/2.0))
    tmp
  end


  def calculate_position_primitive(rv, goal, ext_x, ext_y, min_x, min_y, max_x, max_y)
    minx = min_x + ext_x
    maxx = max_x - ext_x

    if (goal.x < minx)
      rv.x = minx
    elsif (goal.x > maxx)
      rv.x = maxx
    end

    miny = min_y + ext_y
    maxy = max_y - ext_y
    if (goal.y < miny)
      rv.y = miny
    elsif (goal.y > maxy)
      rv.y = maxy
    end
    rv
  end

  def extent_x
    if @extent_x.nil?
      @extent_x = @game.screen.width/2.0
    end
    @extent_x
  end
  def extent_y
    if @extent_y.nil?
      @extent_y = @game.screen.height/2.0
    end
    @extent_y
  end

  def calculate_position(goal)
    rv = GVector.xy(goal.x, goal.y)
    calculate_position_primitive(rv, goal, extent_x, extent_y, @game.level.minimum_x, @game.level.minimum_y, @game.level.maximum_x, @game.level.maximum_y)
    rv
  end
  def position
    calculate_position(@game.player.position)
  end

  def screen_coordinates_for(p)
    tmp = GVector.xy(0,0) #NOTE temporary vector allocation
    p.minus(tmp, offset)
    tmp
  end
  def world_coordinates_for(p)
    tmp = GVector.xy(0,0) #NOTE temporary vector allocation
    p.plus(tmp, offset)
    tmp
  end
end
