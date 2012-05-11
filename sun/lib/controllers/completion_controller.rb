
class CompletionCondition
  ATTRIBUTES = [:condition, :argument]
  ATTRIBUTES.each {|attribute| attr_accessor attribute }
  include YamlHelper

  def initialize(conf)
    process_attributes(ATTRIBUTES, self, conf)
  end
  def valid?(attrs=ATTRIBUTES)
    attrs.each {|attr| return false if self.send(attr).nil?}
    true
  end
end

class CompletionController
  def initialize(game)
    @game = game
  end

  def check_conditions_or(conds)
    conds.each do |cond|
      return true if @game.condition_controller.condition_met?(cond.condition, cond.argument)
    end
    conds.empty? ? true : false
  end
  def check_conditions_and(conds)
    conds.each do |cond|
      return false unless @game.condition_controller.condition_met?(cond.condition, cond.argument)
    end
    true
  end
end
