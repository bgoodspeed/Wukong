# To change this template, choose Tools | Templates
# and open the template in the editor.

$: << "lib"

require "game"


game = YamlLoader.game_from_file("game-data/new_game_load_screen.yml")


#TODO this should be triggered by and stored in the level
#game.sound_controller.play_song("music", true)
game.show

