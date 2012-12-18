require 'board'
require 'board_printer'
require 'player/human'

describe Board do
  before do
    BoardPrinter.any_instance.stub(:print_board)
    @board = Board.new
    @board.stub(:puts)
  end

  it "should have no move history" do
    @board.move_history.should have(0).items
  end

  it "should have nine free positions" do
    @board.free_positions.should have(9).items
  end

  it "should be able to mark a position with a marker" do
    move_position = 0
    @board.mark move_position, "x"
    @board.free_positions.should have(8).items
    @board.move_history.should have(1).item
    @board.move_history.should include move_position
  end

  it "should know which mark goes next" do
    @board.next_marker.should == "o"
  end

  it "should stop not allow same two marks in a row" do
    @board.mark 0, "x"
    lambda { @board.mark 1, "x" }.should raise_error
  end
  
  it "should know when the game is over because of a draw" do
    @board.mark 0, "x"
    @board.mark 1, "o"
    @board.mark 2, "x"
    @board.mark 4, "o"
    @board.mark 3, "x"
    @board.mark 6, "o"
    @board.mark 5, "x"
    @board.mark 8, "o"
    @board.mark 7, "x"
    @board.gameover?.should be_true
    @board.winner.should be_nil
  end

  it "should know when the game is over because someone wins" do
    @board.mark 0, "x"
    @board.mark 3, "o"
    @board.mark 1, "x"
    @board.mark 5, "o"
    @board.mark 2, "x"
    @board.gameover?.should be_true
    @board.winner.should == "x"
  end

  it "should know how to undo the last mark" do
    @board.mark 0, "x"
    @board.mark 3, "o"
    @board.mark 1, "x"
    @board.mark 5, "o"
    @board.undo_last_mark!
    previous_position = @board.move_history.last
    previous_position.should == 1
    @board[previous_position].should == "x"
  end

  it "should only allow marking a blank spot" do
    @board.mark 0, "x"
    @board.mark 3, "o"
    @board.mark 1, "x"
    @board.mark 5, "o"
    lambda { @board.mark 5, "x" }.should raise_error
  end

  it "should be able to start a game with two players and have a winner" do
    x = Human.new("x")
    o = Human.new("o")

    x.stub(:puts)
    o.stub(:puts)

    x.stub(:gets).and_return('0','1','2','3')
    o.stub(:gets).and_return('4','5','7')

    @board.start(x,o)
    @board.winner.should == "x"
  end

  it "should ask user to try again if spot is taken" do
    x = Human.new("x")
    o = Human.new(:y)

    x.stub(:puts)
    o.stub(:puts)

    x.stub(:gets).and_return('0','4','1','2','3')
    o.stub(:gets).and_return('4','5','7','8')

    @board.start(x,o)
    @board.winner.should == "x"
  end
end