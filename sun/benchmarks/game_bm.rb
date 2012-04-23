# To change this template, choose Tools | Templates
# and open the template in the editor.

class GameBM
  attr_accessor :game
  def initialize(f, bm="unknown")
    @name = f
    @prof_loops = 1
    @bm = bm
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
    p = "bm_#{@bm}_#{@prof_loops}_#{f}_#{s}"
    printer.print(:path => "profile", :profile => p)

  end

  def max_enemies
    @game.level.max_enemies
  end
  def max_enemies=(v)
    @game.level.max_enemies=v
  end
  def benchmark(s = "")
    Benchmark.bm(7) do |m|
      m.report("#{s}first 1") {   10.times { @game.simulate}}
      m.report("#{s}next 10") {   10.times { @game.simulate}}
      m.report("#{s}last 100") {  100.times { @game.simulate}}
    end
  end
  def benchmark_single(n, s = "")
    Benchmark.bm(3) do |m|
      m.report("#{s} #{n} loops") {  n.times { @game.simulate}}
    end
  end

  def unthrottle
    @game.clock.throttle = false
  end

end
