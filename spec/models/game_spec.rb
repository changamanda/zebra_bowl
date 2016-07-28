require 'rails_helper'

RSpec.describe Game, type: :model do
  let!(:game){ Game.create(name: "Test game") }

  describe '#initialize' do
    it 'can create a new game' do
      expect(Game.last).to be_instance_of(Game)
    end

    it 'creates a game with a name' do
      expect(game.name).to eq("Test game")
    end

    it 'creates a game that has many players' do
      game.players.build
      expect(game.players.length).to eq(1)
    end
  end
end
