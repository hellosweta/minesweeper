require_relative "board"
class Minesweeper

  def initialize
    @board = Board.new
    @board.render
  end

  def play
    play_turn until game_over?
    puts @won ? "You win!" : "You lose :( "
  end

  def play_turn
    @board.render
    pos = prompt_pos
    action = prompt_action
    @board.reveal(pos) if action == "reveal"
    @board.flag(pos) if action == "flag"
  end

  def game_over?

  end


end

g = Minesweeper.new
