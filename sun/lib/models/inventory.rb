# To change this template, choose Tools | Templates
# and open the template in the editor.

module InventoryTypes
  WEAPON = "weapon_type"
  ARMOR = "armor_type"
  POTION = "potion_type"
end

class Inventory
  attr_reader :items
  attr_accessor :weapon, :armor
  def initialize(game, owner)
    @game, @owner = game, owner
    @items = {}
    @weapon = nil
    @armor = nil
  end
  def equipped_stats
    #TODO will need to track more than just weapons
    w = @weapon.nil? ? Stats.zero : @weapon.stats
    a = @armor.nil? ? Stats.zero : @armor.stats
    w.plus_stats(a)
  end

  def items_matching(filter)
    items = @items.keys
    items += [@weapon] if @weapon
    items += [@armor] if @armor
    return items unless filter

    items.select {|item| item.inventory_type == filter}
  end

  def add_all(inventory)
    inventory.items.each {|item, quantity|  add_item(item, quantity.to_i)}
  end

  def add_item(item, n=1)
    unless @items.has_key?(item)
      @items[item] = 0
    end
    @items[item] += n
  end

  def remove_item(item, n=1)
    @items[item] -= n
    @items.delete(item) if @items[item] <= 0 #TODO this should not be necessary, clients should only passknown good quantities


  end

  def combine_items(item_sink, item_source)
    item_sink.stats = item_sink.stats.plus_stats(item_source.stats)
    remove_item(item_source)
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
