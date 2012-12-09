require "board"
require "player/ai"

describe AI do
  let(:player) {AI.new("o")}
  let(:board) {Board.new}

  describe "#move" do
    it "should know how to make a move" do
      player.methods.should include :move
    end

    it "should choose middle as the next move" do
      player.board = board

      board.mark(0, "x")
      player.move.should == 4
    end

    it "should choose top center as the next move" do
      board.mark(0, "x")
      board.mark(4, "o")
      board.mark(8, "x")
      player.board = board
      player.move.should == 1
    end
  end
end