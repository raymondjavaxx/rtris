# frozen_string_literal: true

module Rtris
  module Core
    class LineClearTextAnimation < Rtris::Action::TimelineAction
      TIMELINE = Rtris::Animation::Timeline.build do |t|
        t.lane(:y_offset) do |y_offset|
          y_offset.keyframe(time: 0, value: 0, easing: :ease_out_cubic)
          y_offset.keyframe(time: 25, value: -100)
          y_offset.keyframe(time: 60, value: -100)
        end

        t.lane(:opacity) do |opacity|
          opacity.keyframe(time: 0, value: 0)
          opacity.keyframe(time: 9, value: 1)
          opacity.keyframe(time: 47, value: 1)
          opacity.keyframe(time: 55, value: 0)
        end

        t.lane(:label2_opacity) do |label2_opacity|
          label2_opacity.keyframe(time: 6, value: 0)
          label2_opacity.keyframe(time: 18, value: 1)
        end
      end

      LINE_CLEAR_TEXTS = {
        1 => 'SINGLE',
        2 => 'DOUBLE',
        3 => 'TRIPLE',
        4 => 'RTRIS'
      }.freeze

      def initialize(x, y, lines:, score:)
        @x = x
        @y = y
        @lines = lines
        @score = score
        super()
      end

      def dead?
        frame >= TIMELINE.total_duration
      end

      def draw(graphics)
        graphics.font(32).draw_text_rel(
          LINE_CLEAR_TEXTS[@lines],
          @x,
          @y + y_offset,
          0,
          0.5,
          1,
          1,
          1,
          Gosu::Color.new((opacity * 255).to_i, 255, 255, 255)
        )

        graphics.font(24).draw_text_rel(
          "+#{@score}",
          @x,
          @y + 32 + y_offset,
          0,
          0.5,
          1,
          1,
          1,
          Gosu::Color.new((opacity * label2_opacity * 255).to_i, 255, 255, 255)
        )
      end

      private

      def y_offset
        TIMELINE.value_at(:y_offset, frame)
      end

      def opacity
        TIMELINE.value_at(:opacity, frame)
      end

      def label2_opacity
        TIMELINE.value_at(:label2_opacity, frame)
      end
    end
  end
end
