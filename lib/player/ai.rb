class AI
  attr_reader   :player_marker
  attr_accessor :board

  def initialize(player_marker)
    @player_marker = player_marker
  end

  def move
    move, _ = calculate_move
    move
  end

  def opponent_marker
    @opponent_marker ||= (player_marker == "x")? "o" : "x"
  end

  def calculate_move(current_comparison = :>)
    next_comparison = (current_comparison == :>)? :< : :>
    calculated_move, calculated_score = nil, nil
    board.free_positions.each do |position|
      board.mark(position, player_marker) if current_comparison == :>
      board.mark(position, opponent_marker) if current_comparison == :<
      if board.gameover? 
        score = calculate_score
      else
        _, score = calculate_move(next_comparison)
      end
      board.undo_last_mark!

      if calculated_score == nil || score.send(current_comparison, calculated_score)
        calculated_move, calculated_score = position, score
      end
    end

    [calculated_move, calculated_score]    
  end

  def calculate_score
    if board.winner.nil?
      0
    elsif board.winner == player_marker
      1
    else
      -1
    end
  end
end