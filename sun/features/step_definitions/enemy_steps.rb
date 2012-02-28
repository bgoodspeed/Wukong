Given /^I set the enemy avatar to "([^"]*)"$/ do |enemy_avatar|
  enemy_image_path ="game-data/sprites/#{enemy_avatar}"
  @enemy = Enemy.new(enemy_image_path, @game.window)
end

Then /^the enemy should be in the scene$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^the enemy should be at position (\d+),(\d+)$/ do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end