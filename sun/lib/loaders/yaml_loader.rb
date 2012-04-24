# To change this template, choose Tools | Templates
# and open the template in the editor.

class YamlLoader
  def self.from_file(klass, game, f)
    klass.from_yaml(game, IO.readlines(f).join(""), f)
  end

  def self.game_from_file(f)
    GameLoader.game_from_yaml(IO.readlines(f).join(""))
  end
end
