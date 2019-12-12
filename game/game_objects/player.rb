module GameObject
  class Player
    attr_reader :name

    class << self
      def setup game
        [1, 2].each do
          name = ''

          loop do
            puts 'Enter player name (2 letters only)'
            name = gets.strip
            break if name.length == 2
            puts "Name wasn't two letters (#{ name })"
          end

          game.players << Player.new(name)
        end

        game.current_player = game.players.last
      end

      def update game
        next_player game
        command = ''

        loop do
          puts "#{ game.current_player.name } enter a tile number"
          entry = gets.strip
          command = Command.new entry, game
          break if command.valid?
          puts command.error
        end

        puts "command: #{ command.command }"
        game.command = command.command
      end

      def next_player game
        index = game.players.index game.current_player

        game.current_player =
          game.players[index] == game.players.last ?
            game.players.first : game.players[index + 1]
      end
    end

    def initialize name
      @name = name
    end
  end
end