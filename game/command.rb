class Command
  attr_reader :command, :error

  def initialize command, game
    @command = command
    @game = game
    @error = nil
  end

  def valid?
    if @command.nil? || @command.empty?
      @error = "command was blank"
      return false
    end

    unless @game.board.available_tiles.include? @command
      @error = "tile not available (#{ @command })"
      return false
    end

    true
  end
end
