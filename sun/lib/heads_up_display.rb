# To change this template, choose Tools | Templates
# and open the template in the editor.

#TODO this class is getting messy, deals with hud stuff, formatting, drawing fonts, drawing menu stuff and intersection testing with screen elements.
class HeadsUpDisplay
  @@X_SPACING = 10
  @@Y_SPACING = 10

  ATTRIBUTES = [:x_spacing, :y_spacing, :menu_mode, :menu_scale, :lines, :menu_width ]
  ATTRIBUTES.each {|attr| attr_accessor attr }

  extend YamlHelper

  #TODO make YAML utils and pass attributes
  def self.from_yaml(game, yaml)
    data = YAML.load(yaml)
    conf = data['heads_up_display']
    obj = HeadsUpDisplay.new(game)
    process_attributes(ATTRIBUTES, obj, conf)
    obj
  end

  def self.from_file(game, f)
    self.from_yaml(game, IO.readlines(f).join(""))
  end

  def initialize(game)
    @game = game
    @lines = []
    @font = Gosu::Font.new(game.window, Gosu::default_font_name, 20)
    @x_spacing = @@X_SPACING
    @y_spacing = @@Y_SPACING
    @menu_mode = false
    @menu_scale = 2
    @menu_width = 300
  end

  def menu_mode?
    @menu_mode
  end
  def clear
    @lines = []
  end
  def add_line(line)
    @lines << line
  end

  def tokens_from_line(line)
    rs = line.split("{{")
    es = rs.collect {|r|
      if r =~ /}}/
        rv = r.split("}}")[0]
      else
        rv = []
      end
      rv
    }
    es.flatten.collect{|e| e.strip}

  end

  def format_line(l)
    line = l.dup
    tokens = tokens_from_line(line)

    tokens.each {|token|
      line.gsub!("{{#{token}}}", "#{game_evaluate(token)}")
    }


    line
  end

  def game_evaluate(token)
    obj = @game
    token.split(".").each {|elem|
      raise "must implement #{elem} on #{obj}" unless obj.respond_to? elem
      obj = obj.send(elem)
    }
    obj
  end
  def formatted_lines
    @lines.collect {|line| format_line(line)}
  end

  def transparent_grey
    Gosu::Color.argb(0xAA000000)
  end

  def darken_screen
    #TODO GOSU specific, not automatically tested
    @game.window.draw_quad(
      0,0, transparent_grey,
      @game.window.width,0, transparent_grey,
      @game.window.width,@game.window.height, transparent_grey,
      0,@game.window.height, transparent_grey,
      ZOrder.hud.value)
  end

  #TODO ugly
  def cursor_position
    pos = [@x_spacing, @y_spacing ]
    pos = pos.scale(@menu_scale)
    cwi = @game.current_menu_index
    pos[1] = pos[1] * (cwi + 1)
    pos
  end
  def draw_cursor
    pos = cursor_position
    base_y = pos[1]
    @game.window.draw_triangle(pos[0] - 20, base_y - 10, Gosu::Color::WHITE,
                               pos[0] - 5,  base_y, Gosu::Color::WHITE,
                               pos[0] - 20, base_y + 10, Gosu::Color::WHITE)
  end


  def regions
    (0 .. lines.size-1).collect {|i| region_for_index(i)}
  end

  include PrimitiveIntersectionTests
  def highlighted_regions
    msc = @game.input_manager.mouse_screen_coords
    rv = []
    regions.each_with_index {|r, idx| rv << idx if rectangle_point_intersection?(r, msc) }
    rv
  end
  
  def highlight_mouse_selection
    rs = regions
    regs = highlighted_regions.collect {|hridx| rs[hridx]}
    regs.each {|rect|  draw_rectangle_as_box(@game.screen, rect, ZOrder.hud.value, Gosu::Color::GREEN) }


    
  end

  def lines
    formatted_lines
  end


  def region_for_index(index)
    pos = [@x_spacing, @y_spacing ]
    if menu_mode?
      pos = pos.scale(@menu_scale)
    end
    x = pos[0]
    y = pos[1] * (index+1)
    step = pos[1]
    xs = @menu_width

    Primitives::Rectangle.new([x,y], [x,y+step], [x+xs, y+step], [x + xs, y])
  end

  include UtilityDrawing
  def draw(screen)
    pos = [@x_spacing, @y_spacing ]

    if menu_mode?
      pos = pos.scale(@menu_scale)
      darken_screen
      draw_cursor
      highlight_mouse_selection if @game.input_manager.mouse_on_screen
    end

    lines.each_with_index do |line, index|
      x = pos[0]
      y = pos[1] * (index+1)
      @font.draw(line, x,y,ZOrder.hud.value )
      
    end
  end
end
