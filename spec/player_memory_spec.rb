require './game/player_memory'
require './game/player'
require './game/game'
require 'json'

RSpec.describe PlayerMemory do
  subject { described_class.new game.player }

  let(:game) { Game.new :local }

  before do
    game.player.id = 'id-1'
    game.player.name = 'name-1'
  end

  after do
    game.memory.redis.del 'player-id-1'
  end

  describe '.new' do
    it { expect( subject ).to be_a PlayerMemory }
    it { expect( subject.player ).to eq game.player }
  end

  # describe '.authenticate' do
  #   let(:name) { 'Fred' }
  #   let(:password) { 'secret' }
  #   let(:code) { 'Z4pC' }
  #   let(:memory) { Memory.new }

  #   before do
  #     memory.connect
  #     memory.redis.set("user-#{ name }-#{ password }", code)
  #   end

  #   it { expect( subject.authenticate name, password ).to eq code }
  # end

  describe '#save/.find' do
    before { subject.save }

    it { expect( described_class.find 'id-1', game ).to be_a Player }
    it { expect( described_class.find('id-1', game).name ).to eq 'name-1' }
  end
end