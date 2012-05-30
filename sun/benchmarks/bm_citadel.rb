$: << "lib"
$: << "benchmarks"
$: << "."

require "benchmark"
require 'game'
require 'game_bm'

bm = GameBM.new("game-data/new_game_load_screen.yml", "citadel")

LevelLoader.new(bm.game).load_level("game-data/levels/h_level_intro/h_level_intro.yml")


if $0 == __FILE__
  
  bm.benchmark_single(1000, "one_k_frames")
  bm.profile("one")
  bm.benchmark_single(1000, "one_k_frames_after_profile")
  bm.profile("oneafter")
  bm.prof_loops = 10
  bm.profile("ten")
  bm.prof_loops = 20
  bm.profile("twenty")
else
  bm.benchmark
end

