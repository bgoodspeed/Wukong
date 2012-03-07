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
  def self.from_yaml(yaml)
    data = YAML.load(yaml)
    statemachine = Statemachine.build do
      data['strategy']['states'].each do |stateconf|
        stateconf.each do |state_name, targets|
          targets.each do |target|
            target.each do |action_condition, dest_state|
              trans state_name.to_sym, action_condition.to_sym, dest_state.to_sym
            end
          end
        end
      end
    end

    self.new(statemachine)
  end
end
