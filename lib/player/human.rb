class Human
  attr_reader :player_marker

  def initialize(player_marker)
    @player_marker = player_marker
  end

  def move
    prompt_for_move
  end

  def prompt_for_move(move='')
    until numeric?(move) && move.to_i >= 0 && move.to_i < 10
      puts "#{player_marker}'s turn, what's your next move?"
      move = gets.chomp
    end
    move.to_i
  end

  private

  def numeric?(move)
    Integer(move) != nil rescue false
  end
end