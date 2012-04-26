# To change this template, choose Tools | Templates
# and open the template in the editor.

class InfoWindow
  attr_accessor :description, :position
  def initialize(description, position=nil)
    @description = description
    @position = position
  end
end
