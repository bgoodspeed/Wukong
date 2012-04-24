# To change this template, choose Tools | Templates
# and open the template in the editor.

module InventoryTypes
  WEAPON = "weapon_type"
  ARMOR = "armor_type"
end

class Inventory
  attr_reader :items
  attr_accessor :weapon
  def initialize(game, owner)
    @game, @owner = game, owner
    @items = {}
    @weapon = nil
  end

  def items_matching(filter)
    return @items.keys unless filter

    @items.keys.select {|item| item.inventory_type == filter}
  end

  def add_item(item, n=1)
    unless @items.has_key?(item)
      @items[item] = 0
    end
    @items[item] += n
  end

  #TODO make YAML utils and pass attributes
  def self.from_yaml(game, yaml, f=nil)
    data = YAML.load(yaml)

    conf = data['inventory']
    obj = Inventory.new( game, nil) #TODO we don't know who the owner is at this point
    conf['items'].to_a.each {|hash|
      raise "bad inventory yaml " unless hash.size == 1
      obj.add_item(hash.keys.first, hash.values.first)
    }
    if conf['weapon']
      obj.weapon = game.inventory_controller.item_named(conf['weapon'])
    end
    obj
  end

  def to_yaml
    cf = []
    @items.each {|item,quantity|
      cf << {item.orig_filename => quantity }
    }
    if @weapon
      mr = {"weapon" => @weapon.orig_filename}
    else
      mr = {}
    end
    {"inventory" => {
        "items" => cf,
      }.merge(mr)
    }.to_yaml(:UseHeader => true)
    
  end
end
