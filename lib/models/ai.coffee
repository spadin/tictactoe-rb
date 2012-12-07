class AI
  constructor: ({@marker, @board, @playerNumber}) ->
    @playerType = 'AI'
    @setOpponentMarker()


  move: (cb) ->
    if Worker?
      @worker = new Worker('lib/tictactoe-worker.js')

      @worker.addEventListener "message", (e) => 
        cb(e.data.move) if e.data.cmd is 'done'
        console.log.apply(console, e.data.args) if e.data.cmd is 'console'
        $(@).trigger 'progress', e.data.progress if e.data.cmd is 'progress'

      @worker.postMessage 
        cmd: "bestMove"
        marker: @marker
        boardArray: @board.board
        history: @board.history

    else
      setTimeout((=>
        [move, score] = @bestMove()
        cb(move)
      ), 0)


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