# To change this template, choose Tools | Templates
# and open the template in the editor.

$: << "lib"

require "game"

if ARGV.empty?
  game = YamlLoader.game_from_file("game-data/new_game_load_screen.yml")
else
  game = YamlLoader.game_from_file(ARGV.first)
  game.load_level(ARGV[1]) if ARGV.size > 1
end


#TODO this should be triggered by and stored in the level
#game.sound_controller.play_song("music", true)
game.show

