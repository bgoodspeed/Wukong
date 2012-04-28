# To change this template, choose Tools | Templates
# and open the template in the editor.

class ArtificialIntelligence
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
