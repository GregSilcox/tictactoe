require 'json'

class PlayerMemory
  attr_reader :player, :memory

  # keys player:*
  # keys user:*
  def self.find id, memory
    player_json = memory.get "player:#{ id }"
    raise RecordNotFound, "player:#{ id } was not found in Redis" if player_json.nil?

    player_data = JSON.parse player_json
    player = Player.new memory
    player.id = id
    player.name = player_data['name']
    player.game_ids = player_data['games']
    player.authenticated = false
    player
  end

  def self.authenticate memory, player
    player.id = memory.get "user:#{ player.name }:#{ player.password }"
  end

  def self.load memory, player
    player_data = JSON.parse memory.get "player:#{ player.id }"
    player.name = player_data['name']
    player.game_ids = player_data['games']
    player.authenticated = true
    true
  end

  def save
    player_data = {}
    player_data['id'] = player.id
    player_data['name'] = player.name
    player_data['games'] = player.games

    memory.set "player:#{ player.id }", player_data.to_json
    memory.set "user:#{ player.name }:#{ player.password }", player.id
  end

  # gs = memory.mget player.games
  # puts "game_menu: gs: #{ gs }"
  # gs.each_index do |index|
  #   puts "game_menu: g: #{ gs[index] }"
  #   g = gs[index]
  #   puts "  #{ index } - #{ g.players.last.name }"

  def get_games
    game_keys = player.game_ids.map { |id| "game:#{ id }" }
    game_json = memory.mget game_keys
    game_data = JSON.parse game_json.to_s

    player.game_ids.each_index do |index|
      game_data[index]['id'] = player.game_ids[index]
    end

    game_data
  end

  def identifier
    memory.identifier 'player'
  end
end