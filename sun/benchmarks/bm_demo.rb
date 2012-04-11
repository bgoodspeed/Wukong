$: << "lib"

require "benchmark"
require 'game'
class GameBM
  attr_accessor :game
  def initialize(f)
    @name = f
    @prof_loops = 123
    @game = YamlLoader.game_from_file(f)
    #@game.sound_manager.play_song("music", true)
  end

  def profile
    require 'ruby-prof'
    RubyProf.start
    @prof_loops.times { @game.simulate }
    result = RubyProf.stop
    ignores = [
      /Kernel/,
      /String/,
      /Integer/,
      /.*RSpec.*/,
      /.*Mocha.*/,
      /Object/,
      /Symbol/,
      /Module/,
      /Proc/,
      /Fixnum/,
      /Float/,
      /Class/,
      /Mocha/,
      /NilClass/,
      /MatchData/,
      /Hash/,
    ]
    result.eliminate_methods!(ignores)
    printer = RubyProf::MultiPrinter.new(result)
    
    Dir.mkdir "profile" unless File.exists?("profile")
    f = @name.gsub("/","_")
    p = "bm_demo_#{@prof_loops}_#{f}"
    printer.print(:path => "profile", :profile => p)

  end
  def benchmark
    Benchmark.bm(7) do |m|
      m.report("first 10") {   10.times { @game.simulate}}
      m.report("next 100") {  100.times { @game.simulate}}
      m.report("last 1000"){ 1000.times { @game.simulate}}
    end
  end
end
bm = GameBM.new("game-data/game.yml")

if $0 == __FILE__
  bm.profile
  bm.benchmark
  #bm.game.show
else
  bm.benchmark
end

