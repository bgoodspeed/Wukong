# To change this template, choose Tools | Templates
# and open the template in the editor.

module Health
  def dead?
    @stats.health <= 0
  end
  
  def take_damage(from)
    @stats.health -= 1
    if dead?
      @game.add_event(Event.new(self, EventTypes::DEATH))
    end
  end
  
end
