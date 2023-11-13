# frozen_string_literal: true

module Rtris
  module Core
    class LineClearTextAnimation
      ANIMATION = Rtris::Animation::Timeline.build do |t|
        t.lane(:y_offset) do |y|
          y.keyframe(time: 0, value: 0, easing: :ease_out_quad)
          y.keyframe(time: 25, value: -100)
          y.keyframe(time: 60, value: -100)
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

      DURATION = 60

      def initialize(x, y, lines:, score:)
        @x = x
        @y = y
        @lines = lines
        @score = score
        @frame = 0
      end

      def dead?
        @frame >= DURATION
      end

      def tick
        @frame += 1
      end

      def draw(graphics)
        y_offset = ANIMATION.value_at(:y_offset, @frame)
        opacity = ANIMATION.value_at(:opacity, @frame)
        label2_opacity = ANIMATION.value_at(:label2_opacity, @frame)

        graphics.medium_font.draw_text_rel(
          @lines.to_s,
          @x,
          @y + y_offset,
          0,
          0.5,
          1,
          1,
          1,
          Gosu::Color.new((opacity * 255).to_i, 255, 255, 255)
        )

        graphics.medium_font.draw_text_rel(
          "+#{@score}",
          @x,
          @y + 64 + y_offset,
          0,
          0.5,
          1,
          1,
          1,
          Gosu::Color.new((opacity * label2_opacity * 255).to_i, 255, 255, 255)
        )
      end

      private

      def progress
        1 - (@lifespan.to_f / DEFAULT_LIFESPAN)
      end

      def opacity
        Easing.ease_out_quad(0.0, 1.0, progress)
      end

      def scale
        Easing.ease_out_quad(0.3, 1.0, progress)
      end
    end
  end
end
