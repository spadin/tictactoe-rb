class AI
  attr_reader   :marker
  attr_accessor :board

  def initialize(marker)
    @marker = marker
  end

  def move
    position, score = max_move
    position
  end

  def opponent_marker
    @opponent_marker ||= (@marker == :x)? :o : :x
  end

  def max_move
    best_move, highest_score = nil, nil

    @board.free_positions.each do |position|
      @board.mark(position, @marker)
      if @board.gameover? 
        score = get_score
      else
        move_position, score = min_move
      end

      @board.undo_last_mark!

      if highest_score == nil || score > highest_score then
        best_move, highest_score = position, score
      end
    end

    [best_move, highest_score]
  end

  def min_move
    worst_move, lowest_score = nil, nil

    @board.free_positions.each do |position|
      @board.mark(position, opponent_marker)
      if @board.gameover? 
        score = get_score
      else
        move_position, score = max_move
      end

      @board.undo_last_mark!

      if lowest_score == nil || score < lowest_score then
        worst_move, lowest_score = position, score
      end
    end

    [worst_move, lowest_score]
  end

  def get_score
    if @board.winner.nil?
      0
    elsif @board.winner == @marker
      1
    else
      -1
    end
  end
end