# To change this template, choose Tools | Templates
# and open the template in the editor.

class PickEvent
  attr_reader :picked
  def initialize(game, picked)
    @game = game
    @picked = picked

  end
end
