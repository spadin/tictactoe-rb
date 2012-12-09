require "tictactoe"

describe TicTacToe do
  let(:game) {TicTacToe.new(:human_vs_human)}
  
  describe "#initialize" do
    it "should expect a game type when instantiating" do
      lambda { TicTacToe.new }.should raise_error
    end

    it "should not accept improper game types" do
      lambda { TicTacToe.new(:cat_vs_mouse) }.should raise_error
    end

    it "should accept proper game types" do
      lambda { TicTacToe.new(:human_vs_human) }.should_not raise_error
      lambda { TicTacToe.new(:human_vs_ai) }.should_not raise_error
      lambda { TicTacToe.new(:ai_vs_human) }.should_not raise_error
      lambda { TicTacToe.new(:ai_vs_ai) }.should_not raise_error
    end

    it "should properly set the players" do
      game.x.class.should == Human
      game.o.class.should == Human
    end

    it "should start the game" do
      game.board.should_receive(:start).with(game.x, game.o)
      game.start
    end
  end
end