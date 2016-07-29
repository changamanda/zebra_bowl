class Frame < ApplicationRecord
  belongs_to :player
  include FrameBooleanMethods

  def initialize(object)
    super
    self.frame_number = object[:frame_number]
  end

  # Calls set_throw_value with the number of pins knocked down by the bowl
  # Returns the frame referenced by self
  def bowl(pins)
    raise_bowl_errors(pins)
    set_throw_value(pins)
    self
  end

  # Sets the appropriate throw attribute (:first_throw, :second_throw, or :third_throw) to pins
  def set_throw_value(pins)
    if two_throws?
      self.update(third_throw: pins)
    elsif first_throw
      self.update(second_throw: pins)
    else
      self.update(first_throw: pins)
    end
  end

  # Returns the sum of all throws in the current frame (0 for nil)
  def pins_sum
    self.first_throw.to_i + self.second_throw.to_i + self.third_throw.to_i
  end

  # Returns an array of all throws that have been set, in order
  def moves
    [first_throw, second_throw, third_throw].compact
  end

  # Sets the frame's cumulative_score attribute to total_score
  def update_cumulative_score(total_score)
    self.update(cumulative_score: total_score)
  end

  # Updates the score attribute of the frame, if possible
  # If next_frame is nil, strike and spare scores will not be updated
  # If next_next_frame is nil, double strike scores will not be updated
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

  # Returns an array representation of the frame: 'X' for strikes and '/' for spares
  def to_a
    moves = self.moves

    if strike?
      moves[0] = 'X'
    end

    if spare?
      moves[1] = '/'
    elsif self.second_throw.to_i == 10
      moves[1] = 'X'
    end

    if self.third_throw.to_i == 10
      moves[2] = 'X'
    elsif (self.third_throw && (self.second_throw.to_i + self.third_throw.to_i == 10))
      moves[2] = '/'
    end

    moves
  end

  # Returns an array of all moves in next_frame and next_next_frame
  def self.get_next_moves(next_frame, next_next_frame)
    moves = []
    moves += next_frame.moves if next_frame
    moves += next_next_frame.moves if next_next_frame
    moves
  end

  private

    def raise_bowl_errors(pins)
      if pins > 10
        raise 'Pins limit exceeded!'
      elsif !tenth_frame? && (pins_sum + pins) > 10
        raise 'Pins limit exceeded!'
      elsif complete?
        raise 'Throws already set.'
      end
    end
end
