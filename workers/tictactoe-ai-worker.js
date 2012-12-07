(function() {
  var WorkerAI, WorkerBoard, console, handler,
    __slice = [].slice;

  console = {};

  console.log = function() {
    var args;
    args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    return self.postMessage({
      cmd: "console",
      args: args
    });
  };

  WorkerBoard = (function() {

    function WorkerBoard(board, history) {
      this.board = board;
      this.history = history;
      this.winner = null;
      this.winningCombinations = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]];
    }

    WorkerBoard.prototype.mark = function(position, marker, render) {
      if (render == null) {
        render = true;
      }
      if (_(this.history).include(position)) {
        throw 'invalid-move';
      }
      this.history.push(position);
      this.board[position] = marker;
      this.updatePlayerMoves();
      this.checkGameover();
      if (render) {
        return this.render();
      }
    };

    WorkerBoard.prototype.undoLastMove = function() {
      var position;
      this.winner = null;
      position = this.history.pop();
      return this.board[position] = "-";
    };

    WorkerBoard.prototype.checkGameover = function() {
      this.winner = null;
      if (this.winningCombinationExists()) {
        return this.gameover = true;
      } else if (this.history.length === 9) {
        return this.gameover = true;
      } else {
        return this.gameover = false;
      }
    };

    WorkerBoard.prototype.isGameover = function() {
      return this.gameover;
    };

    WorkerBoard.prototype.winningCombinationExists = function() {
      var winningCombination,
        _this = this;
      winningCombination = false;
      _(this.winningCombinations).each(function(combination) {
        if (_this.p1moves[combination[0]] && _this.p1moves[combination[1]] && _this.p1moves[combination[2]]) {
          _this.winner = {
            marker: 'X',
            playerNumber: 1
          };
          winningCombination = true;
        }
        if (_this.p2moves[combination[0]] && _this.p2moves[combination[1]] && _this.p2moves[combination[2]]) {
          _this.winner = {
            marker: 'O',
            playerNumber: 1
          };
          return winningCombination = true;
        }
      });
      return winningCombination;
    };

    WorkerBoard.prototype.updatePlayerMoves = function() {
      var _this = this;
      this.p1moves = new Array(9);
      this.p2moves = new Array(9);
      return _(this.board).each(function(mark, position) {
        _this.p1moves[position] = false;
        _this.p2moves[position] = false;
        if (mark === 'X') {
          _this.p1moves[position] = true;
        }
        if (mark === 'O') {
          return _this.p2moves[position] = true;
        }
      });
    };

    WorkerBoard.prototype.freePositions = function() {
      var freePositions, position, _i;
      freePositions = [];
      for (position = _i = 0; _i <= 8; position = ++_i) {
        if (this.board[position] === '-') {
          freePositions.push(position);
        }
      }
      return freePositions;
    };

    return WorkerBoard;

  })();

  WorkerAI = (function() {

    function WorkerAI(marker, boardArray, history) {
      this.marker = marker;
      this.boardArray = boardArray;
      this.history = history;
      this.board = new WorkerBoard(this.boardArray, this.history);
      this.setOpponentMarker();
    }

    WorkerAI.prototype.setOpponentMarker = function() {
      this.opponentMarker = 'X';
      if (this.marker === 'X') {
        return this.opponentMarker = 'O';
      }
    };

    WorkerAI.prototype.sendProgress = function(progress) {
      return self.postMessage({
        cmd: "progress",
        progress: progress
      });
    };

    WorkerAI.prototype.bestMove = function(progress) {
      var bestMove, freePositions, highestScore, _ref,
        _this = this;
      if (progress == null) {
        progress = false;
      }
      _ref = [null, null], highestScore = _ref[0], bestMove = _ref[1];
      freePositions = this.board.freePositions();
      _(freePositions).each(function(position, i) {
        var movePosition, score, _ref1;
        if (progress) {
          _this.sendProgress(i / freePositions.length);
        }
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

    WorkerAI.prototype.worstMove = function() {
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

    WorkerAI.prototype.getScore = function() {
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

    return WorkerAI;

  })();

  handler = function(e) {
    var ai, move, score, _ref;
    if (e.data.cmd === "bestMove") {
      ai = new WorkerAI(e.data.marker, e.data.boardArray, e.data.history);
      _ref = ai.bestMove(true), move = _ref[0], score = _ref[1];
      return self.postMessage({
        move: move,
        cmd: "done"
      });
    }
  };

  self.addEventListener('message', handler, false);

}).call(this);
