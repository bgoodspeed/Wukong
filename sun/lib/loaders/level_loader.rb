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
  #TODO technically this is a hash constructor config helper, it's not yaml specific
  include YamlHelper
  def load_level(which_level)
    log_info { "Loading level #{which_level}" }

    data = YAML.load_file(which_level)
    level = Level.new(@game, data)
    level.orig_filename = which_level
    level.measurements = [data["measurements"]["width"].to_i,data["measurements"]["height"].to_i]

    data["line_segments"].to_a.each do |lineseg|
      log_info { "Adding line segment #{lineseg['start_x']} #{ lineseg['start_y']} #{ lineseg['end_x']} #{ lineseg['end_y']})" }
      level.add_line_segment(lineseg["start_x"], lineseg["start_y"], lineseg["end_x"], lineseg["end_y"])
    end
    #TODO this is getting ugly
    data["event_emitters"].to_a.each do |ee|

      pos = ee["position"].split(",").collect {|v| v.to_i}
      log_info { "Loading event emitter #{ee})" }
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

    data["animations"].to_a.each {|anim|
      la = LevelAnimation.new(@game, anim)
      #TODO maybe entity should be level?
      #TODO wtf is the tiles boolean (hardcoded to false currently)
      @game.animation_controller.register_animation(la, la.animation_name,
        la.animation_file, la.animation_width, la.animation_height, false,
        la.animation_active, la.animation_rate)
      level.animations << la
    }
    if data["heads_up_display"]
      @game.log.info { "Building Level HUD: #{data['heads_up_display']}"}
      hud = YamlLoader.from_file(HeadsUpDisplay, @game, data['heads_up_display'])
      @game.hud = hud

    end

    level.ored_completion_conditions = data["ored_completion_conditions"].to_a.collect {|cc| conf_for(cc) }
    level.anded_completion_conditions = data["anded_completion_conditions"].to_a.collect {|cc| conf_for(cc)}
    data["event_areas"].to_a.each {|ea|
      log_info { "Adding event areas: #{ea['label']} #{ea['action']}(#{ea['action_argument']})" }
      validation_error("Fix event area yaml", ['top_left', 'bottom_right']) if ea['top_left'].nil? or ea['bottom_right'].nil?
      tl = ea['top_left']
      br = ea['bottom_right']
      ea_conf = ea.dup
      ea_conf['rect'] = Primitives::Rectangle.new(tl, [tl.x, br.y], br, [br.x, tl.y])
      eva = EventArea.new(@game, ea_conf)

      validation_error("Fix event area yaml", EventArea::REQUIRED_ATTRIBUTES) unless eva.valid?
      level.add_event_area(eva)
    }

    level
  end

  def validation_error(user_msg, atts=[])
    msg =  ("*" * 80) + "\n #{user_msg}, required are: #{atts}"
    @game.log.fatal msg
    puts msg
  end
  def conf_for(cc)
    log_info { "Adding completion condition: #{cc['condition']} #{cc['argument']}" }
    CompletionCondition.new(cc['condition'],cc['argument'])
  end
end
