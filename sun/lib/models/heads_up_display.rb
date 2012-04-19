# To change this template, choose Tools | Templates
# and open the template in the editor.

#TODO this class is getting messy, deals with hud stuff, formatting, drawing fonts, drawing menu stuff and intersection testing with screen elements.
class HeadsUpDisplay
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

  #TODO make a font controller or something
  attr_reader :font
  def initialize(game)
    @game = game
    @lines = []
    @old_lines = []
    @x_spacing = 10
    @y_spacing = 10
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

  def old_lines
    @old_lines ? @old_lines : []
  end

  def safe_dup(e)
    e.nil? ? [] : e.dup
  end
  def swap_copy
    @old_lines = safe_dup(@lines)
    @lines = safe_dup(@lines)
  end

  def swap

    lines = safe_dup(@lines)
    @lines = old_lines
    @old_lines = lines
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

  #TODO this is probably going to be hard to move to c++ as-is, need to get rid of obj.send() calls
  def game_evaluate(token)
    obj = @game
    token.split(".").each {|elem|
      raise "must implement #{elem} on #{obj}" unless obj.respond_to? elem
      obj = obj.send(elem)
    }
    obj
  end
  def formatted_lines
    return [] if @lines.nil?
    @lines.collect {|line| format_line(line)}
  end
  include UtilityDrawing

 
  def lines
    formatted_lines
  end


  include UtilityDrawing
  def draw(screen)
    pos = [@x_spacing, @y_spacing ]

    if menu_mode?
      darken_screen

      menu = @game.menu_controller.current_menu
      menu.draw_cursor
      menu.highlight_mouse_selection if @game.input_controller.mouse_on_screen

      menu.draw_lines([@x_spacing, @y_spacing].scale(@menu_scale))
      return
    end

    lines.each_with_index do |line, index|
      x = pos[0]
      y = pos[1] * (index+1)
      #TODO should use draw_with_font
      @game.font_controller.font.draw(line, x,y,ZOrder.hud.value )
      
    end
  end

end
