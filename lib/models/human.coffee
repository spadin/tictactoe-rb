class Human
  constructor: ({@marker, @board, @playerNumber}) ->
    @playerType = 'Human'

namespace 'TicTacToe', (exports) ->
  exports.Human = Human