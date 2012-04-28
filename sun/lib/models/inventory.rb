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
