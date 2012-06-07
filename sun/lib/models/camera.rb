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


  def calculate_position(goal)
    rv = GVector.xy(goal.x, goal.y)
    screen_extent = [@game.screen.width/2.0, @game.screen.height/2.0]
    level_min_bounds = [@game.level.minimum_x, @game.level.minimum_y]
    level_max_bounds = [@game.level.maximum_x, @game.level.maximum_y]

    minx = level_min_bounds[0] + screen_extent[0]
    maxx = level_max_bounds[0] - screen_extent[0]
    if (goal.x < minx)
      rv.x = minx
    elsif (goal.x > maxx)
      rv.x = maxx
    end

    miny = level_min_bounds[1] + screen_extent[1]
    maxy = level_max_bounds[1] - screen_extent[1]
    if (goal.y < miny)
      rv.y = miny
    elsif (goal.y > maxy)
      rv.y = maxy
    end

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
