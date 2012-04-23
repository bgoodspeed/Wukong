# To change this template, choose Tools | Templates
# and open the template in the editor.

class HitOddsCalculator
  def odds_for_distance_and_threshold(distance, distance_threshold)
    #n_zero = 0.1/(Math::e ** -
    #TODO use exponential decay, solving for lambda such that threshold => 10% chance
    
    0
  end
end
class Targetable
  attr_accessor :target
  def initialize(game, target)
    @game = game
    @target = target
  end

  def vector_to_target
    @target.position.minus(@game.player.position)
  end

  def distance_to_target
    @target.position.distance_from(@game.player.position)
  end
end

class TargettingController
  attr_accessor :active
  def initialize(game)
    @game = game
    @active = false
    @target_list = nil
  end

  def target_list
    return @target_list if @target_list

    #TODO maybe we also want destructables to go here
    @target_list = @game.level.enemies.collect {|e| Targetable.new(@game, e)}
    @target_list
  end
end
