class AI
  attr_reader   :marker
  attr_accessor :board

  def initialize(marker)
    @marker = marker
  end

  def move
    move, score = calculate_move
    move
  end

  def opponent_marker
    @opponent_marker ||= (@marker == "x")? "o" : "x"
  end

  def calculate_move(current_comparison = :>)
    next_comparison = (current_comparison == :>)? :< : :>
    calculated_move, calculated_score = nil, nil
    @board.free_positions.each do |position|
      @board.mark(position, @marker) if current_comparison == :>
      @board.mark(position, opponent_marker) if current_comparison == :<
      if @board.gameover? 
        score = get_score
      else
        move_position, score = calculate_move(next_comparison)
      end
      @board.undo_last_mark!

      if calculated_score == nil || score.send(current_comparison, calculated_score)
        calculated_move, calculated_score = position, score
      end
    end

    [calculated_move, calculated_score]    
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