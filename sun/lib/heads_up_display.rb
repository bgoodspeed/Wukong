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
  def draw(screen)
    pos = [@x_spacing, @y_spacing ]
    if menu_mode?
      pos = pos.scale(@menu_scale)
      darken_screen
    end
    
    @lines.each_with_index do |line, index|
      @font.draw(line,
        pos[0],pos[1] * (index+1),ZOrder.hud.value )
    end
  end
end
