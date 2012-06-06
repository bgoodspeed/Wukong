$: << "lib"
$: << "benchmarks"
$: << "."

require "benchmark"
require 'game'
require 'game_bm'

bm = GameBM.new("test-data/new_game_load_screen.yml", "blockagewayfinding")

LevelLoader.new(bm.game).load_level("test-data/levels/blockage/blockage.yml")


if $0 == __FILE__
  
  bm.benchmark_single(1000, "one_k_frames")
  bm.profile("one")
  bm.benchmark_single(1000, "one_k_frames_after_profile")
  bm.profile("oneafter")
  bm.prof_loops = 10
else
  bm.benchmark
end

