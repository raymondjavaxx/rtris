# frozen_string_literal: true

module Rtris
  module Core
    class HardDropTrail
      TIMELINE = Animation::Timeline.build do |timeline|
        timeline.lane(:opacity) do |lane|
          lane.keyframe(time: 0, value: 1, easing: :ease_out_cubic)
          lane.keyframe(time: 40, value: 0)
        end
      end

      attr_accessor :x, :y, :width

      def initialize(x, y)
        @x = x
        @y = y
        @frame = 0
      end

      def dead?
        @frame >= TIMELINE.total_duration
      end

      def tick
        @frame += 1
      end

      def opacity
        TIMELINE.value_at(:opacity, @frame)
      end
    end
  end
end
