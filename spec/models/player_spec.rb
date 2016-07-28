require 'rails_helper'

RSpec.describe Player, type: :model do
  let!(:game){ Game.create(name: "Test game") }
  let!(:player){ game.players.build }

  describe '#initialize' do
    it 'can create a new player' do
      player.save
      expect(Player.last).to be_instance_of(Player)
    end

    it 'creates a player with a frame number' do
      expect(player.frame_number).to eq(1)
    end

    it 'creates a player with a total score' do
      expect(player.total_score).to eq(0)
    end

    it 'creates a player with the first frame' do
      expect(player.frames.length).to eq(1)
    end
  end

  describe '#bowl' do
    it 'can bowl and score a complex game' do
      # http://slocums.homestead.com/gamescore.html
      throws = [10, 7, 3, 9, 0, 10, 0, 8, 8, 2, 0, 6, 10, 10, 10, 8, 1]
      throws.each { |throw| player.bowl(throw) }

      expect(player.total_score).to eq(167)
      expect(player.frames.last.cumulative_score).to eq(167)
    end

    it 'can bowl and score a perfect game' do
      12.times { player.bowl(10) }

      expect(player.total_score).to eq(300)
      expect(player.frames.last.cumulative_score).to eq(300)
    end

    it 'throws an error if player bowls once game is over' do
      throws = [10, 7, 3, 9, 0, 10, 0, 8, 8, 2, 0, 6, 10, 10, 10, 8, 1]
      throws.each { |throw| player.bowl(throw) }

      expect {player.bowl(5)}.to raise_error("Game over!")
    end
  end
end
