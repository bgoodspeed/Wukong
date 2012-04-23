$: << "lib"
$: << "benchmarks"
$: << "."

require "benchmark"
require 'game'
require 'game_bm'

bm = GameBM.new("test-data/enemy_overload.yml", "enemy_overload")

def msg(bm)
  ""
end

if $0 == __FILE__
  
  bm.benchmark_single(100, "withdefaultlimit#{bm.max_enemies}")
  bm.profile("withdefaultlimit#{bm.max_enemies}")
  bm.max_enemies = 15
  bm.benchmark_single(100, "withlimit#{bm.max_enemies}")
  bm.profile("withlimit#{bm.max_enemies}")
  bm.max_enemies = 50
  bm.benchmark_single(100, "withlimit#{bm.max_enemies}")
  bm.profile("withlimit#{bm.max_enemies}")
else
  bm.benchmark
end

