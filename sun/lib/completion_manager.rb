
class CompletionCondition
  attr_reader :condition, :argument
  def initialize(condition, argument)
    @condition, @argument = condition, argument
  end
end

class CompletionManager
  def initialize(game)
    @game = game
  end

  def check_conditions_or(conds)
    conds.each do |cond|
      return true if @game.condition_manager.condition_met?(cond.condition, cond.argument)
    end
    false
  end
  def check_conditions_and(conds)
    conds.each do |cond|
      return false unless @game.condition_manager.condition_met?(cond.condition, cond.argument)
    end
    true
  end
end
