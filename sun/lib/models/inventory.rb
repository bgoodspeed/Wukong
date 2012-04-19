# To change this template, choose Tools | Templates
# and open the template in the editor.

class Inventory
  attr_reader :items
  def initialize(game, owner)
    @game, @owner = game, owner
    @items = {}
  end
end
