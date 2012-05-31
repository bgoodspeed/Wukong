class Armor
  ATTRIBUTES = [ :display_name, :equipped_on]
  EXTRAS = [ :stats ]
  (ATTRIBUTES + EXTRAS).each {|attr| attr_accessor attr }

  def initialize(game, conf_in={})
    conf = conf_in
    @game = game

    @inventory_type = InventoryTypes::ARMOR
    cf = conf['stats'] ? conf['stats'] : {}
    @stats = Stats.new(cf)
  end

  def inventory_hash
    rv = "#{@display_name}:#{@orig_filename}:#{@stats.inventory_hash}"

    rv
  end

end