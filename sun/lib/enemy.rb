
class Enemy
  def initialize(avatar, window)
    @avatar = Guso::Image.new(window, avatar, true)
    @position = [0,0]
  end
end