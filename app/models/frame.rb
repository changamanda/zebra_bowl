class Frame < ApplicationRecord
  belongs_to :player
  include FrameBooleanMethods

  def initialize(object)
    super
    self.frame_number = object[:frame_number]
  end

  def bowl(pins)
    raise_bowl_errors(pins)
    set_throw_value(pins)
    self
  end

  def set_throw_value(pins)
    if two_throws?
      self.update(third_throw: pins)
    elsif first_throw
      self.update(second_throw: pins)
    else
      self.update(first_throw: pins)
    end
  end

  def pins_sum
    self.first_throw.to_i + self.second_throw.to_i + self.third_throw.to_i
  end

  def moves
    [first_throw, second_throw, third_throw].compact
  end

  def update_cumulative_score(total_score)
    self.update(cumulative_score: total_score)
  end

  def update_score(next_frame, next_next_frame)
    moves = Frame.get_next_moves(next_frame, next_next_frame)
    if tenth_frame?
      self.update(score: pins_sum)
    elsif strike? && (moves.length > 1)
      self.update(score: pins_sum + moves[0] + moves[1])
    elsif spare? && (moves.length > 0)
      self.update(score: pins_sum + moves[0])
    elsif !strike? && !spare?
      self.update(score: pins_sum)
    end
    self.score
  end

  def <=>(other_frame)
    self.frame_number <=> other_frame.frame_number
  end

  def to_a
    moves = self.moves

    if strike?
      moves[0] = "X"
    end

    if spare?
      moves[1] = "/"
    elsif self.second_throw.to_i == 10
      moves[1] = "X"
    end

    if self.third_throw.to_i == 10
      moves[2] = "X"
    elsif (self.third_throw && (self.second_throw.to_i + self.third_throw.to_i == 10))
      moves[2] = "/"
    end

    moves
  end

  def self.get_next_moves(next_frame, next_next_frame)
    moves = []
    moves += next_frame.moves if next_frame
    moves += next_next_frame.moves if next_next_frame
    moves
  end

  private

    def raise_bowl_errors(pins)
      if pins > 10
        raise "Pins limit exceeded!"
      elsif !tenth_frame? && (pins_sum + pins) > 10
        raise "Pins limit exceeded!"
      elsif complete?
        raise "Throws already set."
      end
    end
end
