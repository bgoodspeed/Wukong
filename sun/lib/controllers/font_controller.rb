# To change this template, choose Tools | Templates
# and open the template in the editor.

class FontController
  attr_reader :font
  def initialize(game, font_name=Graphics::default_font_name, font_size=20)
    @game = game
    @font_name = font_name
    @font_size = font_size
    @font = Graphics::Font.new(game.window, font_name, font_size)
  end

  
  def draw_with_font(line, x,y, zo)
    @font.draw(line, x,y, zo )
  end

end
