$LOAD_PATH.unshift File.dirname($0)
$LOAD_PATH.unshift File.join(File.dirname($0), "lib")
$LOAD_PATH.unshift File.join(File.dirname($0), "src")
$: << "lib"

require "game"

if ARGV.empty?
  game = YamlLoader.game_from_file("game-data/new_game_load_screen.yml")
else
  game = YamlLoader.game_from_file(ARGV.first)
  game.load_level(ARGV[1]) if ARGV.size > 1
end


game.show

