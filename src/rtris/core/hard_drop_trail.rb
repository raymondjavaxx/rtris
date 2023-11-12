# frozen_string_literal: true

module Rtris
  module Core
    class HardDropTrail
      ##
      # Time in frames before the trail disappears.
      DEFAULT_LIFESPAN = 25

      attr_accessor :x, :y, :width

      def initialize(x, y)
        @x = x
        @y = y
        @lifespan = DEFAULT_LIFESPAN
      end

      def dead?
        @lifespan <= 0
      end

      def tick
        @lifespan -= 1
      end

      def opacity
        @lifespan.to_f / DEFAULT_LIFESPAN
      end
    end
  end
end
