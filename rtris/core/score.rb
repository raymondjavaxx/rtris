module Rtris::Core
  class Score
    attr_accessor :points, :lines

    @@lines_map = {
      1 => 100,
      2 => 300,
      3 => 500,
      4 => 800
    }

    def initialize
      @points = 0
      @lines = 0
      @level = 1
    end

    def add_lines(lines)
      @lines += lines
      @points += @@lines_map[lines] * @level
    end

    def soft_drop
      @points += 1
    end

    def hard_drop(delta)
      @points += (delta * 2)
    end
  end
end
