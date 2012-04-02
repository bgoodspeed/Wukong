# To change this template, choose Tools | Templates
# and open the template in the editor.

class ConditionManager
  def initialize(game)
    @game = game
    @conditions = {
      "COND" => lambda {|game| true} #TODO this is pretty much equivalent to COND == NEVER rename
    }
  end
  def register_condition(name, cond)
    @conditions[name] = cond
  end
  def condition_met?(name)
    raise "unknown condition: #{name}" unless @conditions.has_key? name
    @conditions[name].call(@game)
  end
end
