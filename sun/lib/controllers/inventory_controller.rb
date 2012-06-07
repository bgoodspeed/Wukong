# To change this template, choose Tools | Templates
# and open the template in the editor.
# Copyright 2012 Ben Goodspeed
class InventoryController
  attr_accessor :items

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
