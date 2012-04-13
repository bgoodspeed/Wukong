# To change this template, choose Tools | Templates
# and open the template in the editor.
require 'yaml'

class LevelLoader
  def initialize(game = nil)
    @game = game
  end

  def log_info
    return unless @game
    @game.log.info yield
  end

  def load_level(which_level)
    log_info { "Loading level #{which_level}" }
    level = Level.new(@game)
    data = YAML.load_file(which_level)
    level.orig_filename = which_level
    level.measurements = [data["measurements"]["width"].to_i,data["measurements"]["height"].to_i]
    level.background_image = data["background_image"]
    level.background_music = data["background_music"] if data["background_music"]
    level.reward_level = data["reward_level"] if data["reward_level"]
    level.name = data["name"]

    data["line_segments"].to_a.each do |lineseg|
      log_info { "Adding line segment #{lineseg['start_x']} #{ lineseg['start_y']} #{ lineseg['end_x']} #{ lineseg['end_y']})" }
      level.add_line_segment(lineseg["start_x"], lineseg["start_y"], lineseg["end_x"], lineseg["end_y"])
    end
    #TODO this is getting ugly
    data["event_emitters"].to_a.each do |ee|

      pos = ee["position"].split(",").collect {|v| v.to_i}
      log_info { "Loading event emitter #{ee['event']}(#{ee['event_argument']})" }
      level.add_event_emitter(pos, ee["radius"], ee["event"], ee["event_argument"])
    end
    #TODO should this know about wayfinding directly?
    if data["wayfinding"]
      log_info { "Loading wayfinding #{data["wayfinding"]}" }
      wayfinding = YamlLoader.from_file(WayFinding, @game, data["wayfinding"])
      @game.wayfinding = wayfinding
    end
    
    data["declared_enemies"].to_a.each {|e|
      log_info { "Adding enemy #{e['name']} from #{e['enemy_yaml']}" }
      level.add_declared_enemy(e['name'], YamlLoader.from_file(Enemy, @game, e['enemy_yaml']))
    }
    data["spawn_points"].to_a.each {|sp|
      pt = SpawnPoint.new(@game, sp['point'],sp['name'], sp['spawn_schedule'], sp['spawn_argument'] )
      log_info { "Adding spawn poit #{sp}" }
      level.add_spawn_point(pt)
    }

    level.ored_completion_conditions = data["ored_completion_conditions"].to_a.collect {|cc| conf_for(cc) }
    level.anded_completion_conditions = data["anded_completion_conditions"].to_a.collect {|cc| conf_for(cc)}
    data["event_areas"].to_a.each {|ea|
      log_info { "Adding event areas: #{ea['label']} #{ea['action']}" }
      tl = ea['top_left']
      br = ea['bottom_right']
      rect = Primitives::Rectangle.new(tl, [tl.x, br.y], br, [br.x, tl.y])
      ea = EventArea.new(@game, rect, ea['label'], ea['action'] )
      level.add_event_area(ea)
    }

    level
  end
  def conf_for(cc)
    log_info { "Adding completion condition: #{cc['condition']} #{cc['argument']}" }
    CompletionCondition.new(cc['condition'],cc['argument'])
  end
end
