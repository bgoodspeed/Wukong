# To change this template, choose Tools | Templates
# and open the template in the editor.

class HeadsUpDisplay
  @@X_SPACING = 10
  @@Y_SPACING = 10


  attr_reader :lines
  attr_accessor :x_spacing, :y_spacing, :menu_mode
  def initialize(game)
    @game = game
    @lines = []
    @font = Gosu::Font.new(game.window, Gosu::default_font_name, 20)
    @x_spacing = @@X_SPACING
    @y_spacing = @@Y_SPACING
    @menu_mode = false
    @menu_scale = 2
  end

  def menu_mode?
    @menu_mode
  end
  def clear
    @lines = []
  end
  def add_line(line)
    @lines << line
  end

  def transparent_grey
    Gosu::Color.argb(0xAA000000)
  end

  def darken_screen
    #TODO GOSU specific, not automatically tested
    @game.window.draw_quad(
      0,0, transparent_grey,
      @game.window.width,0, transparent_grey,
      @game.window.width,@game.window.height, transparent_grey,
      0,@game.window.height, transparent_grey,
      ZOrder.hud.value)
  end

  #TODO ugly
  def cursor_position
    pos = [@x_spacing, @y_spacing ]
    pos = pos.scale(@menu_scale)
    cwi = @game.current_menu_index
    pos[1] = pos[1] * (cwi + 1)
    pos
  end
  def draw_cursor
    pos = cursor_position
    base_y = pos[1]
    @game.window.draw_triangle(pos[0] - 20, base_y - 10, Gosu::Color::WHITE,
                               pos[0] - 5,  base_y, Gosu::Color::WHITE,
                               pos[0] - 20, base_y + 10, Gosu::Color::WHITE)
  end
  def draw(screen)
    pos = [@x_spacing, @y_spacing ]
    if menu_mode?
      pos = pos.scale(@menu_scale)
      darken_screen
      draw_cursor
    end
    
    @lines.each_with_index do |line, index|
      @font.draw(line,
        pos[0],pos[1] * (index+1),ZOrder.hud.value )
    end
  end
end
