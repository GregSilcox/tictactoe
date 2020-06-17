class Command
  attr_reader :command, :error, :row, :column, :valid
  VALID = %w(11 12 13 21 22 23 31 32 33).freeze

  def initialize command
    @command = command
    @row = @column = nil
    @error = nil

    _parse if _valid?
  end

  def cancel?
    command == '0'
  end

  private

  def _valid?
    @error = "command not in set" unless
      VALID.include? command

    @error = "command was blank" if 
      command.nil? || command.empty?

    @valid = error.nil?
  end

  def _parse
    @row = command.split('')[0].to_i - 1
    @column = command.split('')[1].to_i - 1
  end
end
