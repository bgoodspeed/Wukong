# To change this template, choose Tools | Templates
# and open the template in the editor.

class ConditionManager
  def initialize(game)
    @game = game

    @nearness = 5.0 #TODO make this configurable

    @conditions = {
      "COND" => lambda {|game, arg| true}, #TODO this is pretty much equivalent to COND == NEVER rename
      "number_of_frames" => lambda {|game, frames| @game.clock.frames_rendered >= frames.to_i},
      "player_health_at_least" => lambda {|game, hp| @game.player.health >= hp.to_i}, 
      "enemies_killed_at_least" => lambda {|game, dead| @game.player.enemies_killed >= dead.to_i }, 
      "player_near" => lambda {|game, point| @game.player.position.distance_from(point) <= @nearness },
    }
  end
  def register_condition(name, cond)
    @conditions[name] = cond
  end
  def condition_met?(name, arg=nil)
    raise "unknown condition: #{name}" unless @conditions.has_key? name
    @conditions[name].call(@game, arg)
  end
end
