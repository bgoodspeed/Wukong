$: << "lib"

require "benchmark"
require 'game'
class GameBM
  attr_accessor :game
  def initialize(f)
    @name = f
    @prof_loops = 1
    @game = YamlLoader.game_from_file(f)
    
    #@game.sound_controller.play_song("music", true)
  end

  def load_level
    @game.load_level(@game.new_game_level)
  end
  def profile(s="")
    require 'ruby-prof'
    RubyProf.start
    @prof_loops.times { @game.simulate }
    result = RubyProf.stop
    printer = RubyProf::MultiPrinter.new(result)
    
    Dir.mkdir "profile" unless File.exists?("profile")
    f = @name.gsub("/","_").gsub(" ", "_")
    p = "bm_load_#{@prof_loops}_#{f}_#{s}"
    printer.print(:path => "profile", :profile => p)

  end
  def benchmark(s = "")
    Benchmark.bm(7) do |m|
      m.report("#{s}first 1") {   10.times { @game.simulate}}
      m.report("#{s}next 10") {   10.times { @game.simulate}}
      m.report("#{s}last 100") {  100.times { @game.simulate}}
    end
  end
end
bm = GameBM.new("test-data/new_game_load_screen.yml")

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

