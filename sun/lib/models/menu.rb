class MenuHeader
  attr_accessor :header_text, :header_position
  def initialize(header_text, header_position)
    @header_text = header_text
    @header_position = header_position
  end
end
# Copyright 2012 Ben Goodspeed
class MenuEntry
  attr_accessor :display_text, :action, :action_argument, :image, :position
  def initialize(game, index, conf)
    @game = game
    @index = index
    @conf = conf
    @display_text, @action, @action_argument, @image = @conf['display_text'], @conf['action'], @conf['action_argument'], @conf['image']
    @position = GVector.xy(conf['position'][0],conf['position'][1]) if conf['position']
  end
  include GameLineFormattable
  def formatted_display_text
    format_line(@display_text, self)
  end
  
end
# Copyright 2012 Ben Goodspeed
class Menu
  attr_reader :current_index, :menu_id, :entries, :headers

  ATTRIBUTES = [:x_spacing, :y_spacing, :menu_scale, :menu_width, :header_text, :header_position]
  ATTRIBUTES.each {|attr| attr_accessor attr}
  include MenuCursor
  include MenuImages
  include MenuPositioned
  include MenuMouse
  include UtilityDrawing

  def initialize(game, menu_id)
    @game = game
    @menu_id = menu_id
    @entries = []
    @current_index = 0

    @x_spacing = 10
    @y_spacing = 10
    @menu_scale = 2
    @menu_width = 300
    @headers =[]
  end




  def add_header(header)
    @headers << header
  end
  def current_entry
    @entries[@current_index]
  end
  def add_entry(entry)
    if entry.image
      #TODO hackish, this x/y spacing stuff should be defined in the menu entries and summed
      img = @game.image_controller.lookup_image(entry.image)
      @y_spacing = img.height
    end
    @entries << entry
  end
  def lines
    @entries.collect{|e| e.formatted_display_text}
  end



  def draw_images
    @entries.each_with_index do |entry, index|
      @game.image_controller.lookup_image(entry.image).draw( @x_spacing, index * @y_spacing, ZOrder.dynamic.value)
    end
  end



end

