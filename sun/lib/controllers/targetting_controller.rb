# To change this template, choose Tools | Templates
# and open the template in the editor.

class HitOddsCalculator
  #NOTE: N(t) = N_0 e^(-lambda*t)
  def decay_at(distance, distance_threshold)
    decay_constant = 4.5/distance_threshold.to_f
    # decay_constant /= 5
    (100 - Math::E ** (decay_constant * distance))
  end
  def odds_for_distance_and_threshold(distance, distance_threshold)
    (decay_at(distance, distance_threshold)).to_i
  end
end
class Targetable
  attr_accessor :target
  def initialize(game, target)
    @game = game
    @target = target
    @odds_calculator = HitOddsCalculator.new
  end

  def vector_to_target
    tmp = GVector.xy(0,0) #NOTE temporary vector allocation
    @target.position.minus(tmp, @game.player.position)
    tmp
  end

  def distance_to_target
    @target.position.distance_from(@game.player.position)
  end

  def hit_odds_for_target
    @odds_calculator.odds_for_distance_and_threshold(distance_to_target, @game.player.accuracy)
  end
end

class TargettingController
  attr_accessor :active, :target_distance_threshold
  def initialize(game)
    @game = game
    @active = false
    @target_list = nil
    @target_distance_threshold = 400
  end

  def target_list
    return @target_list if @target_list

    #TODO maybe we also want destructables to go here
    @target_list = @game.level.targettable_enemies.collect {|e| Targetable.new(@game, e)}
    @target_list
  end
end
