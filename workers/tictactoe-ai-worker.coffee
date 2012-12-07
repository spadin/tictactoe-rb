console = {}
console.log = (args...) -> self.postMessage({cmd: "console", args: args})

class WorkerBoard
  constructor: (@board, @history) ->
    @winner = null
    @winningCombinations = [
      [0,1,2], [3,4,5], [6,7,8],  # Horizontal
      [0,3,6], [1,4,7], [2,5,8],  # Vertical
      [0,4,8], [2,4,6]            # Diagonal
    ]

  mark: (position, marker, render = true) ->
    throw 'invalid-move' if _(@history).include(position)
    @history.push position
    @board[position] = marker
    @updatePlayerMoves()
    @checkGameover()
    @render() if render

  undoLastMove: ->
    @winner = null
    position = @history.pop()
    @board[position] = "-"

  checkGameover: ->
    @winner = null
    if @winningCombinationExists()
      @gameover = true
    else if @history.length is 9
      @gameover = true
    else
      @gameover = false

  isGameover: -> @gameover

  winningCombinationExists: ->
    winningCombination = false

    _(@winningCombinations).each (combination) =>
      if @p1moves[combination[0]] and @p1moves[combination[1]] and @p1moves[combination[2]]
        @winner = {marker: 'X', playerNumber: 1}
        winningCombination = true

      if @p2moves[combination[0]] and @p2moves[combination[1]] and @p2moves[combination[2]]
        @winner = {marker: 'O', playerNumber: 1}
        winningCombination = true

    winningCombination

  updatePlayerMoves: ->
    @p1moves = new Array(9)
    @p2moves = new Array(9)
    
    _(@board).each (mark, position) =>
      @p1moves[position] = false
      @p2moves[position] = false

      @p1moves[position] = true if mark is 'X'
      @p2moves[position] = true if mark is 'O'

  freePositions: ->
    freePositions = []
    for position in [0..8] 
      freePositions.push(position) if @board[position] is '-'
    freePositions

class WorkerAI
  constructor: (@marker, @boardArray, @history) ->
    @board = new WorkerBoard(@boardArray, @history)
    @setOpponentMarker()

  setOpponentMarker: ->
    # Two markers are available [X, O]. Opponent marker is set to the marker 
    # that is not our marker.
    @opponentMarker = 'X'
    @opponentMarker = 'O' if @marker is 'X'

  sendProgress: (progress) ->
    self.postMessage({cmd: "progress", progress: progress})

  bestMove: (progress = false) ->
    [highestScore, bestMove] = [null, null]
    freePositions = @board.freePositions()

    _(freePositions).each (position, i) =>
      @sendProgress(i/freePositions.length) if progress

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

handler = (e) ->
  if e.data.cmd is "bestMove"
    ai = new WorkerAI(e.data.marker, e.data.boardArray, e.data.history)
    [move, score] = ai.bestMove(true)
    self.postMessage({move: move, cmd: "done"})

self.addEventListener 'message', handler, false
