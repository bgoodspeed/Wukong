module GameItemTypes
  EQUIPPABLE = "EQUIPPABLE"
end# Copyright 2012 Ben Goodspeed
module EquipmentTypes
  SWORD = "SWORD"
end# Copyright 2012 Ben Goodspeed
class GameItem
  ATTRIBUTES = [:display_name, :item_type, :item_subtype, :power_level, :inventory_type, :orig_filename]
  EXTRAS = [ :stats ]
  (ATTRIBUTES + EXTRAS).each {|at| attr_accessor at }

  include InventoryStorable
  def initialize(game, conf)
    @game = game
    if conf['stats']
      cf = Stats.zero_config.merge(conf['stats'])
    else
      cf = Stats.zero_config
    end

    @stats = Stats.new(cf)
  end


end# Copyright 2012 Ben Goodspeed
class GameItemController
  attr_accessor :registered
  def initialize(game)
    @game = game
    @registered = {}
  end

  def register_item(item)
    @registered[item.orig_filename] = item
  end
end

