# To change this template, choose Tools | Templates
# and open the template in the editor.
# Copyright 2012 Ben Goodspeed
class ArtificialIntelligence
  def self.default
    statemachine = Statemachine.build do
      trans "chase", :enemy_in_range, "chase"
      trans "chase", :enemy_lost, "chase"
      trans "chase", :enemy_too_far, "chase"
      trans "chase", :enemy_sighted, "chase"
    end

    self.new(statemachine)
  end
  def initialize(statemachine)
    @state_machine = statemachine
  end

  def start_state
    @state_machine.startstate
  end
  def current_state
    @state_machine.state
  end

  def trigger_event(event)
    @state_machine.send(event)
  end


end
