module GameItemTypes
  EQUIPPABLE = "EQUIPPABLE"
end
module EquipmentTypes
  SWORD = "SWORD"
end
class GameItem
  ATTRIBUTES = [:display_name, :item_type, :item_subtype, :power_level, :inventory_type, :orig_filename]
  ATTRIBUTES.each {|at| attr_accessor at }
  def initialize(game, conf)
    @game = game
    cf = conf['stats'] ? conf['stats'] : {}
    @stats = Stats.new(cf)
  end
end
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

