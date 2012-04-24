# To change this template, choose Tools | Templates
# and open the template in the editor.

class InventoryController
  attr_accessor :items

  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)
    conf = data['inventory']
    obj = InventoryController.new(game)
    conf['items'].to_a.each do |item|
      obj.register_item(item, YamlLoader.from_file(Weapon, game, item ))
    end
    obj
  end
  def initialize(game)
    @game = game
    @items = {}
  end

  def register_item(name, item)
    @items[name] = item
  end
  def item_named(name)
    @items[name]
  end
end
