# To change this template, choose Tools | Templates
# and open the template in the editor.

class SaveData
  
  ATTRIBUTES = [:level, :player]
  ATTRIBUTES.each {|attr| attr_accessor attr }

  extend YamlHelper
  include YamlHelper
  def self.from_yaml(game, yaml)
    data = YAML.load(yaml)
    conf = data['savedata']
    obj = SaveData.new
    process_attributes(ATTRIBUTES, obj, conf)
    obj
  end

  def to_yaml
    cf = attr_to_yaml(ATTRIBUTES)
    {"savedata" => cf}.to_yaml(:UseHeader => true)
  end

end

class SaveLoader
  def initialize(game)
    @game = game
  end

  def slot_path(slot)
    File.join(@game.game_load_path, "#{slot}")
  end
  def slot_name(slot)
    File.join(slot_path(slot), "savedata.yml")
  end
  #TODO consider things that might need to be reloaded, player progress, level progress, equipment etc
  def load_slot(slot)
    name = slot_name(slot)
    sd = YamlLoader.from_file(SaveData, @game, name)
    p = YamlLoader.from_file(Player, @game, sd.player)
    @game.load_level(sd.level)
    @game.set_player(p)
  end

  def save_player_to_slot(p)
    n = File.join(p, "player.yml")
    File.open(n, "w") do |f|
      f.write(@game.player.to_yaml)
    end
    n
  end
  def save_slot(slot)
    p = slot_path(slot)
    Dir.mkdir p unless File.exists?(p)
    n = slot_name(slot)
    File.open(n, "w") do |f|
      sd = SaveData.new
      sd.player = save_player_to_slot(p)
      sd.level = @game.level.orig_filename
      f.write(sd.to_yaml)
    end
    n
  end
end
