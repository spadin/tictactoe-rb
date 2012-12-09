require_relative './board'
require_relative './player/human'
require_relative './player/ai'

class TicTacToe
  attr_reader :game_type
  attr_reader :x, :o

  def initialize(type)
    set_players type
  end

  def start
    board.start(@x, @o)
  end

  def board
    @board ||= Board.new
  end

  private
  def set_players(game_type)
    set_game_type game_type

    klass = [:human_vs_human, :human_vs_ai].include?(game_type)? Human : AI
    @x = klass.new(:x)

    klass = [:human_vs_human, :ai_vs_human].include?(game_type)? Human : AI
    @o = klass.new(:o)

    set_boards_for_ai
  end

  def set_boards_for_ai
    @x.board = board if @x.class == AI
    @o.board = board if @o.class == AI
  end

  def set_game_type(game_type)
    if allowed_game_types.include?(game_type)
      @game_type = game_type
    else
      raise ArgumentError
    end
  end

  def allowed_game_types
    [:human_vs_human, :human_vs_ai, :ai_vs_human, :ai_vs_ai]
  end
end