class Player < ApplicationRecord
  belongs_to :game
  has_many :frames

  def initialize(object = {})
    super
    self.frame_number = 1
    self.total_score = 0
    self.frames << Frame.new({frame_number: self.frame_number})
  end

  def bowl(pins)
    raise_bowl_errors
    current_frame.bowl(pins)
    if current_frame.complete?
      update_frame_scores
      increment_frame if !done?
    end
    self
  end

  def update_frame_scores
    sorted_frames = self.frames.sort
    sorted_frames.each_with_index do |frame, index|
      if !frame.score
        frame_score = frame.update_score(sorted_frames[index+1], sorted_frames[index+2])
        update_total_score(frame_score, frame)
      end
    end
  end

  def update_total_score(frame_score, frame)
    if frame_score
      self.update(total_score: total_score + frame_score)
      frame.update_cumulative_score(self.total_score)
    end
  end

  def current_frame
    self.frames.last
  end

  def increment_frame
    self.update(frame_number: frame_number+1) && self.frames << Frame.new({frame_number: self.frame_number})
  end

  def done?
    current_frame.complete? && self.frames.length == 10
  end

  private

    def raise_bowl_errors
      if done?
        raise "Game over!"
      end
    end
end
