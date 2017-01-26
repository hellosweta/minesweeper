require_relative("tile")
class Board
  attr_reader :grid
  def initialize
    @board_size = 9
    @grid = []
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
    r, c = pos
    @grid[r][c]
  end

  def reveal(pos)
    @grid[pos].reveal
  end

  def render
    string = "\n"
    for i in 0...@board_size do
      row = ""
      for j in 0...@board_size do
        tile = self[[i, j]]
        if tile.revealed
          if tile.bombed
            row << "* "
          else
            row << tile.neighbor_bomb_count
            row << " "
          end
        else
          if tile.flagged
            row << "f "
          else
            row << ". "
          end
        end
      end
      string << row
      string << "\n"
    end
    puts string
  end
end
