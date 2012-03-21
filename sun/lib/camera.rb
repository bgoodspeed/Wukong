# To change this template, choose Tools | Templates
# and open the template in the editor.

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
    position.minus([screen_width/2.0, screen_height/2.0])
  end

  def position
    goal = @game.player.position
    rv = goal.dup
    screen_extent = [@game.screen.width/2.0, @game.screen.height/2.0]
    level_min_bounds = [@game.level.minimum_x, @game.level.minimum_y]
    level_max_bounds = [@game.level.maximum_x, @game.level.maximum_y]

    minx = level_min_bounds[0] + screen_extent[0]
    maxx = level_max_bounds[0] - screen_extent[0]
    if (goal.x < minx)
      rv[0] = minx
    elsif (goal.x > maxx)
      rv[0] = maxx
    end
    
    miny = level_min_bounds[1] + screen_extent[1]
    maxy = level_max_bounds[1] - screen_extent[1]
    if (goal.y < miny)
      rv[1] = miny
    elsif (goal.y > maxy)
      rv[1] = maxy
    end

    rv
  end
end
