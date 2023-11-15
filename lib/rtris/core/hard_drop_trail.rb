# frozen_string_literal: true

module Rtris
  module Core
    class HardDropTrail < Rtris::Action::TimelineAction
      TIMELINE = Animation::Timeline.build do |timeline|
        timeline.lane(:opacity) do |lane|
          lane.keyframe(time: 0, value: 1, easing: :ease_out_cubic)
          lane.keyframe(time: 40, value: 0)
        end
      end

      def initialize(x, y)
        @x = x
        @y = y
        super(TIMELINE)
      end

      def draw(graphics)
        opacity = timeline.value_at(:opacity, @frame)
        graphics.draw_hard_drop_trail(x: @x, y: @y, opacity: opacity)
      end
    end
  end
end
