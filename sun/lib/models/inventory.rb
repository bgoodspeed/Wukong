# To change this template, choose Tools | Templates
# and open the template in the editor.

module InventoryTypes
  WEAPON = "weapon_type"
  ARMOR = "armor_type"
end

class Inventory
  attr_reader :items
  def initialize(game, owner)
    @game, @owner = game, owner
    @items = {}
  end

  def items_matching(filter)
    return @items.keys unless filter

    @items.keys.select {|item| item.inventory_type == filter}
  end

  def add_item(item)
    unless @items.has_key?(item)
      @items[item] = 0
    end
    @items[item] += 1
  end
end
