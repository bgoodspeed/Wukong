# To change this template, choose Tools | Templates
# and open the template in the editor.
class InfoWindowImage
  include YamlHelper
  ATTRIBUTES = [:position, :image_name]
  ATTRIBUTES.each {|attribute| attr_accessor attribute }
  alias_method :image_file, :image_name
  def initialize(game, conf)
    @game = game
    process_attributes(ATTRIBUTES, self, conf)
  end
end

class InfoWindow
  ATTRIBUTES = [:description, :position, :images, :size]
  REQUIRED_ATTRIBUTES = [:description]
  ATTRIBUTES.each {|attribute| attr_accessor attribute }
  include YamlHelper
  include ValidationHelper

  def self.defaults
    {
        'description' => ["Mystery?"],
        'images' => []
    }
  end

  def initialize(conf_in)
    conf = self.class.defaults.merge(conf_in)
    process_attributes(ATTRIBUTES, self, conf)
  end
  def valid?(attrs=REQUIRED_ATTRIBUTES)
    attrs.each {|attr| return false if self.send(attr).nil?}
    true
  end

end
