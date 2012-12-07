class Board extends Backbone.View
  initialize: ->
    @history = []
    @winner = null
    @board = ('-' for i in [0..8])
    @winningCombinations = [
      [0,1,2], [3,4,5], [6,7,8],  # Horizontal
      [0,3,6], [1,4,7], [2,5,8],  # Vertical
      [0,4,8], [2,4,6]            # Diagonal
    ]
    @prepare()
    @render()

  turn: (playerNumber) ->
    @currentPlayer = @["p#{playerNumber}"]
    @$el.off "click", ".square-empty", @handleHumanSelect

    @message.text "Player #{playerNumber}'s turn, "
    if @currentPlayer.playerType is 'Human'
      @message.append "please choose."
      @$el.on "click", ".square-empty", @handleHumanSelect
    else
      @message.append "please wait. <span class='progress'></span>"
      $(@currentPlayer).on "progress", (evt, progress) ->
        percentage = (progress*100).toFixed(2)
        $(".progress", @message).text "#{percentage}%"
        $(@currentPlayer).off "progress"
      @currentPlayer.move (move) => @handleAISelect(move)

  nextTurn: ->
    unless @isGameover()
      nextPlayer = 1
      nextPlayer = 2 if @currentPlayer? and @currentPlayer.playerNumber is 1
      @turn nextPlayer
    else
      message = "Gameover. "
      @message.text "Gameover. "
      if @winner
        message += "Player #{@winner.playerNumber} has won."
      else
        message += "No one wins."

      @message.html tttTemplates['gameover']({message})
        

  prepare: ->
    # Validating gameType. Possibilities include [hh, ha, ah, aa]
    throw 'invalid-gametype' unless _(['hh','ha', 'ah', 'aa']).include(@options.gameType)

    p1data = 
      marker: 'X'
      board: @
      playerNumber: 1

    p2data =
      marker: 'O'
      board: @
      playerNumber: 2

    if @options.gameType[0] is 'h'
      @p1 = new TicTacToe.Human(p1data)
    else
      @p1 = new TicTacToe.AI(p1data)

    if @options.gameType[1] is 'h'
      @p2 = new TicTacToe.Human(p2data)
    else
      @p2 = new TicTacToe.AI(p2data)

  render: ->
    @$el.empty()
    @$el.html tttTemplates['board']()
    @message = $(".message", @$el)
    for i in [0..8]
      $(".pieces", @$el).append tttTemplates['square']
        className: @getSquareClassName(@board[i])
        mark: @board[i]

    @nextTurn()

  getSquareClassName: (square) ->
    if square is 'X'
      'square-x'
    else if square is 'O'
      'square-o'
    else
      'square-empty'

  handleAISelect: (position) =>
    @mark position, @currentPlayer.marker

  handleHumanSelect: (evt) =>
    target = $(evt.currentTarget)
    position = $(".square", @$el).index(target)
    @mark position, @currentPlayer.marker

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
        @winner = @p1
        winningCombination = true

      if @p2moves[combination[0]] and @p2moves[combination[1]] and @p2moves[combination[2]]
        @winner = @p2
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


namespace 'TicTacToe', (exports) ->
  exports.Board = Board