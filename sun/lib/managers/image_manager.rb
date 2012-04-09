# To change this template, choose Tools | Templates
# and open the template in the editor.

class ImageManager
  def initialize(game)
    @game = game
    @images = {}
  end
  def register_image(filepath)
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

  def draw_in_screen_coords(e)
    coords = @game.camera.screen_coordinates_for(e.position)
    lookup_image(e.image_file).draw_rot(coords[0] , coords[1] , ZOrder.dynamic.value, e.direction)
  end
end
