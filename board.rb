require_relative("tile")
require("colorize")
class Board
  attr_reader :grid, :board_size
  def initialize(board_size = 9)
    @board_size = board_size
    @grid = []
    @colors = [:light_black, :light_blue, :green, :red, :magenta, :dark_red, :cyan, :black, :light_green]
    populate_grid
  end

  def populate_grid
    @num_bombs = @board_size * @board_size / 4
    list = []
    @num_bombs.times { list << true }
    ((@board_size * @board_size) - @num_bombs).times { list << false }
    list.shuffle!

    for i in 0...@board_size do
      row = []
      for j in 0...@board_size do
        row << Tile.new(self, [i, j], list.shift)
      end
      @grid << row
    end
  end

  def [](pos)
    return nil if valid_pos?(pos) == false
    r, c = pos
    @grid[r][c]
  end

  def valid_pos?(pos)
    r, c = pos
    r < @board_size && c < @board_size && r >= 0 && c >= 0
  end

  def reveal(pos)
    self[pos].reveal
  end

  def flag(pos)
    self[pos].flag
  end

  def render(reveal_all = false)
    system("clear")
    string = "\n  " + (0...@board_size).to_a.join(" ") + "\n"
    for i in 0...@board_size do
      row = "#{i} "
      for j in 0...@board_size do
        tile = self[[i, j]]
        if tile.revealed || reveal_all
          if tile.bombed
            row << "* "
          else
            num_bombs = tile.neighbor_bomb_count
            if num_bombs == 0
              row << "-".colorize(@colors[num_bombs])
            else
              row << num_bombs.to_s.colorize(@colors[num_bombs])
            end
            row << " "
          end
        else
          if tile.flagged
            row << "f ".colorize(:light_red)
          else
            row << ". "
          end
        end
      end
      string << row
      string << "\n"
    end
    string << "\n"
    puts string
  end
end
