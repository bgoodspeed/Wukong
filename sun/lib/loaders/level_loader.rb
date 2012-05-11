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
    @which_level = which_level
    data['orig_filename'] = which_level
    level = Level.new(@game, data)
    array_finalizers = {
        "line_segments" => lambda {|level, data, lineseg|
          level.add_line_segment(lineseg["start_x"], lineseg["start_y"], lineseg["end_x"], lineseg["end_y"])
        },
        "declared_enemies" => lambda {|level, data, e|
          level.add_declared_enemy(e['name'], YamlLoader.from_file(Enemy, @game, e['enemy_yaml']))
        },
        "event_areas" => lambda {|level, data, ea|
          validation_error("Fix event area yaml", ['top_left', 'bottom_right']) if ea['top_left'].nil? or ea['bottom_right'].nil?
          tl = ea['top_left']
          br = ea['bottom_right']
          ea_conf = ea.dup
          ea_conf['rect'] = Primitives::Rectangle.new(tl, [tl.x, br.y], br, [br.x, tl.y])
          eva = EventArea.new(@game, ea_conf)

          validation_error("Fix event area yaml", EventArea::REQUIRED_ATTRIBUTES) unless eva.valid?
          level.add_event_area(eva)
        },
        "spawn_points" => lambda {|level, data, sp|
          pt = SpawnPoint.new(@game, sp)
          validation_error("Fix spawn point yaml", SpawnPoint::ATTRIBUTES) unless pt.valid?
          level.add_spawn_point(pt)
        },
        "animations" => lambda {|level, data, anim|
          la = LevelAnimation.new(@game, anim)
          #TODO maybe entity should be level?
          #TODO wtf is the tiles boolean (hardcoded to false currently)
          @game.animation_controller.register_animation(la, la.animation_name,
                                                        la.animation_file, la.animation_width, la.animation_height, false,
                                                        la.animation_active, la.animation_rate)
          level.animations << la
        },
        "event_emitters" => lambda {|level, data, ee|
          circle = Primitives::Circle.new(ee['position'], ee['radius'].to_i)
          ee['collision_primitive'] = circle
          event_emitter = EventEmitter.new(@game, ee)
          validation_error("Fix event emitter yaml", EventEmitter::ATTRIBUTES) unless event_emitter.valid?
          level.add_event_emitter(event_emitter)
        },
        "ored_completion_conditions" => lambda {|level, data, cc| level.add_ored_completion_condition CompletionCondition.new(cc) },
        "anded_completion_conditions" => lambda {|level, data, cc| level.add_anded_completion_condition CompletionCondition.new(cc) },
    }

    array_finalizers.each do |prop, method|
      data[prop].to_a.each do |elem|
        log_info { "Adding #{prop} #{elem}" }
        method.call(level, data, elem)
      end
    end
    #TODO should this know about wayfinding directly?
    if data["wayfinding"]
      log_info { "Loading wayfinding #{data["wayfinding"]}" }
      @game.wayfinding = YamlLoader.from_file(WayFinding, @game, data["wayfinding"])
    end
    
    if data["heads_up_display"]
      @game.log.info { "Building Level HUD: #{data['heads_up_display']}"}
      hud = YamlLoader.from_file(HeadsUpDisplay, @game, data['heads_up_display'])
      @game.hud = hud

    end

    level
  end

  def validation_error(user_msg, atts=[])
    msg =  ("*" * 80) + "\n From file #{@which_level}\n#{user_msg}, required are: #{atts}"
    @game.log.fatal msg
    puts msg
  end
end
