When /^I register a game item named "([^"]*)" with type "([^"]*)" subtype "([^"]*)" and power level "([^"]*)"/ do |n, t, st, pl|
  conf = { 'item_type' => eval(t),
    'item_subtype' => eval(st),
    'power_level' => eval(pl),
      'display_name' => n,
      'orig_filename' => n
  }
  @game_item = GameItem.new(nil, conf)

  @game.game_item_controller.register_item(@game_item)
  
end
