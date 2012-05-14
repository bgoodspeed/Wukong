# To change this template, choose Tools | Templates
# and open the template in the editor.

class FontController
  attr_reader :font, :font_name, :font_size
  def initialize(game, font_name=nil, font_size=nil)
    @game = game
    @font_name = font_name ? font_name : Graphics::default_font_name
    @font_size = font_size ? font_size : 20

    @font = Graphics::Font.new(game.window, @font_name, @font_size)
  end

  
  def draw_with_font(line, x,y, zo)
    @font.draw(line, x,y, zo )
  end
  def draw_lines(pos, lines_to_draw)
    lines_to_draw.each_with_index do |line, index|
      x = pos.x
      y = pos.y * (index+1)
      draw_with_font(line, x,y,ZOrder.hud.value )
    end
  end
end
