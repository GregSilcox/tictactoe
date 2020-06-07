require './game/game_memory'

class Game
  attr_accessor :id, :player_ids, :commands, :record

  def self.create memory, player, opponent
    game = new memory, player, opponent
    game.save

    player.games << game.id
    player.record.save

    opponent.games << game.id
    opponent.record.save

    game
  end

  def self.mget game_ids, memory
    game_keys = game_ids.map { |id| "game:#{ id }" }
    game_json = memory.mget game_keys
    games_data = []

    game_ids.each_index do |index|
      game_data = JSON.parse game_json[index]
      game_data['id'] = game_ids[index]
      games_data << game_data
    end

    games_data
  end

  def initialize memory
    @memory = memory
    @record = GameMemory.new self, memory
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

  def completed?
    commands.size >= 9
  end

  def offset player_id
    player_id == player_ids.first ? 0 : 1
  end

  def mark player_id
    player_id == player_ids.first ? "XX" : "00"
  end

  # Meaning, is it the logged in player's turn?
  def playable? player_id
    (commands.size + offset(player_id)) % 2 == 0
  end
end