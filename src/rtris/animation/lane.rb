# frozen_string_literal: true

module Rtris
  module Animation
    class Lane
      def initialize(keyframes)
        @keyframes = keyframes
        @keyframes.sort!
        @keyframes.freeze

        @cached_values = {}

        _prime_cache!
      end

      def total_duration
        @keyframes.last&.time || 0
      end

      def value_at(time)
        @cached_values[time] ||= _value_at(time)
      end

      def to_s
        string = []
        string << 'Lane:'
        @keyframes.each do |keyframe|
          string << "  #{keyframe}"
        end
        string.join("\n")
      end

      private

      def _prime_cache!
        0.upto(total_duration) do |time|
          value_at(time)
        end
      end

      def _value_at(time)
        return @keyframes.first.value if time <= @keyframes.first.time
        return @keyframes.last.value if time >= @keyframes.last.time

        @keyframes.each_cons(2) do |a, b|
          return a.interpolate(b, time) if time >= a.time && time <= b.time
        end
      end
    end
  end
end
