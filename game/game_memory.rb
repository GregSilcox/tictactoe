require 'json'

class GameMemory
  attr_reader :game, :memory

  def initialize game, memory
    @game = game
    @memory = memory
  end

  def save
    game_data = {}
    game_data['players'] = game.player_ids
    game_data['commands'] = game.commands

    memory.set "game:#{ game.id }", game_data.to_json
  end

  def identifier
    memory.identifier 'game'
  end
end