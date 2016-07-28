require 'rails_helper'

RSpec.describe Frame, type: :model do
  let!(:game){ Game.create(name: "Test game") }
  let!(:player){ game.players.build }
  let(:frame){ player.frames.build({frame_number: 1}) }
  let(:open_frame){ player.frames.build({frame_number: 1}) }

  before(:each) do
    open_frame.bowl(3)
    open_frame.bowl(5)
  end

  describe '#initialize' do
    it 'can create a new frame' do
      expect(Frame.last).to be_instance_of(Frame)
    end
  end

  describe '#bowl' do
    it 'returns the Frame object' do
      expect(frame.bowl(3)).to be_instance_of(Frame)
    end

    it 'records scores for an open frame' do
      expect(open_frame.first_throw).to eq(3)
      expect(open_frame.second_throw).to eq(5)
    end

    it 'records scores for a strike' do
      frame.bowl(10)

      expect(frame.first_throw).to eq(10)
    end

    it 'records scores for a spare' do
      frame.bowl(6)
      frame.bowl(4)

      expect(frame.first_throw).to eq(6)
      expect(frame.second_throw).to eq(4)
    end

    it 'throws an error if throws limit is exceeded' do
      expect {open_frame.bowl(1)}.to raise_error('Throws already set.')
    end

    it 'throws an error if the pin sum exceeds 10' do
      frame.bowl(5)

      expect {frame.bowl(7)}.to raise_error('Pins limit exceeded!')
    end

    it 'throws an error if any roll exceeds 10' do
      expect {frame.bowl(13)}.to raise_error('Pins limit exceeded!')
    end
  end

  describe '#update_score' do
    it 'can update score for an open frame' do
      expect(open_frame.update_score(nil, nil)).to eq(8)
    end

    it 'can update score for a strike' do
      frame.bowl(10)

      expect(frame.update_score(open_frame, nil)).to eq(18)
    end

    it 'can update score for a spare' do
      frame.bowl(6)
      frame.bowl(4)

      expect(frame.update_score(open_frame, nil)).to eq(13)
    end

    it 'can update score for a double' do
      frame.bowl(10)

      next_frame = player.frames.build({frame_number: 2})
      next_frame.bowl(10)

      expect(frame.update_score(next_frame, open_frame)).to eq(23)
    end

    context 'for the last frame' do
      let(:last_frame){ player.frames.build({frame_number: 10}) }

      it 'can update score for an open frame' do
        last_frame.bowl(3)
        last_frame.bowl(5)

        expect(last_frame.update_score(nil, nil)).to eq(8)
      end

      it 'can update score for a strike' do
        last_frame.bowl(10)
        last_frame.bowl(3)
        last_frame.bowl(5)

        expect(last_frame.update_score(nil, nil)).to eq(18)
      end

      it 'can update score for a spare' do
        last_frame.bowl(7)
        last_frame.bowl(3)
        last_frame.bowl(5)

        expect(last_frame.update_score(nil, nil)).to eq(15)
      end

      it 'can update score for a double' do
        last_frame.bowl(10)
        last_frame.bowl(10)
        last_frame.bowl(5)

        expect(last_frame.update_score(nil, nil)).to eq(25)
      end
    end
  end

  describe '#to_a' do
    it 'can convert an open frame to an array' do
      expect(open_frame.to_a).to eq([3, 5])
    end

    it 'can convert a strike to an array' do
      frame.bowl(10)

      expect(frame.to_a).to eq(['X'])
    end

    it 'can convert a spare to an array' do
      frame.bowl(6)
      frame.bowl(4)

      expect(frame.to_a).to eq([6, '/'])
    end

    context 'for the last frame' do
      let(:last_frame){ player.frames.build({frame_number: 10}) }

      it 'can convert an open frame to an array' do
        last_frame.bowl(3)
        last_frame.bowl(5)

        expect(last_frame.to_a).to eq([3, 5])
      end

      it 'can convert a strike to an array' do
        last_frame.bowl(10)
        last_frame.bowl(3)
        last_frame.bowl(5)

        expect(last_frame.to_a).to eq(['X', 3, 5])
      end

      it 'can convert a spare to an array' do
        last_frame.bowl(7)
        last_frame.bowl(3)
        last_frame.bowl(5)

        expect(last_frame.to_a).to eq([7, '/', 5])
      end

      it 'can convert a double to an array' do
        last_frame.bowl(10)
        last_frame.bowl(10)
        last_frame.bowl(5)

        expect(last_frame.to_a).to eq(['X', 'X', 5])
      end

      it 'can convert a turkey to an array' do
        last_frame.bowl(10)
        last_frame.bowl(10)
        last_frame.bowl(10)

        expect(last_frame.to_a).to eq(['X', 'X', 'X'])
      end

      it 'can convert a strike then a spare to an array' do
        last_frame.bowl(10)
        last_frame.bowl(3)
        last_frame.bowl(7)

        expect(last_frame.to_a).to eq(['X', 3, '/'])
      end
    end
  end
end
