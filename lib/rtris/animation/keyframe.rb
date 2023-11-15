# frozen_string_literal: true

module Rtris
  module Animation
    class Keyframe
      attr_accessor :time, :value, :easing

      def initialize(time:, value:, easing: :linear)
        @time = time
        @value = value.to_f
        @easing = easing
      end

      def to_s
        "Keyframe: #{value} at #{time} with #{easing} easing"
      end

      def <=>(other)
        time <=> other.time
      end

      def ==(other)
        value == other.value && time == other.time && easing == other.easing
      end

      def interpolate(other, time)
        return value if time <= self.time
        return other.value if time >= other.time

        t = (time - self.time).to_f / (other.time - self.time)
        t = send(easing, t)
        value + ((other.value - value) * t)
      end

      private

      def linear(t)
        t
      end

      def ease_in_quad(t)
        t * t
      end

      def ease_out_quad(t)
        t * (2 - t)
      end

      def ease_in_out_quad(t)
        t < 0.5 ? 2 * t * t : -1 + ((4 - (2 * t)) * t)
      end

      def ease_in_cubic(t)
        t * t * t
      end

      def ease_out_cubic(t)
        t -= 1
        (t * t * t) + 1
      end

      def ease_in_out_cubic(t)
        t *= 2
        return t * t * t / 2 if t < 1

        t -= 2
        (t * t * t / 2) + 1
      end
    end
  end
end
