# To change this template, choose Tools | Templates
# and open the template in the editor.

class ImageController
  attr_reader :images
  def initialize(game)
    @game = game
    @images = {}
  end
  def register_image(filepath)
    @game.log.info { "Registering image from #{filepath}"}
    img = Graphics::Image.new(@game.window, filepath, false)
    @images[filepath] = img
    img
  end

  def lookup_image(filepath)
    @images[filepath]
  end
  def images
    @images.collect {|k| k[1]}
  end

  def draw_image(e)
    coords = e.position
    lookup_image(e.image_file).draw(coords[0] , coords[1] , ZOrder.dynamic.value)
  end

  def draw_in_screen_coords(e)
    coords = @game.camera.screen_coordinates_for(e.position)
    lookup_image(e.image_file).draw_rot(coords[0] , coords[1] , ZOrder.dynamic.value, e.direction)
  end
end
