# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'yaml'

class LevelLoader
  def initialize(game = nil)
    @game = game
  end

  def load_level(which_level)
    level = Level.new(@game)
    data = YAML.load_file(which_level)
    level.measurements = [data["measurements"]["width"].to_i,data["measurements"]["height"].to_i]
    level.background_image = data["background_image"]

    if data["line_segments"]
      data["line_segments"].each do |lineseg|
        level.add_line_segment(lineseg["start_x"], lineseg["start_y"], lineseg["end_x"], lineseg["end_y"])
      end
    end
    #TODO this is getting ugly
    if data["event_emitters"]
      data["event_emitters"].each do |ee|
        pos = ee["position"].split(",").collect {|v| v.to_i}
        level.add_event_emitter(pos, ee["radius"], ee["event"], ee["event_argument"])
      end
    end
    #TODO should this know about wayfinding directly?
    if data["wayfinding"]
      wayfinding = WayFinding.from_file(data["wayfinding"])
      @game.wayfinding = wayfinding
    end
    if data["declared_enemies"]
      data["declared_enemies"].each {|e|
        level.add_declared_enemy(e['name'], Enemy.from_file(@game, e['enemy_yaml']))
      }
    end
    if data["spawn_points"]
      data["spawn_points"].each {|sp|
        pt = SpawnPoint.new(@game, sp['point'],sp['name'], sp['spawn_schedule'], sp['spawn_argument'] )
        level.add_spawn_point(pt)
      }
    end

    level
  end
end
