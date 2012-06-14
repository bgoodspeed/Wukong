
module Finalizers
  class GVectorFinalizer
    def call(v)
      return v if v.kind_of? GVector
      GVector.xy(v[0], v[1])
    end

  end
end

module ArrayFinalizers
  class BaseFinalizer
    include ValidationHelper
    def initialize(game, which_level)
      @game = game
      @which_level = which_level
    end
  end
  class LineSegments < BaseFinalizer
    def call(level, data, lineseg)
      level.add_line_segment(lineseg["start_x"], lineseg["start_y"], lineseg["end_x"], lineseg["end_y"])
    end
  end
  class DeclaredEnemies < BaseFinalizer
    def call(level, data, e)
      enemy = YamlLoader.from_file(Enemy, @game, e['enemy_yaml'])
      check_validation_error(enemy, "Fix declared enemies yaml", enemy.required_attributes)
      level.add_declared_enemy(e['name'], enemy)
    end
  end
  class EquipmentRenderables < BaseFinalizer
    def call(level, data, erc)
      er = EquipmentRenderable.new(erc)
      level.add_equipment_renderable(er)
    end
  end
  class CustomizationRenderables < BaseFinalizer
    def call(level, data, crc)
      cr = CustomizationRenderable.new(crc)
      level.add_customization_renderable(cr)
    end
  end
  class PushableElements < BaseFinalizer
    def call(level, data, pec)
      pe = PushableElement.new(pec)
      level.add_pushable_element pe
    end
  end
  class PushTargets < BaseFinalizer
    def call(level, data, ptc)
      pt = PushTarget.new(ptc)
      level.add_push_target  pt
    end
  end
  class OredCompletionConditions < BaseFinalizer
    def call(level, data, cc)
      c = CompletionCondition.new(cc)
      check_validation_error(c, "Fix ored completion condition yaml", CompletionCondition::ATTRIBUTES)
      level.add_ored_completion_condition c
    end
  end
  class AndedCompletionConditions < BaseFinalizer
    def call(level, data, cc)
      c = CompletionCondition.new(cc)
      check_validation_error(c, "Fix anded completion condition yaml", CompletionCondition::ATTRIBUTES)
      level.add_anded_completion_condition c
    end
  end

  class EventEmitters < BaseFinalizer
    def call(level, data, ee)

      circle = Primitives::Circle.new(GVector.xy(ee['position'][0],ee['position'][1]) , ee['radius'].to_i)
      ee['collision_primitive'] = circle
      event_emitter = EventEmitter.new(@game, ee)
      check_validation_error(event_emitter, "Fix event emitter yaml", EventEmitter::ATTRIBUTES)
      level.add_event_emitter(event_emitter)
    end
  end
  class ExtraBackgrounds < BaseFinalizer
    def call(level, data, eb)
      bg = @game.image_controller.register_image(eb)
      level.extra_backgrounds << bg
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
      check_validation_error(pt, "Fix spawn point yaml", SpawnPoint::ATTRIBUTES)
      level.add_spawn_point(pt)

    end
  end
  class EventAreas < BaseFinalizer
    def call(level, data, ea)
      validation_error("Fix event area yaml", ['top_left', 'bottom_right']) if ea['top_left'].nil? or ea['bottom_right'].nil?
      tl = ea['top_left']

      br = ea['bottom_right']
      ea_conf = ea.dup
      ea_conf['rect'] = Primitives::Rectangle.new(
          GVector.xy(tl[0], tl[1]),
          GVector.xy(tl[0], br[1]),
          GVector.xy(br[0], br[1]),
          GVector.xy(br[0], tl[1]))

      path = ea_conf['image_file']
      @game.image_controller.register_image(path) if path
      ea_conf['info_window'].to_hash['images'].to_a.each {|img| @game.image_controller.register_image(img['image_name'])} if ea_conf['info_window']
      eva = EventArea.new(@game, ea_conf)

      check_validation_error(eva, "Fix event area yaml", EventArea::REQUIRED_ATTRIBUTES)
      level.add_event_area(eva)
    end
  end
end
module YamlFinalizers
  class BaseFinalizer
    include ValidationHelper
    def initialize(game, which_level)
      @game = game
      @which_level = which_level
    end
  end

  class HeadsUpDisplayFinalizer < BaseFinalizer
    def call(level, data, hud)
      return unless hud
      @game.hud = YamlLoader.from_file(HeadsUpDisplay, @game, hud)
    end
  end
  class WayfindingFinalizer < BaseFinalizer
    def call(level, data, wf)
      return unless wf
      @game.wayfinding = YamlLoader.from_file(WayFinding, @game, wf)
    end
  end

end