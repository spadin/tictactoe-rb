class CommandLinePrinter
  def print_board(cells)
    @cells = cells
    system "clear"
    print %{
      #{print_cell(0)} | #{print_cell(1)} | #{print_cell(2)}
      #{print_cell(3)} | #{print_cell(4)} | #{print_cell(5)}
      #{print_cell(6)} | #{print_cell(7)} | #{print_cell(8)}
    }
  end

  def print(text)
    STDOUT.print(text)
  end

  private
  def print_cell(position)
    if @cells[position] == '-'
      position
    else
      @cells[position]
    end
  end
end