class AI extends TicTacToe.Player
  constructor: ({@marker, @board, @playerNumber}) ->
    super()
    @playerType = 'AI'
    @setOpponentMarker()

  move: ->
    [move, score] = @bestMove()
    move

  setOpponentMarker: ->
    # Two markers are available [X, O]. Opponent marker is set to the marker 
    # that is not our marker.
    @opponentMarker = 'X'
    @opponentMarker = 'O' if @marker is 'X'

  bestMove: ->
    [highestScore, bestMove] = [null, null]

    _(@board.freePositions()).each (position) =>
      @board.mark(position, @marker, false)
      if @board.isGameover()
        score = @getScore()
      else
        [movePosition, score] = @worstMove()

      @board.undoLastMove()

      if highestScore is null or score > highestScore
        highestScore = score
        bestMove = position

    [bestMove, highestScore]

  worstMove: ->
    [lowestScore, worstMove] = [null, null]

    _(@board.freePositions()).each (position) =>
      @board.mark(position, @opponentMarker, false)
      if @board.isGameover()
        score = @getScore()
      else
        [movePosition, score] = @bestMove()

      @board.undoLastMove()

      if lowestScore is null or score < lowestScore
        lowestScore = score
        worstMove = position

    [worstMove, lowestScore]

  getScore: ->
    score = 0
    if @board.winner
      if @board.winner.marker is @marker
        score =  1 
      else if @board.winner.marker is @opponentMarker
        score = -1 

    score

namespace 'TicTacToe', (exports) ->
  exports.AI = AI