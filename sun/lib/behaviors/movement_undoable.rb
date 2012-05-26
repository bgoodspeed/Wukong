# To change this template, choose Tools | Templates
# and open the template in the editor.

module MovementUndoable

  def undo_last_move
    unless @last_move.nil?
      tmp = GVector.xy(0,0) #NOTE temporary vector allocation
      @position.minus(tmp,  @last_move)
      @position = tmp
      @last_move = nil
    end
  end
end
