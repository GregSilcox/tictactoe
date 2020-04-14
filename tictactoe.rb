require './game/memory'
require './game/player'
require './game/game'
require './game/board'
require './game/command'

class TicTacToe
  attr_reader :location
  attr_accessor :memory, :player, :games, :opponents, :board #, :command

  def initialize location=:remote
    @location = location
    @memory = Memory.new
    @player = Player.new
    @games = []
    @opponents = []

    # @board = Board.new
    # @command = Command.new
  end

  def setup
    puts "Setting up memory"
    memory.send location
    memory.connect

    puts "Setting up the player"
    # player.login_menu
    player.game = self
    player.setup
    player.name = 'Greg'
    player.password = 'Mario4'
    player.record.authenticate player.name, player.password
    player.record.load player.id
    player.show


    puts "Setting up the games"
    Game.mget(player.game_ids, self).each do |game_data|
      g = Game.new self
      g.parse game_data
      @games << g
      g.show
    end

    puts "Setting up the opponents"
    opponent_ids = games.map do |game|
      opponent_id = game.player_ids - [player.id]
      opponent_id.first
    end.uniq

    Player.mget(opponent_ids, self).map do |data|
      opponent = Player.new
      opponent.parse data
      @opponents << opponent
      opponent.show
    end
  end

  def get_command
    command = ''

    loop do
      puts "Enter a tile number"
      entry = $stdin.gets.strip
      command = Command.new entry, self
      break if command.valid?
      puts command.error
    end

    puts "command: #{ command.command }"
    command # game.command = command.command
  end

  def update
    games_menu
    # Get command
    # Update the board
    # Score the board
    # Update game state to memory
  end

  def games_menu
    puts 'What would you like to do?'
    games.each do |game|
      opponent_id = game.player_ids - [player.id]
      opponent = opponents.find { |j| j.id == opponent_id.first }
      index = games.index game
      puts "  #{ index } - opponent: #{ opponent.name }, game id: #{ game.id }"
    end

    puts '  N - New game'
    puts '  E - Exit'

    choice = player.choose /\d+|N|E/i

    play_game games[choice.to_i] if choice =~ /\d+/
    new_game if choice =~ /N/i
    exit if choice =~ /E/i
  end

  def new_game
    puts 'Starting a New Game of TicTacToe'
    puts 'Who do you want to play against?'
    opponent_id = nil

    opponent_id = $stdin.gets.strip
    opponent = PlayerMemory.find(opponent_id, self)

    g = Game.create self, player, opponent
    # Board.setup self
  end

  def play_game game
    puts "play_game: #{ game.id }"
    Board.setup self
    game.commands << get_command.command
    puts "show game: "
    game.show
    game.save
  end
end

ttt = TicTacToe.new
ttt.setup
loop { ttt.update }
