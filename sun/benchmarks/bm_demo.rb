$: << "lib"
$: << "benchmarks"
$: << "."

require "benchmark"
require 'game'
require 'game_bm'

bm = GameBM.new("game-data/game.yml", "demo")

if $0 == __FILE__
  bm.profile
  bm.benchmark
  bm.unthrottle
  bm.profile("unthrottled")
  bm.benchmark("unthrottled: ")
  #bm.game.show
else
  bm.benchmark
end

