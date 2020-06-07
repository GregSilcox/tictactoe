require './game/player_memory'

class Player
  attr_accessor :id, :name, :password, :game_ids, 
    :authenticated, :game, :memory

  def self.mget player_ids, memory
    player_keys = player_ids.map { |id| "player:#{ id }" }
    player_json = memory.mget player_keys
    player_json.map { |j| JSON.parse j }
  end

  def initialize memory
    @memory = memory
  end

  def setup name, password
    @name = name
    @password = password
    PlayerMemory.authenticate memory, self
    PlayerMemory.load memory, self
  end

  def get_games
    Game.mget(game_ids, memory).map do |game_data|
      g = Game.new self
      g.parse game_data
      g
    end
  end

  # data has already been JSON.parse'd so we can use mget.
  def parse data
    @id = data.fetch 'id'
    @name = data.fetch 'name'
    @game_ids = data.fetch 'games', []
    @authenticated = data.fetch 'authenticated', false
  end

  def show
    puts "Player: " +
      "id: #{ id }, " +
      "name: #{ name }, " +
      "game_ids: #{ game_ids }, " +
      "authenticated: #{ authenticated }"
  end

  def games
    return [] if game_ids.empty?
    Game.mget game_ids, game
  end

  def login_menu
    puts 'What would you like to do?'
    puts '  L - Login'
    puts '  R - Register'
    puts '  E - Exit'

    choice = choose /L|R|E/i

    login if choice =~ /L/i
    register if choice =~ /R/i
    exit if choice =~ /E/i
  end

  def choose choices
    loop do
      choice = $stdin.gets.strip
      return choice if choice =~ choices
      puts "#{ choice } isn't an option"
    end
  end

  def login
    puts 'Logging In'

    loop do
      puts 'What is your name? (blank to exit)'
      @name = $stdin.gets.strip
      exit if @name.empty?

      puts 'What is your password?'
      @password = $stdin.gets.strip

      break if record.authenticate name, password
      puts "That name and password were not found"
    end

    record.load id
    puts "#{ name } Logged in successfully: games"
  end

  def register
    puts 'Registering'
    id = nil

    loop do
      loop do
        puts 'What is your name? (blank to exit)'
        @name = $stdin.gets.strip
        exit if @name.empty?
        break if name.length > 2
        puts "Name must be at least 3 characters"
      end

      loop do
        puts 'What is your password?'
        @password = $stdin.gets.strip
        puts 'Confirm your password?'
        confirmation = $stdin.gets.strip
        break if password == confirmation
        puts "Password #{ password} and confirmation #{ confirmation } must match"
      end

      id = record.authenticate name, password
      break unless id
      puts "That name was alredy taken"
    end

    @id = record.identifier
    record.save

    puts "Registration successful"
  end
end