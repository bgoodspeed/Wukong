When /^I register a game item named "([^"]*)" with type "([^"]*)" subtype "([^"]*)" and power level "([^"]*)"/ do |n, t, st, pl|
  @game_item = GameItem.new(n, eval(t), eval(st), eval(pl))

  @game.game_item_controller.register_item(@game_item)
  
end
