# To change this template, choose Tools | Templates
# and open the template in the editor.
class InfoWindowImage
  attr_accessor :position, :image_name
  alias_method :image_file, :image_name
  def initialize(game, conf)
    @game = game
    @position = conf['position']
    @image_name = conf['image_name']
  end
end

class InfoWindow
  attr_accessor :description, :position, :images
  def initialize(description, position=nil)
    @description = description
    @position = position
    @images = []
  end
end
