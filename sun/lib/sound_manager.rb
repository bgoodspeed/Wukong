
class SoundManager
  def initialize(game)
    @game = game
    @effects_by_name = {}
    @effect_play_count = Hash.new(0)
  end

  def add_effect(file_name, name)
    @effects_by_name[name] = Gosu::Sample.new(@game.window, file_name)
  end

  def play_effect(name)
    if @effects_by_name.has_key?(name)
      @effects_by_name[name].play
      @effect_play_count[name] += 1
    else
      # TODO: no sound file #{name}, add a log file.
    end

  end

  def play_count_for(name)
    @effect_play_count[name]
  end

end
