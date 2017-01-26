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
end


b = Board.new
p b[[3,7]].neighbor_bomb_count
