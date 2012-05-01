class SpawnPoint
  attr_reader :enemy_quantity, :frequency, :total_time, :condition
  attr_accessor :point, :name, :spawn_schedule, :spawn_argument
  def initialize(game, point, name, spawn_schedule, spawn_argument)
    @game = game
    @point, @name, @spawn_schedule, @spawn_argument = point, name, spawn_schedule, spawn_argument
    calculate_properties_from(@spawn_schedule)
  end

  def calculate_properties_from(s)
    re = /(?<eq>\d+) enemies every (?<fr>\d+) ticks for (?<tt>\d+) total ticks/
    d = re.match(s)
    @enemy_quantity = d["eq"].to_i
    @frequency = d["fr"].to_i
    @total_time = d["tt"].to_i
    @total_time = nil if @total_time == 0

    cond = /until (?<cnd>\w+)/
    if s =~ cond
      c = cond.match(s)
      @condition = c['cnd']
    end
  end

  def old_enough?(v)
    return true if v.nil?
    (@game.clock.current_tick - v) >= @frequency
  end

  def too_old?(v)
    return false if v.nil?
    return false if @total_time.nil?
    (@game.clock.current_tick - v) >= @total_time
  end
  def active_by_clock?
    old_enough?(@last_spawn_time) && !too_old?(@first_spawn_time)
  end
  def stopped_by_cond?
    return false if @condition.nil?
    @game.condition_controller.condition_met?(@condition)
  end

  def enqueue_events
    t = @game.clock.current_tick
    @first_spawn_time = t if @first_spawn_time.nil?
    @last_spawn_time = t
    @spawn_argument.each do |enemy_name|
      @enemy_quantity.times do
        orig_enemy = @game.level.declared_enemy(enemy_name)
        enemy = orig_enemy.dup
        enemy.position = @point
        @game.animation_controller.add_entity_equivalance(enemy, orig_enemy)
        @game.add_event(Event.new(enemy, EventTypes::SPAWN))
      end
    end
  end

end
