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
    level.background_music = data["background_music"] if data["background_music"]
    level.name = data["name"]

    data["line_segments"].to_a.each do |lineseg|
      level.add_line_segment(lineseg["start_x"], lineseg["start_y"], lineseg["end_x"], lineseg["end_y"])
    end
    #TODO this is getting ugly
    data["event_emitters"].to_a.each do |ee|
      pos = ee["position"].split(",").collect {|v| v.to_i}
      level.add_event_emitter(pos, ee["radius"], ee["event"], ee["event_argument"])
    end
    #TODO should this know about wayfinding directly?
    if data["wayfinding"]
      wayfinding = YamlLoader.from_file(WayFinding, @game, data["wayfinding"])
      @game.wayfinding = wayfinding
    end
    data["declared_enemies"].to_a.each {|e|
      level.add_declared_enemy(e['name'], YamlLoader.from_file(Enemy, @game, e['enemy_yaml']))
    }
    data["spawn_points"].to_a.each {|sp|
      pt = SpawnPoint.new(@game, sp['point'],sp['name'], sp['spawn_schedule'], sp['spawn_argument'] )
      level.add_spawn_point(pt)
    }

    data["ored_completion_conditions"].to_a.each {|cc|
      c = CompletionCondition.new(cc['condition'],cc['argument'])
      level.add_ored_completion_condition(c)
    }
    data["anded_completion_conditions"].to_a.each {|cc|
      c = CompletionCondition.new(cc['condition'],cc['argument'])
      level.add_anded_completion_condition(c)
    }
    data["event_areas"].to_a.each {|ea|
      tl = ea['top_left']
      br = ea['bottom_right']
      rect = Primitives::Rectangle.new(tl, [tl.x, br.y], br, [br.x, tl.y])
      ea = EventArea.new(@game, rect, ea['label'], ea['action'] )
      level.add_event_area(ea)
    }

    level
  end
end
