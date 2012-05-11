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
        "line_segments" => Finalizers::LineSegments.new(@game, @which_level),
        "declared_enemies" => Finalizers::DeclaredEnemies.new(@game, @which_level),
        "event_areas" => Finalizers::EventAreas.new(@game, @which_level),
        "spawn_points" => Finalizers::SpawnPoints.new(@game, @which_level),
        "animations" => Finalizers::Animations.new(@game, @which_level),
        "event_emitters" => Finalizers::EventEmitters.new(@game, @which_level),
        "ored_completion_conditions" => Finalizers::OredCompletionConditions.new(@game, @which_level),
        "anded_completion_conditions" => Finalizers::AndedCompletionConditions.new(@game, @which_level),
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


end
