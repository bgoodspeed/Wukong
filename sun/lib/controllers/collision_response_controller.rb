# To change this template, choose Tools | Templates
# and open the template in the editor.

module ResponseTypes
  TRIGGER_EVENT1 = :trigger_event1
  TRIGGER_EVENT2 = :trigger_event2
  BLOCKED_LINE_OF_SIGHT1 = :block_line_of_sight1
  BLOCKED_LINE_OF_SIGHT2 = :block_line_of_sight2
  BLOCKING1 = :blocking1
  BLOCKING2 = :blocking2
  REMOVING1 = :removing1
  REMOVING2 = :removing2
  DAMAGING1 = :damaging1
  DAMAGING2 = :damaging2
  SHOW_DAMAGE1 = :show_damage1
  CHECK_HEALTH1 = :check_health1
  SHOW_DAMAGE2 = :show_damage2
  MOUSE_PICK1 = :mouse_pick1
  MOUSE_PICK2 = :mouse_pick2
  TEMPORARY_MESSAGE1 = :temporary_message1
  SHOW_INFO_WINDOW1 = :show_info_window1
  SHOW_INFO_WINDOW2 = :show_info_window2
end

class Collision
  attr_reader :dynamic1, :dynamic2
  def initialize(dynamic, dynamic2)
    @dynamic1 = dynamic
    @dynamic2 = dynamic2
  end
  def collision_priority
    @dynamic1.collision_priority + @dynamic2.collision_priority
  end
  alias_method :static, :dynamic1
  alias_method :dynamic, :dynamic2
end


class CollisionResponseController
  extend YamlHelper


  def self.default_config
    {
      "EventEmitter" => {

        "Player" => [ResponseTypes::TRIGGER_EVENT1]
      },
      "LineOfSightQuery" => {
        "LineSegment" => [ResponseTypes::BLOCKED_LINE_OF_SIGHT1],
      },
      "Weapon" => {
        "LineSegment" => []
      },
      "LineSegment" => {
        "Player" => [ResponseTypes::BLOCKING2],
        "VectorFollower" => [ResponseTypes::REMOVING2],
        "Enemy" => [ResponseTypes::BLOCKING2],
        "LineOfSightQuery" => [ResponseTypes::BLOCKED_LINE_OF_SIGHT2]
      },
      "Enemy" => {
        "Enemy" => [],
        "VectorFollower" => [ResponseTypes::DAMAGING1, ResponseTypes::REMOVING2, ResponseTypes::SHOW_DAMAGE1],
        "LineSegment" => [ResponseTypes::BLOCKING1],
        "MouseCollisionWrapper" => [ResponseTypes::MOUSE_PICK1],
        "Weapon" => [ResponseTypes::DAMAGING1],
        "LineOfSightQuery" => []
      },
      "VectorFollower" => {
        "Player" => [],
        "Enemy" => [ResponseTypes::DAMAGING2, ResponseTypes::REMOVING1, ResponseTypes::SHOW_DAMAGE2],
        "LineSegment" => [ResponseTypes::REMOVING1]
      },
      "Player" => {
        "LineSegment" => [ResponseTypes::BLOCKING1],
        "VectorFollower" => [], #TODO unrealistic
        "EventArea" => [ResponseTypes::SHOW_INFO_WINDOW2],
        "Enemy" => [
            ResponseTypes::DAMAGING1, ResponseTypes::DAMAGING2, ResponseTypes::BLOCKING1, ResponseTypes::SHOW_DAMAGE1,
                  ResponseTypes::SHOW_DAMAGE2
        ],
        "EventEmitter" => [ResponseTypes::TRIGGER_EVENT2],
        "MouseCollisionWrapper" => [ResponseTypes::MOUSE_PICK1],
        "Weapon" => [], #TODO unrealistic
        "LineOfSightQuery" => []
      },
    }
  end
  def initialize(game, config=CollisionResponseController.default_config)
    @game = game
    @config = config
  end

  def empty_collision (c1,c2)
    @game.log.error "Error: unknown response pair #{c1} <-> #{c2}"
    []
  end

  def responses
    @game.action_controller.collision_responses
  end


  def response(col)
    m = @config
    return empty_collision(col.dynamic1, col.dynamic2) unless m.has_key? col.dynamic1.collision_response_type
    return empty_collision(col.dynamic1, col.dynamic2) unless m[col.dynamic1.collision_response_type].has_key? col.dynamic2.collision_response_type
    m[col.dynamic1.collision_response_type][col.dynamic2.collision_response_type]
  end
  
  def handle_collisions(collisions)
    collisions.each {|col|
        response(col).each do |response|
          responses[response].call(@game, col)
        end
    }
  end
end
