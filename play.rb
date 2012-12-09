require_relative './lib/tictactoe'

# Allowed game types:
#  - :human_vs_human
#  - :human_vs_ai
#  - :ai_vs_human
#  - :ai_vs_ai
#
TicTacToe.new(:human_vs_ai).start