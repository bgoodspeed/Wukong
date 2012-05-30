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
    acc = @game.player.effective_accuracy
    @odds_calculator.odds_for_distance_and_threshold(distance_to_target, acc)
  end
end

class TargettingController
  attr_accessor :active, :target_distance_threshold, :target_index, :target_list, :action_queue
  def initialize(game)
    @game = game
    @active = false
    @target_list = nil
    @target_distance_threshold = 400
    @action_energy_cost = 100
    @target_index = 0
    @action_queue = []
  end

  def move_to_next_lower
    @target_index = (@target_index - 1) % target_list.size
  end
  def move_to_next_higher
    @target_index = (@target_index + 1) % target_list.size
  end


  def action_queue_cost
    @action_queue.size * @action_energy_cost
  end

  def cancel_last_attack
    @action_queue.delete_at(@action_queue.size - 1)
  end

  def queue_attack_on_current
    new_cost = action_queue_cost + @action_energy_cost
    return false if new_cost > @game.player.energy_points
    @action_queue << current_target
    true
  end
  def current_target
    target_list[@target_index]
  end
  def target_list
    return @target_list if @target_list

    #TODO maybe we also want destructables to go here
    @target_list = @game.level.targettable_enemies.collect {|e| Targetable.new(@game, e)}
    @target_list
  end

  def invoke_action_queue
    @game.player.energy_points -= action_queue_cost
    results = @action_queue.collect do |target|
      odds = target.hit_odds_for_target
      if rand(100) > odds
        [target, "miss"]
      else
        [target, target.target.take_damage(@game.player)]
      end
    end

    @target_list = nil
    @action_queue = []
    @active = false
    results
  end
end
