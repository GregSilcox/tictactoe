require './game/memory'
require './game/player'
require './game/game'
require './game/board'
require './game/command'

class TicTacToe
  attr_accessor :memory, :player, :games, :opponents, :board

  def initialize location=:remote
    @memory = Memory.new location
    @player = Player.new memory
    @games = []
    @opponents = []
    @board = nil
  end

  def setup
    memory.connect
    player.setup ENV['SG_Username'], ENV['SG_Password']
    @games = player.get_games

    opponent_ids = games.map do |game|
      opponent_id = game.player_ids - [player.id]
      opponent_id.first
    end.uniq

    Player.mget(opponent_ids, memory).map do |data|
      opponent = Player.new memory
      opponent.parse data
      @opponents << opponent
    end
  end

  def get_command board
    command = ''

    loop do
      puts "Enter a tile number or 0 to cancel: "
      entry = $stdin.gets.strip
      command = Command.new entry

      break if command.cancel?
      
      break if
        command.valid && 
        board.available_tiles.include?(command.command)

      puts command.error
    end

    puts "command: #{ command.command }"
    command # game.command = command.command
  end

  def list_games all_games, games_to_list
    games_to_list.each do |game|
      opponent_id = game.player_ids - [player.id]
      opponent = opponents.find { |j| j.id == opponent_id.first }
      index = all_games.index game
      puts "  #{ index } - opponent: #{ opponent.name }, game id: #{ game.id }"
    end
  end

  def games_menu
    puts 'What would you like to do?'

    # This is wrong. Not all completed games have nine commands.
    completed_games = games.select &:completed?
    playable_games = games - completed_games
    players_games = playable_games.select { |game| game.playable? player.id }
    opponents_games = playable_games - players_games

    puts "Completed games"
    list_games games, completed_games

    puts "Opponent's turn"
    list_games games, opponents_games

    puts "Your turn"
    list_games games, players_games

    puts '  N - New game'
    puts '  E - Exit'

    choice = player.choose /\d+|N|E/i

    play_game games[choice.to_i] if choice =~ /\d+/
    # Need to ensure choice is from 'Your Turn'
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
    # Setup the board
    puts "play_game: #{ game.id }"
    cmds = game.commands.map { |c| Command.new c }
    game.show
    offset = game.offset player.id
    board = Board.setup cmds, offset

    # Get the command
    command = get_command board
    return if command.cancel?
    game.commands << command.command

    # Update the board
    puts "show game: "
    game.show

    # Score the board
    cmds = game.commands.map { |c| Command.new c }
    board.update_grid cmds, offset
    message = board.score player.name, game.mark(player.id)
    puts "board scoring message: #{ message }"

    # Save the game
    game.save
  end
end
