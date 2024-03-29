# Copyright 2012 Ben Goodspeed
class SoundController


  def initialize(game)
    @game = game
    @effect_instances_by_name = {}
    @effects_by_name = {}
    @song_by_name = {}
    @effect_play_count = Hash.new(0)
    @play_count_for_song = Hash.new(0)

  end

  def add_effect(filepath, name)
    f = PathFixer.new.fix(filepath)
    @effects_by_name[name] = Graphics::Sample.new(@game.window, f)
  end


  def play_singleton_effect(name)
    if @effects_by_name.has_key?(name)

      return if @effect_instances_by_name.has_key?(name) and @effect_instances_by_name[name].playing?

      @effect_instances_by_name[name] = @effects_by_name[name].play
      @effect_play_count[name] += 1
    else
      @game.log.error { "ERROR: No such sound effect #{name}" }
    end
  end
  def play_effect(name)
    if @effects_by_name.has_key?(name)
      @effects_by_name[name].play
      @effect_play_count[name] += 1
    else
      @game.log.error { "ERROR: No such sound effect #{name}" }
    end
  end

  def add_song(filepath, sound_name)
    f = PathFixer.new.fix(filepath)
    @song_by_name[sound_name] = Graphics::Song.new(@game.window, f)
  end

  def play_song(sound_name, loops = false)
    if @song_by_name.has_key?(sound_name)
      @song_by_name[sound_name].play(loops)
      @play_count_for_song[sound_name] += 1
    else
      @game.log.error { "ERROR: No such song #{sound_name}" }
    end
  end

  def play_count_for(name)
    @effect_play_count[name]
  end

  def play_count_for_song(sound_name)
    @play_count_for_song[sound_name]
  end

  def is_playing_song(sound_name)
    return false unless Graphics::Song.current_song
    (Graphics::Song.current_song == @song_by_name[sound_name]) &&
      Graphics::Song.current_song.playing?
  end

end
