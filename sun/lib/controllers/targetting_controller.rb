# To change this template, choose Tools | Templates
# and open the template in the editor.

class HitOddsCalculator
  #NOTE assumes a fixed initial constant
  # N(t) = N_0 e^(-lambda*t)
  def initialize(chance_at_fixed_threshold=0.1)
    @chance_at_fixed_threshold = chance_at_fixed_threshold
  end

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
