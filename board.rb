class Board
  attr_reader :grid

  CONNECTION_DIFFS = [
                      [1,0], [-1,0],
                      [0,1], [0,-1],
                      [1,1], [-1,-1],
                      [1,-1],[-1,1]
                      ]


  def initialize(options = {})
    @horizontal_size = options[:x_size] || 9
    @vertical_size   = options[:y_size] || 9
    @grid = Array.new(@vertical_size) { Array.new(@horizontal_size) { Tile.new } }
    @num_bombs = options[:bombs] || 12
    seed_bombs
    populate_neighbors
  end

  def render(highlight = nil)
    render_string = "  "

    @grid.first.each_index do |column|
      render_string += "#{column} "
    end

    render_string += "\n"

    @grid.each_with_index do |row, index|
      render_string += "#{index} "
      row.each_with_index do |tile, col|
        unless [col, index] == highlight
          render_string += "#{tile.render} "
        else
          render_string = render_string.chomp(' ') + "[#{tile.render}]"
        end
      end
      render_string += "\n"
    end

    return render_string
  end

  def [](column, row)
    @grid[row][column]
  end

  def solved?
    @grid.all? do |row|
      row.all? do |tile|
        (tile.is_bomb? && tile.flagged) || (tile.revealed && !tile.is_bomb?)
      end
    end
  end

  def exploded?
    @grid.any? do |row|
      row.any? do |tile|
        tile.is_bomb? && tile.revealed
      end
    end
  end

  def coordinates_in_bounds(x,y)
    x < 0 || x >= @horizontal_size || y < 0 || y >= @vertical_size
  end

  private
  def seed_bombs
    bombs_left = @num_bombs
    #bombs_placed = 0
    spaces_left = @vertical_size * @horizontal_size

    @grid.each do |row|
      row.each do |tile|
        if rand(spaces_left) < bombs_left
          tile.bomb = true
          bombs_left -= 1
          #bombs_placed += 1
        end
        spaces_left -= 1
      end
    end
    #puts bombs_placed
    nil
  end

  def populate_neighbors
    # debugger
    @grid.each_with_index do |row, vertical_index|
      row.each_with_index do |tile, horizontal_index|

        tile.neighbors =
                  CONNECTION_DIFFS.map { |diff| [horizontal_index + diff[0],
                                                 vertical_index + diff[1]]
                 }.delete_if { |x, y| coordinates_in_bounds(x,y)
                 }.map {|x, y| @grid[y][x] }
      end
    end
  end
end
