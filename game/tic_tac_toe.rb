require './game_objects/board'
require './game_objects/player'
require './game_objects/command'

class TicTacToe
  attr_accessor :board, :players, :current_player, :command

  @@game_objects = [
    GameObject::Player,
    GameObject::Board
  ]

  def initialize
    @players = []
    @current_player = nil
    @board = nil
    @command = ''
  end

  def setup
    @@game_objects.each { |go| go.setup self }
  end

  def event_loop
    loop do
      @@game_objects.each { |go| go.update self }
    end
  end
end

ttt = TicTacToe.new
ttt.setup
ttt.event_loop