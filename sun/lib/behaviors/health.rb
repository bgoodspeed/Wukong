# To change this template, choose Tools | Templates
# and open the template in the editor.


module Health
  def health_percent
    ((@stats.health.to_f/@stats.max_health.to_f)*100).to_i
  end

  def dead?
    @stats.health <= 0
  end

  def calculate_damage(from)
    [(from.effective_stats.strength - effective_stats.defense) + 1, 0].max
  end
  def take_damage(from)
    @stats.health -= calculate_damage(from)
    if dead?
      @game.add_event(Event.new(self, EventTypes::DEATH))
    end
  end
  
end
