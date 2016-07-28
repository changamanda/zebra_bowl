module FrameBooleanMethods
  def tenth_frame?
    self.frame_number == 10
  end

  def strike?
    self.first_throw == 10
  end

  def spare?
    (self.first_throw.to_i + self.second_throw.to_i) == 10 && !strike?
  end

  def two_throws?
    !!(self.first_throw && self.second_throw)
  end

  def three_throws?
    !!(self.first_throw && self.second_throw && self.third_throw)
  end

  def complete?
    if tenth_frame?
      (!strike? && !spare? && two_throws?) || three_throws?
    else
      two_throws? || strike?
    end
  end
end
