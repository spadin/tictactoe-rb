require "board"
require "player/ai"

describe AI do
  let(:player) {AI.new(:x)}

  describe "#move" do
    it "should know how to make a move" do
      player.methods.should include :move
    end

    it "should determine the next move" do
      player.board = Board.new
      player.move
    end
  end
end