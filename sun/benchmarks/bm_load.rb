$: << "lib"
$: << "benchmarks"
$: << "."

require "benchmark"
require 'game'
require 'game_bm'

bm = GameBM.new("test-data/new_game_load_screen.yml", "load_level")

if $0 == __FILE__
  bm.profile
  bm.benchmark
  bm.load_level
  bm.profile("afterlevel")
  bm.benchmark("afterlevel")
  #bm.game.show
else
  bm.benchmark
end

