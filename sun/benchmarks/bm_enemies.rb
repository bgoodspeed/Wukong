$: << "lib"
$: << "benchmarks"
$: << "."

require "benchmark"
require 'game'
require 'game_bm'

bm = GameBM.new("test-data/enemy_overload.yml", "enemy_overload")

if $0 == __FILE__
  bm.profile
  bm.benchmark
  bm.profile("after")
else
  bm.benchmark
end

