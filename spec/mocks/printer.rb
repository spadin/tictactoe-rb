require "surrogate/rspec"

class MockPrinter
  Surrogate.endow(self)
  define(:print_board) {|board| }
  define(:print) {|message| }
end