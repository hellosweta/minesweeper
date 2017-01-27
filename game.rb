#TODO: Create some sort of way for user to quit out.

require_relative "board"
class Minesweeper

  def initialize(board_size = 9)
    @board = Board.new(board_size)
    @won = false
  end

  def play
    play_turn until game_over?
    @board.reveal_all
    @board.render
    puts @won ? "You win!" : "You lose :( "
  end

  def play_turn
    @board.render
    pos = prompt_pos
    action = prompt_action
    @board.reveal(pos) if action == "r"
    @board.flag(pos) if action == "f"
  end

  def game_over?
    tiles = @board.grid.flatten
    # if there are any revealed & bombed tiles, then player lost
    return true if tiles.any? { |tile| tile.revealed && tile.bombed }
    # if everything that is not revealed is a bomb, then player won
    not_revealed = tiles.select { |tile| !tile.revealed }
    if not_revealed.all? { |tile| tile.bombed }
      @won = true
      return true
    end

    return false
  end

  def prompt_pos
    pos = []
    until valid_pos?(pos)
      puts "Please enter a position (e.g.; 0,2)"
      print "> "
      pos = parse_pos(gets.chomp)
    end
    pos
  end

  def parse_pos(input)
    pos = input.split(",").map { |el| Integer(el)}
  end

  def valid_pos?(pos)
    pos.length == 2 && pos.is_a?(Array) && !@board[pos].nil?
  end

  def prompt_action
    action = ""
    until action == "r" || action == "f"
      puts "Please enter an action (r for reveal, f for flag)"
      print "> "
      action = gets.chomp.downcase
    end
    action
  end

  def self.yaml_load(file_name)
    load_file = File.read(file_name)
    YAML.load(load_file)
  end

  def save

    yaml_file = self.to_yaml
    puts "Enter .yaml file name (without extension): "
    p "> "
    file_name = "save_files/" + $STDIN.gets.chomp + ".yaml"

    #TODO: actually open the file and write to it
  end

end
if __FILE__ == $PROGRAM_NAME
  puts "Welcome to Minesweeper."
  input = ""
  until input == "y" || input == "n"
    puts "Would you like to load a saved game? (y/n)"
    p "> "
    input = gets.chomp.downcase
  end
  g = nil
  if input == "y"
    puts "Enter .yaml file name (without extension): "
    p "> "
    file_name = "save_files/" + $STDIN.gets.chomp + ".yaml"
    if File.exist?(file_name)
      g = Game.yaml_load(file_name)
    else
      puts "Invalid file name. Creating new game."
      g = Minesweeper.new(4)
    end
  else
    g = Minesweeper.new(4)
  end
  g.play unless g.nil?
end
