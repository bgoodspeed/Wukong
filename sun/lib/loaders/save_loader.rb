# To change this template, choose Tools | Templates
# and open the template in the editor.

class SaveData
  
  ATTRIBUTES = [:level, :player]
  ATTRIBUTES.each {|attr| attr_accessor attr }

  extend YamlHelper

  def self.from_yaml(game, yaml)
    data = YAML.load(yaml)
    conf = data['savedata']
    obj = SaveData.new
    process_attributes(ATTRIBUTES, obj, conf)
    obj
  end
end

class SaveLoader
  def initialize(game)
    @game = game
  end

  #TODO consider things that might need to be reloaded, player progress, level progress, equipment etc
  def load_slot(slot)
    name = File.join(@game.game_load_path, "#{slot}", "savedata.yml")
    sd = YamlLoader.from_file(SaveData, @game, name)
    p = YamlLoader.from_file(Player, @game, sd.player)
    @game.load_level(sd.level)
    @game.set_player(p)
  end
end
