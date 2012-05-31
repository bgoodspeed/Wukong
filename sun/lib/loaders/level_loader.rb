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
  include ValidationHelper
  def load_level(which_level)
    log_info { "Loading level #{which_level}" }

    data = YAML.load_file(which_level)
    @which_level = which_level
    data['orig_filename'] = which_level
    level = Level.new(@game, data)
    array_finalizers = {
        "line_segments" => ArrayFinalizers::LineSegments.new(@game, @which_level),
        "declared_enemies" => ArrayFinalizers::DeclaredEnemies.new(@game, @which_level),
        "event_areas" => ArrayFinalizers::EventAreas.new(@game, @which_level),
        "spawn_points" => ArrayFinalizers::SpawnPoints.new(@game, @which_level),
        "animations" => ArrayFinalizers::Animations.new(@game, @which_level),
        "event_emitters" => ArrayFinalizers::EventEmitters.new(@game, @which_level),
        "ored_completion_conditions" => ArrayFinalizers::OredCompletionConditions.new(@game, @which_level),
        "anded_completion_conditions" => ArrayFinalizers::AndedCompletionConditions.new(@game, @which_level),
        "equipment_renderables" => ArrayFinalizers::EquipmentRenderables.new(@game, @which_level),
    }

    yaml_finalizers = {
        'wayfinding' => YamlFinalizers::WayfindingFinalizer.new(@game, @which_level),
        'heads_up_display' => YamlFinalizers::HeadsUpDisplayFinalizer.new(@game, @which_level)
    }

    array_finalizers.each do |prop, method|
      data[prop].to_a.each do |elem|
        log_info { "Adding #{prop} #{elem}" }
        method.call(level, data, elem)
      end
    end

    yaml_finalizers.each do |prop, method|
      method.call(level, data, data[prop])
    end

    check_validation_error(level, "Fix level yaml: ", level.required_attributes)

    level
  end


end
