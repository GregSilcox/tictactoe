require './game/game_memory'

class Game
  attr_accessor :id, :player_ids, :commands, :tictactoe, :record

  def self.create tictactoe, player, opponent
    game = new tictactoe, player, opponent
    game.save

    player.games << game.id
    player.record.save

    opponent.games << game.id
    opponent.record.save

    game
  end

  def self.mget game_ids, tictactoe
    game_keys = game_ids.map { |id| "game:#{ id }" }
    game_json = tictactoe.memory.mget game_keys
    games_data = []

    game_ids.each_index do |index|
      game_data = JSON.parse game_json[index]
      game_data['id'] = game_ids[index]
      games_data << game_data
    end

    games_data
  end

  # def initialize tictactoe, player, opponent
  #   puts "game: initializing #{ player.name } vs. #{ opponent.name }"
  #   @tictactoe = tictactoe
  #   @players = [player.id, opponent.id]
  #   @record = GameMemory.new self
  #   @id = @record.identifier
  #   @commands = []
  #   puts "game: initialize: #{ @id }"
  # end

  def initialize tictactoe
    @tictactoe = tictactoe
    @record = GameMemory.new self
    @id = nil
    @player_ids = []
    @commands = []
  end

  def parse data
    @id = data.fetch 'id'
    @player_ids = data.fetch 'players', []
    @commands = data.fetch 'commands', []
  end

  def show
    puts "Game: " +
      "id: #{ id }, " +
      "players: #{ player_ids }, " +
      "commands: #{ commands }"
  end

  def save

    record.save
  end

  def setup
    @board = Board.new
  end

  def update
    board.display
  end
end