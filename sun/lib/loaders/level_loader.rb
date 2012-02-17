# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'yaml'

class LevelLoader
  def initialize
    
  end

  def load_level(which_level)
    level = Level.new
    data = YAML.load_file(which_level)
    level.measurements = [data["measurements"]["width"].to_i,data["measurements"]["height"].to_i]
    data["line_segments"].each do |lineseg|
      level.add_line_segment(lineseg["start_x"], lineseg["start_y"], lineseg["end_x"], lineseg["end_y"])
    end
    level
  end
end
