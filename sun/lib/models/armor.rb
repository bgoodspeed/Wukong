class Armor
  ATTRIBUTES = [ :display_name, :equipped_on]
  EXTRAS = [ :stats ]
  (ATTRIBUTES + EXTRAS).each {|attr| attr_accessor attr }

  include InventoryStorable
  def initialize(game, conf_in={})
    conf = conf_in
    @game = game

    @inventory_type = InventoryTypes::ARMOR
    cf = conf['stats'] ? conf['stats'] : {}
    @stats = Stats.new(cf)
  end


end