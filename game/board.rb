class Board
  attr_reader :grid

  GRID = [%w(11 12 13), %w(21 22 23), %w(31 32 33)].freeze
  
  class << self
    def setup commands, offset
      board = Board.new
      board.update_grid commands, offset
      board.display
      board
    end

    def update game
      game.board.execute game
      game.board.score game
      game.board.display
    end
  end

  def initialize
    @grid = GRID
  end

  # def execute game
  def execute command, mark
    @grid[command.row][command.column] = mark
  end

  def score name, mark # XX or OO
    # Check for a draw
    declare_draw unless available_tiles.any?

    # check all three rows
    (0..2).each do |i|
      if [mark] == [grid[i][0], grid[i][1], grid[i][2]].uniq
        msg = message name, "row #{ i + 1 }"
        declare_winner msg
        return msg
      end
    end

    # Check all three columns
    (0..2).each do |i|
      if [mark] == [grid[0][i], grid[1][i], grid[2][i]].uniq
        msg = message name, "column #{ i + 1 }"
        declare_winner msg
        return msg
      end
    end

    # Check the back-slash diagonal
    if [mark] == [grid[0][0], grid[1][1], grid[2][2]].uniq
      msg = message name, "back-slash diagonal"
      declare_winner msg
      return msg
    end

    # Check the forward-slash diagonal
    if [mark] == [grid[0][2], grid[1][1], grid[2][0]].uniq
      msg = message name, "forward-slash diagonal"
      declare_winner msg
      return msg    
    end

    return "no winner or draw yet."
  end

  def available_tiles
    @grid.flatten.select{ |tile| tile.match /\d\d/ }
  end

  # The commands are in order, and the offset determines 
  # who started first
  def update_grid commands, offset=0
    commands.each_with_index do |command, index|
      i = (index + offset) % 2
      filler = i == 0 ? 'XX' : 'OO'
      grid[command.row][command.column] = filler
    end
  end

  def display
    grid.each do |row|
      puts row.join ' | '
      puts ''
    end
  end

  def message name, direction
    "#{ name } won the game! #{ direction }"
  end

  def declare_winner msg
    display
    puts msg
  end

  def declare_draw
    display
    puts "This game is a draw."
    exit
  end
end
