# To change this template, choose Tools | Templates
# and open the template in the editor.

class HeadsUpDisplay
  attr_reader :lines
  def initialize(game)
    @lines = []
    @font = Gosu::Font.new(game.window, Gosu::default_font_name, 20)
  end

  def clear
    @lines = []
  end
  def add_line(line)
    @lines << line
  end

  @@X_SPACING = 10
  @@Y_SPACING = 10
  def draw(screen)
    @lines.each_with_index do |line, index|
      @font.draw(line, @@X_SPACING, @@Y_SPACING * (index + 1), ZOrder.hud.value ) 
    end
  end
end
