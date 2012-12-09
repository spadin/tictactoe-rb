class Human
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end

  def move
    prompt_for_move
  end

  def prompt_for_move(move='')
    until move.numeric? && move.to_i >= 0 && move.to_i < 10
      puts "#{marker}'s turn, what's your next move?"
      move = gets.chomp
    end
    move.to_i
  end
end

class String
  def numeric?
    Float(self) != nil rescue false
  end
end