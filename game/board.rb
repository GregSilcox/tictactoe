class Board
  attr_reader :grid

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
    @grid = [%w(11 12 13), %w(21 22 23), %w(31 32 33)]
  end

  def execute game
    return unless game.command.length > 0

    (row, column) = game.command.split ''
    @grid[row.to_i-1][column.to_i-1] = game.player.name
  end

  def score game
    # check all three rows
    (0..2).each do |i|
      name = [@grid[i][0], @grid[i][1], @grid[i][2]].uniq
      declare_winner(game.player) if name == [game.player.name]
    end

    # Check all three columns
    (0..2).each do |i|
      name = [@grid[0][i], @grid[1][i], @grid[2][i]].uniq
      declare_winner(game.player) if name == [game.player.name]
    end

    # Check the back-slash diagonal
    name = [@grid[0][0], @grid[1][1], @grid[2][2]].uniq
    declare_winner(game.player) if name == [game.player.name]

    # Check the forward-slash diagonal
    name = [@grid[0][2], @grid[1][1], @grid[2][0]].uniq
    declare_winner(game.player) if name == [game.player.name]
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

  def declare_winner player
    display
    puts "#{ player.name } won the game!"
    exit
  end
end
