# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'gosu'
module Graphics
  class Window < Gosu::Window; end
  class Font < Gosu::Font; end
  class Image < Gosu::Image; end
  class Sample < Gosu::Sample; end
  class Song < Gosu::Song; end
  class Color < Gosu::Color; end

  def self.milliseconds
    Gosu::milliseconds
  end
  def self.angle(*args)
    Gosu::angle(*args)
  end

  def self.offset_x(*args)
    Gosu::offset_x(*args)
  end
  def self.offset_y(*args)
    Gosu::offset_y(*args)
  end
  def self.default_font_name
    Gosu::default_font_name
  end
  MsLeft = Gosu::MsLeft

  GpLeft = Gosu::GpLeft
  GpRight = Gosu::GpRight
  GpUp = Gosu::GpUp
  GpDown = Gosu::GpDown

  KbLeft = Gosu::KbLeft
  KbRight = Gosu::KbRight
  KbUp = Gosu::KbUp
  KbDown = Gosu::KbDown
  KbSpace = Gosu::KbSpace
  KbEnter = Gosu::KbEnter
  KbReturn = Gosu::KbReturn
  KbLeftShift = Gosu::KbLeftShift
  KbRightShift = Gosu::KbRightShift
  KbLeftAlt = Gosu::KbLeftAlt
  KbRightAlt = Gosu::KbRightAlt

  KbC = Gosu::KbC
  KbM = Gosu::KbM
  KbO = Gosu::KbO
  KbQ = Gosu::KbQ
  KbT = Gosu::KbT
  KbX = Gosu::KbX
end

