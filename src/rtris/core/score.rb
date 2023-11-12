# frozen_string_literal: true

module Rtris
  module Core
    class Score
      attr_accessor :points, :lines, :goal, :level

      LINES_MAP = {
        1 => 100,
        2 => 300,
        3 => 500,
        4 => 800
      }.freeze

      def initialize
        @points = 0
        @lines  = 0
        @level  = 9
        @goal   = @level * 5
      end

      def add_lines(lines)
        @lines += lines
        @points += LINES_MAP[lines] * @level

        @goal -= lines

        return unless @goal <= 0

        @level += 1
        @goal = @level * 5
      end

      def soft_drop
        @points += 1
      end

      def hard_drop(delta)
        @points += (delta * 2)
      end
    end
  end
end
