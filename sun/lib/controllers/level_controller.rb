# To change this template, choose Tools | Templates
# and open the template in the editor.
# Copyright 2012 Ben Goodspeed
class LevelController
  def initialize(game)
    @game = game
  end

  #TODO this should be in a loader but it's really not loading the level from disk here
  def load_level(level_name)
    @game.log.info "Loading level into game #{level_name}"
    #@game.animation_controller.clear
    @game.level = @game.level_loader.load_level(level_name)
    if !@game.player
      @game.log.info "Level loading player"
      @game.player = @game.player_loader.load_player
    end
    #TODO Hackish and an exact double
    if @game.level.player_start_position
      @game.log.info "Level setting start player position"
      @game.player.position = @game.level.player_start_position
    end
    if @game.level.player_start_health
      @game.log.info "Level setting start player health"
      @game.player.health = ((@game.level.player_start_health.to_f/100.0) * @game.player.max_health).to_i
    end

    @game.log.info "Level adding player #{@game.player} weapon:(#{@game.player.inventory.weapon})"
    if @game.player.inventory.weapon
      @game.player.inventory.weapon.inactivate
    end
    @game.level.add_player(@game.player)
    if @game.level.background_music
      @game.sound_controller.play_song(@game.level.background_music, true)
    end
    @game.clock.reset
    @game.temporary_message = nil
    @game.rendering_controller.add_consumable_rendering(@game, RenderingTypes::FADE_IN_LEVEL, 60)
    @game.input_controller.enable_all
    @game.level
  end

end

