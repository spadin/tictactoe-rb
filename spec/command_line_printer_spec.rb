require 'command_line_printer'

describe CommandLinePrinter do
  before do
    @printer = CommandLinePrinter.new
    @printer.stub(:puts)
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