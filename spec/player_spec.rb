require './game/game'
require './game/game_objects/player'

module GameObject
  RSpec.describe Player do
    subject { described_class.new 'fred' }

    let(:game) { TicTacToe.new }

    describe '#name' do
      it { expect( subject.name ).to eq 'fred' }
    end

    describe '.setup' do
      context 'with valid names' do
        before do
          allow($stdin).to receive(:gets).and_return('gs', 'as')
          described_class.setup game
        end

        it { expect( game.players.length ).to eq 2 }
        it { expect( game.players.first.name ).to eq 'gs' }
        it { expect( game.players.last.name ).to eq 'as' }
      end

      context 'with an invalid first attempt' do
        before do
          allow($stdin).to receive(:gets).and_return('too long', 'gs', 'as')
          described_class.setup game
        end

        it { expect( game.players.length ).to eq 2 }
        it { expect( game.players.first.name ).to eq 'gs' }
        it { expect( game.players.last.name ).to eq 'as' }
      end
    end

    describe '.update' do
      context 'with a winning stream of commands' do
        before do
          allow($stdin).to receive(:gets).and_return('gs', 'as', '11')
          allow(Command).to receive(:new) { instance_double Command,
            valid?: true, command: '11' }
          described_class.setup game
          described_class.update game
        end

        it { expect( game.command ).to eq '11' }
      end
    end
  end
end