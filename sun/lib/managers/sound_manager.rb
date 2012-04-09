
class SoundManager
  extend YamlHelper

  #TODO make YAML utils and pass attributes
  def self.from_yaml(game, yaml)
    data = YAML.load(yaml)
    conf = data['sound_manager']
    obj = SoundManager.new(game)

    conf['effects'].each {|effect| obj.add_effect(effect['filename'], effect['name']) }
    conf['songs'].each {|effect| obj.add_song(effect['filename'], effect['name']) }
    
    obj
  end


  def initialize(game)
    @game = game
    @effects_by_name = {}
    @song_by_name = {}
    @effect_play_count = Hash.new(0)
    @play_count_for_song = Hash.new(0)

  end

  def add_effect(file_name, name)
    @effects_by_name[name] = Graphics::Sample.new(@game.window, file_name)
  end

  def play_effect(name)
    if @effects_by_name.has_key?(name)
      @effects_by_name[name].play
      @effect_play_count[name] += 1
    else
      # TODO: no sound file #{name}, add a log file.
    end
  end

  def add_song(sound_file, sound_name)
    @song_by_name[sound_name] = Graphics::Song.new(@game.window, sound_file)
  end

  def play_song(sound_name, loops = false)
    if @song_by_name.has_key?(sound_name)
      @song_by_name[sound_name].play(loops)
      @play_count_for_song[sound_name] += 1
    else
      # TODO: no sound file #{name}, add a log file.
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
