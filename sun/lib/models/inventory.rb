# To change this template, choose Tools | Templates
# and open the template in the editor.

module InventoryTypes
  WEAPON = "weapon_type"
  ARMOR = "armor_type"
  POTION = "potion_type"
end
# Copyright 2012 Ben Goodspeed
class InventoryItem
  attr_accessor :quantity, :item
  def initialize(item)
    @item = item
    @quantity = 0
  end
end
# Copyright 2012 Ben Goodspeed
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
    items = @items.values.collect {|inv_item| inv_item.item}
    items += [@weapon] if @weapon
    items += [@armor] if @armor
    return items unless filter

    items.select {|item| item.inventory_type == filter}
  end

  def add_all(inventory)
    inventory.items.each {|key, inv_item|  add_item(inv_item.item, inv_item.quantity)}
  end

  def add_item(item, n=1)
    unless @items.has_key?(item.inventory_hash)
      @items[item.inventory_hash] = InventoryItem.new(item)
    end
    @items[item.inventory_hash].quantity += n
  end

  def remove_item(item, n=1)
    @items[item.inventory_hash].quantity -= n
    @items.delete(item.inventory_hash) if @items[item.inventory_hash].quantity <= 0 #TODO this should not be necessary, clients should only passknown good quantities


  end

  def combine_items(item_sink, item_source)
    stats = item_sink.stats.plus_stats(item_source.stats)
    s = item_sink.dup
    s.stats = stats
    add_item(s)
    remove_item(item_sink)
    remove_item(item_source)
  end
  def to_yaml
    cf = []
    #TODO this will have to handle customized items, perhaps fully re-serialize the items
    @items.values.each {|item, ii|
      cf << {item.item.orig_filename => item.quantity }
    }
    if @weapon
      mr = {"weapon" => @weapon.orig_filename}
    else
      mr = {}
    end
    if @armor
      mr.merge!({"armor" => @armor.orig_filename})
    end
    {"inventory" => {
        "items" => cf,
      }.merge(mr)
    }.to_yaml(:UseHeader => true)
    
  end
end
