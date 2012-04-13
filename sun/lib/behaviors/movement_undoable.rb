# To change this template, choose Tools | Templates
# and open the template in the editor.

module MovementUndoable

  def undo_last_move
    unless @last_move.nil?
      @position = @position.minus @last_move
      @last_move = nil
    end
  end
end
