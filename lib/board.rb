class Board
  attr_reader :move_history
  attr_reader :winner

  def initialize
    @cells = ['-']*9
    @move_history = []
    @current_marker = :x
  end

  def start(x,o)
    @x, @o = x, o
    until gameover?
      begin
        draw_board
        mark current_player.move, @current_marker
      rescue RuntimeError
        next
      end
    end
    if winner then
      puts "The #{winner}'s win!"
    else
      puts "Nobody wins."
    end
  end

  def draw_board
    system("clear")
    puts %{
      #{draw_cell(0)} | #{draw_cell(1)} | #{draw_cell(2)}
      #{draw_cell(3)} | #{draw_cell(4)} | #{draw_cell(5)}
      #{draw_cell(6)} | #{draw_cell(7)} | #{draw_cell(8)}
    }
  end
  def draw_cell(position)
    if @cells[position] == '-'
      position
    else
      @cells[position]
    end
  end

  def current_player
    instance_variable_get("@#{@current_marker.to_s}")
  end

  def next_marker
    (@current_marker == :x)? :o : :x
  end

  def mark(position, marker)
    raise ArgumentError unless @current_marker == marker
    raise "Duplicate - tried to insert (#{position}, #{marker}) to #{@cells}" if @move_history.include?(position)
    @cells[position] = marker
    @move_history << position
    @current_marker = next_marker
    @gameover = (winning_combination? || @move_history.size == 9)
  end

  def undo_last_mark!
    @gameover = false
    @current_mark = next_marker
    position = @move_history.pop
    @cells[position] = '-'
  end

  def gameover?
    @gameover
  end

  def free_positions
    @cells.select {|cell| cell == '-'}.fill {|i| i}
  end

  def winning_combination?
    winning_combinations.each do |combo|
      if @cells[combo[0]] == :x && @cells[combo[1]] == :x && @cells[combo[2]] == :x
        @winner = :x
        return true
      end

      if @cells[combo[0]] == :y && @cells[combo[1]] == :y && @cells[combo[2]] == :y
        @winner = :y
        return true
      end
    end
    return false
  end

  def winning_combinations
    @winning_combinations ||= [
      [0,1,2], [3,4,5], [6,7,8],  # Horizontal
      [0,3,6], [1,4,7], [2,5,8],  # Vertical
      [0,4,8], [2,4,6]            # Diagonal
    ]
  end

  def [](position)
    @cells[position]
  end
end