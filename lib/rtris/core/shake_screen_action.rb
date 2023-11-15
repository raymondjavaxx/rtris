# frozen_string_literal: true

module Rtris
  module Core
    class ShakeScreenAction < Rtris::Action::TimelineAction
      TIMELINE = Rtris::Animation::Timeline.build do |t|
        t.lane(:y_offset) do |y_offset|
          y_offset.keyframe(time: 0, value: 0, easing: :ease_out_cubic)
          y_offset.keyframe(time: 5, value: 2, easing: :ease_out_cubic)
          y_offset.keyframe(time: 10, value: 0)
        end
      end

      def initialize(target)
        @target = target
        super(TIMELINE)
      end

      def tick
        super
        @target.y_offset = timeline.value_at(:y_offset, frame)
      end
    end
  end
end
