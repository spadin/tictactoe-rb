(function() {
  var __slice = [].slice;

  window.namespace = function(target, name, block) {
    var item, top, _i, _len, _ref, _ref1;
    if (arguments.length < 3) {
      _ref = [(typeof exports !== 'undefined' ? exports : window)].concat(__slice.call(arguments)), target = _ref[0], name = _ref[1], block = _ref[2];
    }
    top = target;
    _ref1 = name.split('.');
    for (_i = 0, _len = _ref1.length; _i < _len; _i++) {
      item = _ref1[_i];
      target = target[item] || (target[item] = {});
    }
    return block(target, top);
  };

}).call(this);

(function() {
  var Player;

  Player = (function() {

    function Player() {}

    Player.prototype.move = function(board) {};

    return Player;

  })();

  namespace('TicTacToe', function(exports) {
    return exports.Player = Player;
  });

}).call(this);

(function() {
  var AI,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  AI = (function(_super) {

    __extends(AI, _super);

    function AI(_arg) {
      this.marker = _arg.marker, this.board = _arg.board, this.playerNumber = _arg.playerNumber;
      AI.__super__.constructor.call(this);
      this.playerType = 'AI';
      this.setOpponentMarker();
    }

    AI.prototype.move = function() {
      var move, score, _ref;
      _ref = this.bestMove(), move = _ref[0], score = _ref[1];
      return move;
    };

    AI.prototype.setOpponentMarker = function() {
      this.opponentMarker = 'X';
      if (this.marker === 'X') {
        return this.opponentMarker = 'O';
      }
    };

    AI.prototype.bestMove = function() {
      var bestMove, highestScore, _ref,
        _this = this;
      _ref = [null, null], highestScore = _ref[0], bestMove = _ref[1];
      _(this.board.freePositions()).each(function(position) {
        var movePosition, score, _ref1;
        _this.board.mark(position, _this.marker, false);
        if (_this.board.isGameover()) {
          score = _this.getScore();
        } else {
          _ref1 = _this.worstMove(), movePosition = _ref1[0], score = _ref1[1];
        }
        _this.board.undoLastMove();
        if (highestScore === null || score > highestScore) {
          highestScore = score;
          return bestMove = position;
        }
      });
      return [bestMove, highestScore];
    };

    AI.prototype.worstMove = function() {
      var lowestScore, worstMove, _ref,
        _this = this;
      _ref = [null, null], lowestScore = _ref[0], worstMove = _ref[1];
      _(this.board.freePositions()).each(function(position) {
        var movePosition, score, _ref1;
        _this.board.mark(position, _this.opponentMarker, false);
        if (_this.board.isGameover()) {
          score = _this.getScore();
        } else {
          _ref1 = _this.bestMove(), movePosition = _ref1[0], score = _ref1[1];
        }
        _this.board.undoLastMove();
        if (lowestScore === null || score < lowestScore) {
          lowestScore = score;
          return worstMove = position;
        }
      });
      return [worstMove, lowestScore];
    };

    AI.prototype.getScore = function() {
      var score;
      score = 0;
      if (this.board.winner) {
        if (this.board.winner.marker === this.marker) {
          score = 1;
        } else if (this.board.winner.marker === this.opponentMarker) {
          score = -1;
        }
      }
      return score;
    };

    return AI;

  })(TicTacToe.Player);

  namespace('TicTacToe', function(exports) {
    return exports.AI = AI;
  });

}).call(this);

(function() {
  var Human,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Human = (function(_super) {

    __extends(Human, _super);

    function Human(_arg) {
      this.marker = _arg.marker, this.board = _arg.board, this.playerNumber = _arg.playerNumber;
      Human.__super__.constructor.call(this);
      this.playerType = 'Human';
    }

    return Human;

  })(TicTacToe.Player);

  namespace('TicTacToe', function(exports) {
    return exports.Human = Human;
  });

}).call(this);

(function() {
  var Board,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Board = (function(_super) {

    __extends(Board, _super);

    function Board() {
      this.handleHumanSelect = __bind(this.handleHumanSelect, this);

      this.handleAISelect = __bind(this.handleAISelect, this);
      return Board.__super__.constructor.apply(this, arguments);
    }

    Board.prototype.initialize = function() {
      var i;
      this.history = [];
      this.winner = null;
      this.board = (function() {
        var _i, _results;
        _results = [];
        for (i = _i = 0; _i <= 8; i = ++_i) {
          _results.push('-');
        }
        return _results;
      })();
      this.winningCombinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]];
      this.prepare();
      return this.render();
    };

    Board.prototype.turn = function(playerNumber) {
      var _this = this;
      this.currentPlayer = this["p" + playerNumber];
      this.$el.off("click", ".square-empty", this.handleHumanSelect);
      this.message.text("Player " + playerNumber + "'s turn, ");
      if (this.currentPlayer.playerType === 'Human') {
        this.message.append("please choose.");
        return this.$el.on("click", ".square-empty", this.handleHumanSelect);
      } else {
        this.message.append("please wait.");
        return setTimeout((function() {
          return _this.handleAISelect(_this.currentPlayer.move());
        }), 0);
      }
    };

    Board.prototype.nextTurn = function() {
      var message, nextPlayer;
      if (!this.isGameover()) {
        nextPlayer = 1;
        if ((this.currentPlayer != null) && this.currentPlayer.playerNumber === 1) {
          nextPlayer = 2;
        }
        return this.turn(nextPlayer);
      } else {
        message = "Gameover. ";
        this.message.text("Gameover. ");
        if (this.winner) {
          message += "Player " + this.winner.playerNumber + " has won.";
        } else {
          message += "No one wins.";
        }
        return this.message.html(tttTemplates['gameover']({
          message: message
        }));
      }
    };

    Board.prototype.prepare = function() {
      var p1data, p2data;
      if (!_(['hh', 'ha', 'ah', 'aa']).include(this.options.gameType)) {
        throw 'invalid-gametype';
      }
      p1data = {
        marker: 'X',
        board: this,
        playerNumber: 1
      };
      p2data = {
        marker: 'O',
        board: this,
        playerNumber: 2
      };
      if (this.options.gameType[0] === 'h') {
        this.p1 = new TicTacToe.Human(p1data);
      } else {
        this.p1 = new TicTacToe.AI(p1data);
      }
      if (this.options.gameType[1] === 'h') {
        return this.p2 = new TicTacToe.Human(p2data);
      } else {
        return this.p2 = new TicTacToe.AI(p2data);
      }
    };

    Board.prototype.render = function() {
      var i, _i;
      this.$el.empty();
      this.$el.html(tttTemplates['board']());
      this.message = $(".message", this.$el);
      for (i = _i = 0; _i <= 8; i = ++_i) {
        $(".pieces", this.$el).append(tttTemplates['square']({
          className: this.getSquareClassName(this.board[i]),
          mark: this.board[i]
        }));
      }
      return this.nextTurn();
    };

    Board.prototype.getSquareClassName = function(square) {
      if (square === 'X') {
        return 'square-x';
      } else if (square === 'O') {
        return 'square-o';
      } else {
        return 'square-empty';
      }
    };

    Board.prototype.handleAISelect = function(position) {
      return this.mark(position, this.currentPlayer.marker);
    };

    Board.prototype.handleHumanSelect = function(evt) {
      var position, target;
      target = $(evt.currentTarget);
      position = $(".square", this.$el).index(target);
      return this.mark(position, this.currentPlayer.marker);
    };

    Board.prototype.mark = function(position, marker, render) {
      if (render == null) {
        render = true;
      }
      if (_(this.history).include(position)) {
        throw 'invalid-move';
      }
      this.history.push(position);
      this.board[position] = marker;
      if (render) {
        return this.render();
      }
    };

    Board.prototype.undoLastMove = function() {
      var position;
      this.winner = null;
      position = this.history.pop();
      return this.board[position] = "-";
    };

    Board.prototype.isGameover = function() {
      this.winner = null;
      if (this.winningCombinationExists()) {
        return true;
      } else if (this.history.length === 9) {
        return true;
      } else {
        return false;
      }
    };

    Board.prototype.winningCombinationExists = function() {
      var p1moves, p2moves, winningCombination, _ref,
        _this = this;
      winningCombination = false;
      _ref = this.getPlayerMoves(), p1moves = _ref[0], p2moves = _ref[1];
      _(this.winningCombinations).each(function(combination) {
        if (_(combination).chain().intersection(p1moves).isEqual(combination).value()) {
          _this.winner = _this.p1;
          winningCombination = true;
        }
        if (_(combination).chain().intersection(p2moves).isEqual(combination).value()) {
          _this.winner = _this.p2;
          return winningCombination = true;
        }
      });
      return winningCombination;
    };

    Board.prototype.getPlayerMoves = function() {
      var p1moves, p2moves,
        _this = this;
      p1moves = [];
      p2moves = [];
      _(this.board).each(function(mark, position) {
        if (mark === 'X') {
          p1moves.push(position);
        }
        if (mark === 'O') {
          return p2moves.push(position);
        }
      });
      return [p1moves, p2moves];
    };

    Board.prototype.freePositions = function() {
      var freePositions, position, _i;
      freePositions = [];
      for (position = _i = 0; _i <= 8; position = ++_i) {
        if (this.board[position] === '-') {
          freePositions.push(position);
        }
      }
      return freePositions;
    };

    return Board;

  })(Backbone.View);

  namespace('TicTacToe', function(exports) {
    return exports.Board = Board;
  });

}).call(this);

(function() {
  var Game,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Game = (function(_super) {

    __extends(Game, _super);

    function Game() {
      this.handleResetGame = __bind(this.handleResetGame, this);

      this.handleStartGame = __bind(this.handleStartGame, this);
      return Game.__super__.constructor.apply(this, arguments);
    }

    Game.prototype.initialize = function() {
      this.reset();
      this.$el.on("click", ".menu a", this.handleStartGame);
      return this.$el.on("click", "a[href='#reset']", this.handleResetGame);
    };

    Game.prototype.handleStartGame = function(evt) {
      var gameType, target;
      target = $(evt.currentTarget);
      gameType = target.attr("href").replace("#", "");
      this.start(gameType);
      return false;
    };

    Game.prototype.handleResetGame = function(evt) {
      this.reset();
      return false;
    };

    Game.prototype.start = function(gameType) {
      this.gameBoard.show();
      this.startScreen.hide();
      return this.board = new TicTacToe.Board({
        el: this.gameBoard,
        gameType: gameType
      });
    };

    Game.prototype.reset = function() {
      this.$el.html(tttTemplates['game']);
      this.startScreen = $(".start-screen", this.$el);
      this.gameBoard = $(".game-board", this.$el);
      this.gameBoard.hide();
      return this.startScreen.show();
    };

    return Game;

  })(Backbone.View);

  namespace('TicTacToe', function(exports) {
    return exports.Game = Game;
  });

}).call(this);
