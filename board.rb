require_relative("tile")

class Board
  attr_reader :grid, :board_size
  def initialize(board_size = 9)
    @board_size = board_size
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
    return nil unless valid_pos?(pos)
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

  def reveal_all
    @grid.each do |row|
      row.each do |tile|
        tile.reveal unless tile.revealed
      end
    end
  end

  def render
    system("clear")
    string = "\n  " + (0...@board_size).to_a.join(" ") + "\n"
    for i in 0...@board_size do
      row = "#{i} "
      for j in 0...@board_size do
        tile = self[[i, j]]
        row << tile.to_s
      end
      string << row
      string << "\n"
    end
    string << "\n"
    puts string
  end
end
