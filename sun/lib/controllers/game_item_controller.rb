module GameItemTypes
  EQUIPPABLE = "EQUIPPABLE"
end
module EquipmentTypes
  SWORD = "SWORD"
end
class GameItem
  attr_accessor :name, :item_type, :item_subtype, :power_level
  def initialize(name, item_type, item_subtype, power_level)
    @name, @item_type, @item_subtype, @power_level = name, item_type, item_subtype, power_level
  end
end
class GameItemController
  attr_accessor :registered
  def initialize(game)
    @game = game
    @registered = {}
  end

  def register_item(item)
    @registered[item.name] = item
  end
end

