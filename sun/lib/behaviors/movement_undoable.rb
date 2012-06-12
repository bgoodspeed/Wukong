# To change this template, choose Tools | Templates
# and open the template in the editor.

module MovementUndoable

  def undo_last_move(scale=1)
    unless @last_move.nil?
      tmp = GVector.xy(0,0) #NOTE temporary vector allocation
      tmp_s = GVector.xy(0,0) #NOTE temporary vector allocation

      @last_move.scale(tmp_s, scale)
      @position.minus(tmp,  tmp_s)
      @position = tmp
      @last_move = nil
    end
  end
end
