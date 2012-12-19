require "tictactoe"

describe TicTacToe do
  before do
    STDOUT.stub(:print)
  end

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
  end

  it "should be able to start a game with two players and have a winner" do
    x = Human.new("x")
    o = Human.new("o")

    x.stub(:puts)
    o.stub(:puts)

    x.stub(:gets).and_return('0','1','2','3')
    o.stub(:gets).and_return('4','5','7')

    game.board.set_players(x,o)
    game.start
    game.board.winner.should == "x"
  end

  it "should ask user to try again if spot is taken" do
    x = Human.new("x")
    o = Human.new("o")

    x.stub(:puts)
    o.stub(:puts)

    x.stub(:gets).and_return('0','4','1','2','3')
    o.stub(:gets).and_return('4','5','7','8')

    game.board.set_players(x,o)
    game.start
    game.board.winner.should == "x"
  end

end