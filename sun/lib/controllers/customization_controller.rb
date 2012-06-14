class CustomizationController
  attr_reader :primary, :secondary
  def initialize(game)
    @game = game
  end

  def select_for_customization(item)
    if @primary.nil?
      @primary = item
      return
    end
    if @secondary.nil?
      @secondary = item
      return
    end
    puts "Already fully selected, handle this scenario"

  end

  def clear
    @primary = nil
    @secondary = nil

  end
end