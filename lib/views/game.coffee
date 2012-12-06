class Game extends Backbone.View
  initialize: ->
    @reset()
    @$el.on "click", ".menu a", @handleStartGame
    @$el.on "click", "a[href='#reset']", @handleResetGame

  handleStartGame: (evt) =>
    target = $(evt.currentTarget)
    gameType = target.attr("href").replace("#","")
    @start gameType
    false

  handleResetGame: (evt) =>
    @reset()
    false

  start: (gameType) ->
    @gameBoard.show()
    @startScreen.hide()
    @board = new TicTacToe.Board
      el: @gameBoard, 
      gameType: gameType

  reset: ->
    @$el.html tttTemplates['game']

    @startScreen = $(".start-screen", @$el)
    @gameBoard   = $(".game-board", @$el)

    @gameBoard.hide()
    @startScreen.show()

namespace 'TicTacToe', (exports) ->
  exports.Game = Game
    