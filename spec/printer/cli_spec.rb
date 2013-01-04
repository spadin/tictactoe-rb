require 'printer/cli'
require "mocks/printer"

module TicTacToePrinter
  describe CLI do
    before do
      @printer = CLI.new
      @printer.stub(:puts)
      @printer.stub(:system)
    end

    it "implements the methods on the MockPrinter" do
      MockPrinter.should be_substitutable_for(TicTacToePrinter::CLI)  
    end

    it "should print the board correctly" do
      cells = %w(x - - x o o - - -)
      expected_board = %{
        x | 1 | 2
        x | o | o
        6 | 7 | 8
      }
      @printer.should_receive(:print).with(expected_board)
      @printer.print_board(cells)
    end
  end
end