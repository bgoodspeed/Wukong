module Finalizers
  class BaseFinalizer
    def initialize(game, which_level)
      @game = game
      @which_level = which_level
    end
    def validation_error(user_msg, atts=[])
      msg =  ("*" * 80) + "\n From file #{@which_level}\n#{user_msg}, required are: #{atts}"
      @game.log.fatal msg
      puts msg
    end
  end
  class LineSegments < BaseFinalizer
    def call(level, data, lineseg)
      level.add_line_segment(lineseg["start_x"], lineseg["start_y"], lineseg["end_x"], lineseg["end_y"])
    end
  end
  class DeclaredEnemies < BaseFinalizer
    def call(level, data, e)
      level.add_declared_enemy(e['name'], YamlLoader.from_file(Enemy, @game, e['enemy_yaml']))
    end
  end
  class OredCompletionConditions < BaseFinalizer
    def call(level, data, cc)
      level.add_ored_completion_condition CompletionCondition.new(cc)
    end
  end
  class AndedCompletionConditions < BaseFinalizer
    def call(level, data, cc)
      level.add_anded_completion_condition CompletionCondition.new(cc)
    end
  end

  class EventEmitters < BaseFinalizer
    def call(level, data, ee)
      circle = Primitives::Circle.new(ee['position'], ee['radius'].to_i)
      ee['collision_primitive'] = circle
      event_emitter = EventEmitter.new(@game, ee)
      validation_error("Fix event emitter yaml", EventEmitter::ATTRIBUTES) unless event_emitter.valid?
      level.add_event_emitter(event_emitter)
    end
  end
  class Animations < BaseFinalizer
    def call(level, data, animation)
      la = LevelAnimation.new(@game, animation)
      #TODO maybe entity should be level?
      #TODO wtf is the tiles boolean (hardcoded to false currently)
      @game.animation_controller.register_animation(la, la.animation_name,
                                                    la.animation_file, la.animation_width, la.animation_height, false,
                                                    la.animation_active, la.animation_rate)
      level.animations << la

    end
  end
  class SpawnPoints < BaseFinalizer
    def call(level, data, sp)
      pt = SpawnPoint.new(@game, sp)
      validation_error("Fix spawn point yaml", SpawnPoint::ATTRIBUTES) unless pt.valid?
      level.add_spawn_point(pt)

    end
  end
  class EventAreas < BaseFinalizer
    def call(level, data, ea)
      validation_error("Fix event area yaml", ['top_left', 'bottom_right']) if ea['top_left'].nil? or ea['bottom_right'].nil?
      tl = ea['top_left']
      br = ea['bottom_right']
      ea_conf = ea.dup
      ea_conf['rect'] = Primitives::Rectangle.new(tl, [tl.x, br.y], br, [br.x, tl.y])
      eva = EventArea.new(@game, ea_conf)

      validation_error("Fix event area yaml", EventArea::REQUIRED_ATTRIBUTES) unless eva.valid?
      level.add_event_area(eva)
    end
  end
end