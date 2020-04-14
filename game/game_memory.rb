require 'json'

class GameMemory
  attr_reader :player, :game, :memory

  def initialize game
    @game = game
    @memory = game.tictactoe.memory
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