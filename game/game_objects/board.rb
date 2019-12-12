module GameObject
  class Board
    class << self
      def setup game
        game.board = Board.new
        game.board.display
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
      @grid[row.to_i-1][column.to_i-1] = game.current_player.name
    end

    def check_players game, result
      game.players.each do |player|
        declare_winner(player) if result == [player.name]
      end
    end

    def score game
      # check all three rows
      (0..2).each do |i|
        check_players game, [@grid[i][0], @grid[i][1], @grid[i][2]].uniq
      end

      # Check all three columns
      (0..2).each do |i|
        check_players game, [@grid[0][i], @grid[1][i], @grid[2][i]].uniq
      end

      # Check the back-slash diagonal
      check_players game, [@grid[0][0], @grid[1][1], @grid[2][2]].uniq

      # Check the forward-slash diagonal
      check_players game, [@grid[0][2], @grid[1][1], @grid[2][0]].uniq
    end

    def available_tiles
      @grid.flatten.select{ |tile| tile.match /\d\d/ }
    end

    def display
      @grid.each do |row|
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
end