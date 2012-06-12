# To change this template, choose Tools | Templates
# and open the template in the editor.# Copyright 2012 Ben Goodspeed
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
# Copyright 2012 Ben Goodspeed
class InfoWindow
  YAML_ATTRIBUTES = [:description, :position, :size]
  REQUIRED_ATTRIBUTES = [:description]

  ATTRIBUTES = YAML_ATTRIBUTES + [:images]
  ATTRIBUTES.each {|attribute| attr_accessor attribute }
  include YamlHelper
  include ValidationHelper

  def self.defaults
    {
        'description' => ["Mystery?"],
        'images' => []
    }
  end

  include GameLineFormattable
  def descriptions_formatted
    description.collect {|d| format_line(d, self)}
  end
  def initialize(game, conf_in)
    @game = game
    conf = self.class.defaults.merge(conf_in)
    process_attributes(YAML_ATTRIBUTES, self, conf)
    @images = []
    conf['images'].each {|img|

      @images << InfoWindowImage.new(@game, img)

    }
  end
  def required_attributes; REQUIRED_ATTRIBUTES; end
end
