# To change this template, choose Tools | Templates
# and open the template in the editor.

#TODO this class is getting messy, deals with hud stuff, formatting, drawing fonts, drawing menu stuff and intersection testing with screen elements.# Copyright 2012 Ben Goodspeed
class HeadsUpDisplay
  ATTRIBUTES = [:x_spacing, :y_spacing, :menu_mode, :menu_scale, :lines, :menu_width ]
  ATTRIBUTES.each {|attr| attr_accessor attr }

  extend YamlHelper
  include UtilityDrawing


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

  include GameLineFormattable
  def formatted_lines
    return [] if @lines.nil?
    @lines.collect {|line| format_line(line)}
  end
  include UtilityDrawing

 
  def lines
    formatted_lines
  end


  def draw(screen)
    @game.font_controller.draw_lines(GVector.xy(@x_spacing, @y_spacing ), lines)
  end

end
