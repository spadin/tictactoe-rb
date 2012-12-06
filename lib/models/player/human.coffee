class Human extends TicTacToe.Player
  constructor: ({@marker, @board, @playerNumber}) ->
    super()
    @playerType = 'Human'

namespace 'TicTacToe', (exports) ->
  exports.Human = Human